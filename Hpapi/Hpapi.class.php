<?php

namespace Hpapi;

class Hpapi {

    public  $auth;                       // Object having successful authentication data for requested method
    public  $authenticationfunction;     // Object describing vendor/package/class/method for authentication
    public  $contentTypeRequested;       // Client declaration of content type
    public  $contentType;                // Interpretation of client contentheader for interpreting raw POST data
    private $db;                         // Database object \Hpapi\HpapiDb
    public  $object;                     // The PHP object loaded from the input which is modified and returned
    public  $remoteAddrPattern;          // REMOTE_ADDR matching pattern for the current key
    public  $datetime;                   // DateTime constructed from current server time
    public  $sprs;                       // Stored procedures available for the requested method
    public  $userUUID;                   // User identifier established by the authentication process

    public function __construct ( ) {
        if (count(func_get_args())) {
            throw new \Exception (HPAPI_STR_CONSTRUCT);
            return false;
        }
        error_reporting (HPAPI_PHP_ERROR_LEVEL);
        $this->datetime                             = new \DateTime ();
        if (HPAPI_SSL_ENFORCE && !$this->isHTTPS()) {
            header ('Content-Type: '.HPAPI_CONTENT_TYPE_TEXT);
            echo HPAPI_STR_SSL."\n";
            exit;
        }
        $this->contentType                          = $this->parseContentType ();
        try {
            $this->object                           = $this->decodePost ();
        }
        catch (\Exception $e) {
            header ('Content-Type: '.HPAPI_CONTENT_TYPE_TEXT);
            echo $e->getMessage()."\n";
            exit;
        }
        header ('Content-Type: '.$this->contentType);
        $this->object->response                     = new \stdClass ();
        $this->object->response->datetime           = null;
        $this->object->response->authStatus         = HPAPI_STR_AUTH_DENIED;
        $this->object->response->description        = HPAPI_META_DESCRIPTION;
        $this->object->response->splash             = array ();
        $this->object->response->error              = null;
        $this->object->response->warning            = null;
        $this->object->response->notice             = null;
        $this->object->response->remoteAddr         = $_SERVER['REMOTE_ADDR'];
        $this->object->response->serverAddr         = $_SERVER['SERVER_ADDR'];
        $this->object->response->datetime           = $this->datetime->format (\DateTime::ATOM);
        if (strlen(HPAPI_DIAGNOSTIC_KEYS)) {
            $this->diagnosticKeys                   = explode (',',HPAPI_DIAGNOSTIC_KEYS);
        }
        else {
            $this->diagnosticKeys                   = array ();
        }
        if (in_array($this->object->key,$this->diagnosticKeys)) {
                $this->object->diagnostic           = '';
        }
        if (!property_exists($this->object,'key')) {
            $this->object->response->error          = HPAPI_STR_KEY;
            $this->end ();
        }
        if (!property_exists($this->object,'email')) {
            $this->object->response->error          = HPAPI_STR_EMAIL;
            $this->end ();
        }
        if (!property_exists($this->object,'password')) {
            $this->object->response->error          = HPAPI_STR_PASSWORD;
            $this->end ();
        }
        if (!property_exists($this->object,'datetime')) {
            $this->object->response->error          = HPAPI_STR_DATETIME;
            $this->end ();
        }
        if (!property_exists($this->object,'method')) {
            $this->object->response->error          = HPAPI_STR_METHOD;
            $this->end ();
        }
        if (!is_object($this->object->method)) {
            $this->object->response->error          = HPAPI_STR_METHOD_OBJ;
            $this->end ();
        }
        try {
            $this->db                               = new \Hpapi\Db ($this,HPAPI_DB_DSN,HPAPI_DB_USR,HPAPI_DB_PWD);
        }
        catch (\Exception $e) {
            $this->object->response->notice         = $e->getMessage ();
            $this->object->response->error          = HPAPI_STR_DB_OBJ;
            $this->end ();
        }
        $this->authenticate ();
        $this->object->response->returnValue        = $this->executeMethod ($this->object->method);
        $this->end ();
    }

    public function __destruct ( ) {
    }

    public function addSplash ($message) {
        array_push ($this->object->response->splash,$message);
    }

