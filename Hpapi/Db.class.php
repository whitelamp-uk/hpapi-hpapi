<?php

namespace Hpapi;

class Db {

    private $cfg;
    private $dfn;
    private $DSN;
    private $filter;
    public  $hpapi;
    public  $inputs;
    public  $model;
    private $node;
    private $PDO;
    private $sprCmd; // eg. CALL (), SELECT () OR EXEC () keyword

    public function __construct (\Hpapi\Hpapi $hpapi,$node,$model) {
        $this->hpapi        = $hpapi;
        try {
            $this->node     = $node;
            $cfgs           = file_get_contents (HPAPI_SYSTEM_DB_CFG_JSON);
            $cfgs           = $hpapi->jsonDecode ($cfgs,false,HPAPI_JSON_DEPTH);
            foreach  ($cfgs as $cfg) {
                if ($cfg->node!=$this->node) {
                    continue;
                }
                $this->cfg  = $cfg;
                foreach  ($cfg->models as $m) {
                    if ($m->model!=$model) {
                        continue;
                    }
                    $this->model = $m;
                    break;
                }
                if (!$this->model) {
                    throw new \Exception (HPAPI_STR_DB_CFG.' [3]');
                    return false;
                }
                break;
            }
            if (!$this->cfg) {
                throw new \Exception (HPAPI_STR_DB_CFG.' [2]');
                return false;
            }
        }
        catch (\Exception $e) {
            throw new \Exception (HPAPI_STR_DB_CFG.' [1]');
            return false;
        }
        try {
            $drv            = explode (':',$this->model->dsn);
            $drv            = array_shift ($drv);
            $dfns           = file_get_contents (HPAPI_SYSTEM_DB_DFN_JSON);
        }
        catch (\Exception $e) {
            throw new \Exception (HPAPI_STR_DB_DFN.' [1]');
            return false;
        }
        try {
           $dfns           = $hpapi->jsonDecode ($dfns,false,HPAPI_JSON_DEPTH);
        }
        catch (\Exception $e) {
            throw new \Exception (HPAPI_STR_DB_DFN.' [2]: '.$e->getMessage());
            return false;
        }
        try {
            foreach  ($dfns as $dfn) {
                if ($dfn->driver!=$drv) {
                    continue;
                }
                $this->dfn  = $dfn;
                break;
            }
            if (!$this->dfn) {
                throw new \Exception (HPAPI_STR_DB_DFN.' [4]');
                return false;
            }
        }
        catch (\Exception $e) {
            throw new \Exception (HPAPI_STR_DB_DFN.' [3]');
            return false;
        }
        $this->connect ();
        return true;
    }

    public function __destruct ( ) {
        $this->close ();
    }

    public function call ( ) {
        // Process inputs
        $args               = func_get_args ();
        try {
            $spr            = (string) array_shift ($args);
            if(!strlen($spr)) {
                throw new \Exception (HPAPI_STR_DB_EMPTY);
                return false;
            }
        }
        catch (\Exception $e) {
            throw new \Exception (HPAPI_STR_DB_EMPTY);
            return false;
        }
        try {
            // Query for a stored procedure
            $q              = $this->dfn->query->spr;
            $q              = str_replace ('<spr/>',$spr,$q);
            // Binding placeholders
            $b              = array ();
            foreach ($args as $i=>$arg) {
                array_push ($b,'?');
            }
            $b              = implode (',',$b);
            $q              = str_replace ('<csv-bindings/>',$b,$q);
        }
        catch (\Exception $e) {
            throw new \Exception (HPAPI_STR_DB_SPR_PREP.' [1] - '.$spr.' ('.$e.')');
            return false;
        }
        try {
            // SQL statement
            $stmt           = $this->PDO->prepare ($q);
        }
        catch (\PDOException $e) {
            throw new \Exception (HPAPI_STR_DB_SPR_PREP.' [2] - '.$spr.' ('.$e.')');
            return false;
        }
        foreach ($args as $i=>$arg) {
            // Bind value to placeholder
            try {
                (array)$arg = $this->pdoCast ($arg);
                $stmt->bindValue (($i+1),$arg[0],$arg[1]);
            }
            catch (\PDOException $e) {
                throw new \Exception (HPAPI_STR_DB_SPR_BIND.' - '.$spr.' ('.$e.')');
                return false;
            }
        }
        try {
            // Execute SQL statement
            $stmt->execute ();
        }
        catch (\PDOException $e) {
            // Execution failed
            if (in_array($this->hpapi->object->key,$this->hpapi->diagnosticKeys)) {
                $this->hpapi->object->diagnostic   .= HPAPI_STR_DB_SPR_EXEC.' - '.$spr.' ('.$e->getMessage().')'."\n";
            }
            throw new \Exception (HPAPI_STR_ERROR_DB);
            return false;
        }
        try {
            // Execution OK, fetch data (if any was returned)
            $data           =  $stmt->fetchAll (\PDO::FETCH_ASSOC);
            $stmt->closeCursor ();
        }
        catch (\PDOException $e) {
            // Execution OK, no data fetched
            return true;
        }
        // Execution OK, data fetched
        return $data;
    }

    public function close ( ) {
        if ($this->dfn->driver=='pgsql') {
            try {
                $this->PDO->query ('SELECT pg_terminate_backend(pg_backend_pid());');
            }
            catch (\PDOException $e) {
                // At least we tried...
            }
        }
        $this->PDO          = null;
    }

    private function connect ( ) {
        if (is_object($this->PDO)) {
            return true;
        }
        try {
            $this->PDO      = new \PDO (
                $this->model->dsn
               ,$this->cfg->dbUsr
               ,$this->cfg->dbPwd
               ,array (\PDO::ATTR_ERRMODE=>\PDO::ERRMODE_EXCEPTION)
            );
        }
        catch (\PDOException $e) {
            throw new \Exception ('HPAPI_STR_DB_CONN');
            return false;
        }
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
