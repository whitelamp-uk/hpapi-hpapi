<?php

namespace Hpapi;

class Db {

    private $calls          = array ();
    private $DSN;
    public  $errors         = array ();
    private $filter;
    public  $hpapi;
    public  $inputs;
    public  $notices        = array ();
    private $PDO;
    private $sprCmd; // eg. CALL (), SELECT () OR EXEC () keyword
    private $type;
    private $types          = array ('dblib','mysql','pgsql');

    public function __construct (\Hpapi\Hpapi $hpapi,$dsn,$sprCmd,$usr,$pwd) {
        $this->hpapi        = $hpapi;
        $this->DSN          = $dsn;
        $this->sprCmd       = $sprCmd;
        $this->connect ($dsn,$usr,$pwd);
        return true;
    }

    public function __destruct ( ) {
        $this->close ();
    }

    public function call ( ) {
        // Process inputs
        $args               = func_get_args ();
        $spr                = array_shift ($args);
        if (!$spr) {
            throw new \Exception (HPAPI_STR_DB_SPR_Z);
            return false;
        }
        // Bind placeholders
        $phs                = array ();
        foreach ($args as $i=>$arg) {
            array_push ($phs,'?');
        }
        // Construct query, safely bind arguments, execute query and return results
        $query              = $this->sprCmd.' '.$spr.'('.implode(',',$phs).')';
        try {
            $stmt           = $this->PDO->prepare ($query);
        }
        catch (\PDOException $e) {
            throw new \Exception (HPAPI_STR_DB_SPR_PREP.' - '.$spr.' ('.$e.')');
            return false;
        }
        foreach ($args as $i=>$arg) {
            try {
                $arg        = $this->pdoCast ($arg);
                $stmt->bindValue (($i+1),$arg[0],$arg[1]);
            }
            catch (\PDOException $e) {
                throw new \Exception (HPAPI_STR_DB_SPR_BIND.' - '.$spr.' ('.$e.')');
                return false;
            }
        }
        try {
            $stmt->execute ();
        }
        catch (\PDOException $e) {
            if (in_array($this->hpapi->object->key,$this->hpapi->diagnosticKeys)) {
                $this->hpapi->object->diagnostic   .= HPAPI_STR_DB_SPR_EXEC.' - '.$spr.' ('.$e->getMessage().')'."\n";
            }
            throw new \Exception (HPAPI_STR_ERROR_DB);
            return false;
        }
        try {
            $data           =  $stmt->fetchAll (\PDO::FETCH_ASSOC);
            $stmt->closeCursor ();
        }
        catch (\PDOException $e) {
            // Successful execution but no data was fetched
            return true;
        }
        return $data;
    }

    public function close ( ) {
        if ($this->type=='pgsql') {
            try {
                $this->PDO->query ('SELECT pg_terminate_backend(pg_backend_pid());');
            }
            catch (\PDOException $e) {
                // At least we tried...
            }
        }
        $this->PDO = null;
    }

    private function connect ($dsn,$usr,$pwd) {
        if (is_object($this->PDO)) {
            return true;
        }
        $type               = explode (':',$dsn);
        $type               = array_shift ($type);
        if (!in_array($type,$this->types)) {
            throw new \Exception (HPAPI_STR_DB_TYPE);
            return false;
        }
        try {
            $this->PDO      = new \PDO ($dsn,$usr,$pwd,array(\PDO::ATTR_ERRMODE=>\PDO::ERRMODE_EXCEPTION));
        }
        catch (\PDOException $e) {
            throw new \Exception ('HPAPI_STR_DB_CONN');
            return false;
        }
        $this->DSN          = $dsn;
        $this->type         = $type;
        return true;
    }

    public function pdoCast ($value) {
            // Force change of data type
            if (is_bool($value)) {
                if ($value) {
                    $value  = 1;
                }
                else {
                    $value  = 0;
                }
            }
            elseif (is_double($value)) {
                $value     .= '';
            }
            // Select correct parameter type
            if (is_null($value)) {
                $type       = \PDO::PARAM_NULL;
            }
            elseif (is_integer($value)) {
                $type       = \PDO::PARAM_INT;
            }
            elseif (is_string($value)) {
                $type       = \PDO::PARAM_STR;
            }
            else {
                throw new \Exception (HPAPI_STR_DB_SPR_ARG_TYPE);
                return false;
            }
            return array ($value,$type);
    }

}

?>