    public function accessControl ( ) {
        try {
            $auth                                   = $this->db->call (
                'hpapiAuthDetails'
                ,$this->object->key
                ,$this->object->email
            );
        }
        catch (\Exception $e) {
            $this->object->response->notice         = $e->getMessage ();
            $this->object->response->error          = HPAPI_STR_ERROR_DB;
            $this->end ();
        }
        if (!count($auth)) {
            $this->object->response->error          = HPAPI_STR_AUTH_DENIED;
            $this->end ();
        }
        $auth                                       = $auth[0];
        if (!$auth['userFound']) {
            $this->object->response->authStatus     = HPAPI_STR_AUTH_RECOG;
            if (HPAPI_ANON_LEVEL<=HPAPI_ANON_LEVEL_USER) {
                $this->object->response->error      = HPAPI_STR_AUTH_DENIED;
                $this->end ();
            }
            $this->object->email                    = '';
        }
        elseif (!$auth['userActive']) {
            $this->object->response->authStatus     = HPAPI_STR_AUTH_ACTIVE;
            if (HPAPI_ANON_LEVEL<=HPAPI_ANON_LEVEL_USER) {
                $this->object->response->error      = HPAPI_STR_AUTH_DENIED;
                $this->end ();
            }
            $this->object->email                    = '';
        }
        if (!$auth['emailFound']) {
            $this->object->response->authStatus     = HPAPI_STR_AUTH_EMAIL;
            if (HPAPI_ANON_LEVEL<=HPAPI_ANON_LEVEL_EMAIL) {
                $this->object->response->error      = HPAPI_STR_AUTH_DENIED;
                $this->end ();
            }
            $this->object->email                    = '';
        }
        elseif (!$auth['emailVerified']) {
            $this->object->response->authStatus     = HPAPI_STR_AUTH_VERIFY;
            if (HPAPI_ANON_LEVEL<=HPAPI_ANON_LEVEL_EMAIL) {
                $this->object->response->error      = HPAPI_STR_AUTH_DENIED;
                $this->end ();
            }
            $this->object->email                    = '';
        }
        if (strlen($this->object->email) && password_verify($this->object->password,$auth['passwordHash'])) {
            $this->object->response->authStatus     = HPAPI_STR_AUTH_OK;
        }
        else {
            $this->object->response->authStatus     = HPAPI_STR_AUTH_PWD;
            if (HPAPI_ANON_LEVEL<=HPAPI_ANON_LEVEL_NONE) {
                $this->object->response->error      = HPAPI_STR_AUTH_DENIED;
                $this->end ();
            }
            $this->object->email                    = '';
        }
    }

    public function authenticate ( ) {
        $this->accessControl ();
        try {
            $method_args                            = $this->db->call (
                'hpapiMethodargs'
               ,$this->object->key
               ,$this->object->email
               ,$this->object->method->vendor
               ,$this->object->method->package
               ,$this->object->method->class
               ,$this->object->method->method
            );
        }
        catch (\Exception $e) {
            $this->object->response->notice         = $e->getMessage ();
            $this->object->response->error          = HPAPI_STR_ERROR_DB;
            $this->end ();
        }
        try {
            $this->auth                             = $this->parseAuthMethod ($method_args);
        }
        catch (\Exception $e) {
            $this->object->response->notice         = $e->getMessage ();
            $this->object->response->error          = HPAPI_STR_AUTH;
            $this->end ();
        }
        try {
            $spr_args                               = $this->db->call (
                'hpapiSprargs'
               ,$this->object->method->vendor
               ,$this->object->method->package
               ,$this->object->method->class
               ,$this->object->method->method
            );
        }
        catch (\Exception $e) {
            $this->object->response->notice         = $e->getMessage ();
            $this->object->response->error          = HPAPI_STR_ERROR_DB;
            $this->end ();
        }
        $this->sprs                                 = $this->parseAuthSprs ($spr_args);
        return true;
    }

    public function classPath ($method) {
        $path           = HPAPI_DIR_HPAPI.'/'.$method->vendor.'/'.$method->package;
        $path          .= str_replace ("\\",'/',$method->class);
        $path          .= HPAPI_CLASS_SUFFIX;
        return $path;
    }

    public function dbCall ( ) {
        $arguments          = func_get_args ();
        $spr                = (string) array_shift ($arguments);
        if (!strlen($spr)) {
            throw new \Exception (HPAPI_STR_DB_SPR_MISSING);
            return false;
        }
        if (!array_key_exists($spr,$this->sprs)) {
            throw new \Exception (HPAPI_STR_DB_SPR_ACCESS);
            return false;
        }
        if (count($arguments)!=count($this->sprs[$spr]->arguments)) {
            throw new \Exception (HPAPI_STR_DB_SPR_ARGS);
            return false;
        }
        $count = 0;
        foreach ($this->sprs[$spr]->arguments AS $arg) {
            try {
                $this->validation ($spr,$count+1,$arguments[$count],$arg);
            }
            catch (\Exception $e) {
                throw new \Exception (HPAPI_STR_DB_SPR_ARG_VAL.': '.$e->getMessage());
                return false;
            }
            $count++;
        }
        try {
            $return         = $this->db->call ($spr,...$arguments);
        }
        catch (\Exception $e) {
            throw new \Exception ($e->getMessage());
            return false;
        }
        return $return;
    }

    public function decodePost ( ) {
        $post           = file_get_contents ('php://input');
        if (strlen($post)>HPAPI_POST_BYTES_MAX) {
            throw new \Exception (HPAPI_DECODE_LENGTH.' ( >'.HPAPI_POST_BYTES_MAX.'B )');
            return false;
        }
        if ($this->contentType==HPAPI_CONTENT_TYPE_JSON) {
            try {
                $json   = json_decode ($post,false,HPAPI_JSON_DEPTH);
            }
            catch (\Exception $e) {
                throw new \Exception (HPAPI_STR_JSON_DECODE);
                return false;
            }
            return $json;
        }
        if ($this->contentType==HPAPI_CONTENT_TYPE_HTML) {
            try {
                $html   = $this->htmlDecode ($post);
            }
            catch (\Exception $e) {
                throw new \Exception (HPAPI_STR_HTML_DECODE.' ('.$e->getMessage().')');
            }
            return $html;
        }
        else {
            throw new \Exception (HPAPI_STR_DECODE_TYPE.' '.$this->contentTypeRequested);
            return false;
        }
    }

    public function definitionPath ($path) {
        $paths = array ();
        foreach (scandir($path) as $f) {
            if (!preg_match('<^.*\.dfn\.php$>',$f)) {
                continue;
            }
            array_push ($paths,$path.'/'.$f);
        }
        return $paths;
    }

    public function end ( ) {
        if (property_exists($this->object,'key')) {
            unset ($this->object->key);
        }
        if (property_exists($this->object,'email')) {
            unset ($this->object->email);
        }
        if (property_exists($this->object,'password')) {
            unset ($this->object->password);
        }
        if ($this->contentType==HPAPI_CONTENT_TYPE_JSON) {
            echo json_encode ($this->object,HPAPI_JSON_OPTIONS,HPAPI_JSON_DEPTH);
            echo "\n";
            exit;
        }
        if ($this->object->contentType==HPAPI_CONTENT_TYPE_HTML) {
            echo $this->htmlEncode ($this->object);
            echo "\n";
            exit;
        }
        var_export ($this->object);
        echo "\n";
        exit;
    }

    public function executeMethod ($m) {
        if (!property_exists($m,'vendor')) {
            $this->object->response->error          = HPAPI_STR_METHOD_VDR;
            $this->end ();
        }
        if (gettype($m->vendor)!='string') {
            $this->object->response->error          = HPAPI_STR_METHOD_VDR_STR;
            $this->end ();
        }
        if (!is_dir($this->vendorPath($m))) {
            $this->object->response->error          = HPAPI_STR_METHOD_VDR_PTH;
            $this->end ();
        }
        if (!property_exists($m,'package')) {
            $this->object->response->error          = HPAPI_STR_METHOD_PKG;
            $this->end ();
        }
        if (gettype($m->package)!='string') {
            $this->object->response->error          = HPAPI_STR_METHOD_PKG_STR;
            $this->end ();
        }
        if (!is_dir($package_path=$this->packagePath($m))) {
            $this->object->response->error          = HPAPI_STR_METHOD_PKG_PTH;
            $this->end ();
        }
        if (!property_exists($m,'class')) {
            $this->object->response->error          = HPAPI_STR_METHOD_CLS;
            $this->end ();
        }
        if (gettype($m->class)!='string') {
            $this->object->response->error          = HPAPI_STR_METHOD_CLS_STR;
            $this->end ();
        }
        if (!file_exists($file=$this->classPath($m))) {
            $this->object->response->error          = HPAPI_STR_METHOD_CLS_PTH;
            $this->object->response->error         .= ' - "'.str_replace ("\\",'/',$m->class);
            $this->object->response->error         .= HPAPI_CLASS_SUFFIX.'"';
            $this->end ();
        }
        if (!property_exists($m,'method')) {
            $this->object->response->error          = HPAPI_STR_METHOD_MTD;
            $this->end ();
        }
        if (gettype($m->method)!='string') {
            $this->object->response->error          = HPAPI_STR_METHOD_MTD_STR;
            $this->end ();
        }
        if (!property_exists($m,'arguments')) {
            $this->object->response->error          = HPAPI_STR_METHOD_ARGS;
            $this->end ();
        }
        if (!is_array($m->arguments)) {
            $this->object->response->error          = HPAPI_STR_METHOD_ARGS_ARR;
            $this->end ();
        }
        if (count($m->arguments)!=count($this->auth->arguments)) {
              $this->object->response->error        = HPAPI_STR_DB_MTD_ARGS;
              $this->end ();
        }
        $count                                      = 0;
        foreach ($this->auth->arguments AS $arg) {
            try {
                $this->validation ($m->method,$count+1,$m->arguments[$count],$arg);
            }
            catch (\Exception $e) {
                $this->object->response->notice     = $e->getMessage ();
                $this->object->response->error      = HPAPI_STR_DB_MTD_ARG_VAL;
                $this->end ();
            }
            $count++;
        }
        foreach ($this->definitionPath($package_path) as $package_dfn) {
            try {
                require_once $package_dfn;
            }
            catch (\Exception $e) {
                if (in_array($this->object->key,$this->diagnosticKeys)) {
                    $this->hpapi->object->diagnostic .= $e->getMessage()."\n";
                }
                $this->object->response->error      = HPAPI_STR_METHOD_DFN_INC;
                $this->end ();
            }
        }
        try {
            require_once $file;
        }
        catch (\Exception $e) {
            $this->object->response->notice         = $e->getMessage ();
            $this->object->response->error          = HPAPI_STR_METHOD_CLS_INC;
            $this->end ();
        }
        if (!class_exists($class=$m->class)) {
            $this->object->response->error          = HPAPI_STR_METHOD_CLS_GOT;
            $this->end ();
        }
        try {
            $object                                 = new $class ($this);
        }
        catch (\Exception $e) {
            $this->object->response->notice         = $e->getMessage ();
            $this->object->response->error          = HPAPI_STR_METHOD_CLS_NEW;
            $this->end ();
        }
        if (!method_exists($object,$m->method)) {
            $this->object->response->error          = HPAPI_STR_METHOD_MTD_GOT;
            $this->end ();
        }
        try {
            $return_value                           = $object->{$m->method} (...$m->arguments);
        }
        catch (\Exception $e) {
            $this->object->response->notice         = $e->getMessage ();
            $this->object->response->error          = HPAPI_STR_METHOD_EXCEPTION;
            $this->end ();
        }
        return $return_value;
    }

    public function htmlDecode ($post) {
        throw new \Exception (HPAPI_DECODE_HTML_SUPPORT);
        return false;
    }

    public function htmlEncode ( ) {
        // HTML is not yet supported
        $output     = "/* HTML not yet supported */\n";
        $output    .= var_export ($this->object,true);
        return $output;
    }

    public function isHTTPS ( ) {
        if (!array_key_exists('HTTPS',$_SERVER)) {
            return false;
        }
        if (empty($_SERVER['HTTPS'])) {
            return false;
        }
        if ($_SERVER['HTTPS']=='off') {
            return false;
        }
        return true;
    }

    public function packagePath ($method) {
        $path   = HPAPI_DIR_HPAPI;
        $path  .= '/'.$method->vendor;
        $path  .= '/'.$method->package;
        return $path;
    }

    public function parse2d ($data) {
        if (!is_array($data)) {
            throw new \Exception (HPAPI_STR_2D_ARRAY);
            return false;
        }
        $ol = array ();
        foreach ($data as $row) {
            if (!is_array($row)) {
                throw new \Exception (HPAPI_STR_2D_ARRAY);
                return false;
            }
            $item = new \stdClass ();
            foreach ($row as $k=>$v) {
                $item->$k = $v;
            }
            array_push ($ol,$item);
        }
        return $ol;
    }

    public function parseAuthMethod ($m_args) {
        if (!count($m_args)) {
            throw new \Exception (HPAPI_STR_DB_MTD_ACCESS);
            return false;
        }
        if (!preg_match('<'.$m_args[0]['remoteAddrPattern'].'>',$_SERVER['REMOTE_ADDR'])) {
            throw new \Exception (HPAPI_STR_DB_MTD_LOCN);
            return false;
        }
        $this->userUUID                                                     = $m_args[0]['userUUID'];
        $this->remoteAddrPattern                                            = $m_args[0]['remoteAddrPattern'];
        $method                                                             = new \stdClass ();
        $method->label                                                      = $m_args[0]['label'];
        $method->notes                                                      = $m_args[0]['notes'];
        $method->arguments                                                  = array ();
        if ($m_args[0]['argument']) {
            foreach ($m_args as $m_arg) {
                unset ($m_arg['remoteAddrPattern']);
                unset ($m_arg['label']);
                unset ($m_arg['notes']);
                $arg                                                        = new \stdClass ();
                foreach ($m_arg as $k=>$v) {
                    $arg->$k                                                = $v;
                }
                array_push ($method->arguments,$arg);
            }
        }
        return $method;
    }

    public function parseAuthSprs ($spr_args) {
        $sprs                                                               = array ();
        if (count($spr_args)==1 && !$spr_args[0]['spr']) {
            // Null result row
            return $sprs;
        }
        foreach ($spr_args as $spr_arg) {
            if (!array_key_exists($spr_arg['spr'],$sprs)) {
                $sprs[$spr_arg['spr']]                                      = new \stdClass ();
                $sprs[$spr_arg['spr']]->notes                                = $spr_arg['notes'];
                $sprs[$spr_arg['spr']]->arguments                           = array ();
            }
            if (!$spr_arg['argument']) {
                break;
            }
            if (!array_key_exists($spr_arg['argument']-1,$sprs[$spr_arg['spr']]->arguments)) {
                $sprs[$spr_arg['spr']]->arguments[$spr_arg['argument']-1]   = new \stdClass ();
            }
            foreach ($spr_arg as $k=>$v) {
                if ($k=='spr') {
                    continue;
                }
                if ($k=='notes') {
                    continue;
                }
                $sprs[$spr_arg['spr']]->arguments[$spr_arg['argument']-1]->$k = $v;
            }
        }
        return $sprs;
    }

    public function parseContentType ( ) {
        if (!array_key_exists('CONTENT_TYPE',$_SERVER)) {
            $this->contentTypeRequested = HPAPI_CONTENT_TYPE_UNKNOWN;
            return HPAPI_CONTENT_TYPE_TEXT;
        }
        $type = strtolower ($_SERVER['CONTENT_TYPE']);
        $type = explode (';',$type);
        $type = array_shift ($type);
        $this->contentTypeRequested = $type;
        $type = explode ('/',$type);
        $type = array_pop ($type);
        if ($type=='json') {
            return HPAPI_CONTENT_TYPE_JSON;
        }
        if ($type=='html') {
            return HPAPI_CONTENT_TYPE_HTML;
        }
        return HPAPI_CONTENT_TYPE_TEXT;
    }

    public function passwordHash ($plain) {
        return password_hash ($plain,HPAPI_HASH_ALGO,array('cost'=>HPAPI_HASH_COST));
    }

    public function validation ($name,$argNum,$value,$defn) {
        if ($defn->emptyAllowed && !strlen($value)) {
            return true;
        }
        $e          = null;
        if (strlen($defn->expression) && !preg_match('<'.$defn->expression.'>',$value)) {
            $e      = HPAPI_STR_VALID_EXPRESSION.' <'.$defn->expression.'>';
        }
        elseif (strlen($defn->phpFilter) && filter_var($value,constant($defn->phpFilter))===false) {
            $e      = HPAPI_STR_VALID_PHP_FILTER.' '.$defn->phpFilter;
        }
        elseif ($defn->lengthMinimum>0 && strlen($value)<$defn->lengthMinimum) {
            $e      = HPAPI_STR_VALID_LMIN.' '.$defn->lengthMinimum;
        }
        elseif ($defn->lengthMaximum>0 && strlen($value)>$defn->lengthMaximum) {
            $e      = HPAPI_STR_VALID_LMAX.' '.$defn->lengthMaximum;
        }
        elseif (strlen($defn->valueMinimum) && $value<$defn->valueMinimum) {
            $e      = HPAPI_STR_VALID_VMIN.' '.$defn->valueMinimum;
        }
        elseif (strlen($defn->valueMaximum) && $value>$defn->valueMaximum) {
            $e      = HPAPI_STR_VALID_VMAX.' '.$defn->valueMaximum;
        }
        else {
            return true;
        }
        $cstr       = $defn->constraints;
        if (defined($defn->constraints)) {
            $cstr   = constant ($defn->constraints);
        }
        $this->addSplash ($defn->name.' '.$cstr);
        throw new \Exception ($name.'['.$argNum.']: '.$e);
        return false;
    }

    public function vendorPath ($method) {
        $path   = HPAPI_DIR_HPAPI;
        $path  .= '/'.$method->vendor;
        return $path;
    }

}

?>
