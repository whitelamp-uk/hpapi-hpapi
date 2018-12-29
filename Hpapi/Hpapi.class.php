<?php

/* Copyright 2018 Whitelamp http://www.whitelamp.com/ */

namespace Hpapi;

class Hpapi {

    public      $contentType;                // Interpretation of client contentheader for interpreting raw POST data
    public      $contentTypeRequested;       // Client declaration of content type
    protected   $db;                         // Database object \Hpapi\HpapiDb
    public      $datetime;                   // DateTime of response (can be faked for matching time-based test data)
    public      $email;                      // Email contained in request
    public      $groupsAllowed   = array (); // Usergroups for this user
    public      $groupsAvailable = array (); // Usergroups for this user
    public      $logtime;                    // DateTime of response for logging (never faked)
    public      $microtime;                  // Microtime of response (decimal fraction of a second)
    public      $object;                     // The PHP object loaded from the input which is modified and returned
    protected   $privilege;                  // Privilege array for this vendor::package::class::method
    public      $remoteAddrPattern;          // REMOTE_ADDR matching pattern for the current key
    public      $returnDiagnostic;           // Microtime of response (decimal fraction of a second)
    public      $timestamp;                  // Timestamp (never faked)
    public      $token;                      // Token to be returned
    public      $tokenDurationMinutes = 0;   // Length of "session"
    public      $tokenExpiry;                // Expire time in seconds
    public      $tokenExtend;                // Boolean - extend token on each authenticated request
    public      $userId = 0;                 // User unique numeric identifier

    public function __construct ( ) {
        if (count(func_get_args())) {
            throw new \Exception (HPAPI_STR_CONSTRUCT);
            return false;
        }
        error_reporting (HPAPI_PHP_ERROR_LEVEL);
        $this->timestamp                            = time ();
        $this->setTokenExpiry ($this->timestamp+(60*HPAPI_TOKEN_LIFE_MINS));
        $this->setTokenExtend (HPAPI_TOKEN_LIFE_EXTEND);
        $now                                        = '@'.$this->timestamp;
        if (defined('HPAPI_DIAGNOSTIC_FAKE_NOW') && strlen(HPAPI_DIAGNOSTIC_FAKE_NOW)) {
            $now                                    = HPAPI_DIAGNOSTIC_FAKE_NOW;
        }
        $this->datetime                             = new \DateTime ($now);
        $this->microtime                            = explode(' ',microtime())[0];
        if (HPAPI_SSL_ENFORCE && !$this->isHTTPS()) {
            header ('Content-Type: '.HPAPI_CONTENT_TYPE_TEXT);
            $this->logLast (HPAPI_STR_SSL."\n");
            echo HPAPI_STR_SSL."\n";
            exit;
        }
        $this->contentType                          = $this->parseContentType ();
        try {
            $this->object                           = $this->decodePost ();
        }
        catch (\Exception $e) {
            header ('Content-Type: '.HPAPI_CONTENT_TYPE_TEXT);
            $this->logLast ($e->getMessage()."\n");
            echo $e->getMessage()."\n";
            exit;
        }
        header ('Content-Type: '.$this->contentType);
        $this->object->response                     = new \stdClass ();
        $this->object->response->datetime           = null;
        $this->object->response->authStatus         = null;
        $this->object->response->description        = HPAPI_META_DESCRIPTION;
        $this->object->response->splash             = array ();
        $this->object->response->error              = null;
        $this->object->response->warning            = null;
        if (!$this->isHTTPS()) {
            $this->object->response->warning        = HPAPI_STR_PLAIN;
        }
        $this->object->response->remoteAddr         = $_SERVER['REMOTE_ADDR'];
        $this->object->response->serverAddr         = $_SERVER['SERVER_ADDR'];
        $this->object->response->datetime           = $this->datetime->format (\DateTime::ATOM);
        if (strlen(HPAPI_DIAGNOSTIC_EMAIL_REGEXP) && preg_match('<'.HPAPI_DIAGNOSTIC_EMAIL_REGEXP.'>',$this->object->email)) {
            $this->returnDiagnostic                 = true;
            $this->diagnostic (HPAPI_DG_ENABLED);
        }
        if (!property_exists($this->object,'datetime')) {
            $this->object->response->error          = HPAPI_STR_DATETIME;
            $this->end ();
        }
        if (!property_exists($this->object,'email')) {
            $this->object->response->error          = HPAPI_STR_EMAIL;
            $this->end ();
        }
        if (!property_exists($this->object,'password') && !property_exists($this->object,'token')) {
            $this->object->response->error          = HPAPI_STR_PWD_OR_TKN;
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
        if (!property_exists($this->object->method,'vendor') || !strlen($this->object->method->vendor)) {
            $this->object->response->error          = HPAPI_STR_METHOD_VENDOR;
            $this->end ();
        }
        if (!property_exists($this->object->method,'package') || !strlen($this->object->method->package)) {
            $this->object->response->error          = HPAPI_STR_METHOD_PACKAGE;
            $this->end ();
        }
        if (!property_exists($this->object->method,'class') || !strlen($this->object->method->class)) {
            $this->object->response->error          = HPAPI_STR_METHOD_CLASS;
            $this->end ();
        }
        if (!property_exists($this->object->method,'method') || !strlen($this->object->method->method)) {
            $this->object->response->error          = HPAPI_STR_METHOD_METHOD;
            $this->end ();
        }
        $this->email                                = $this->object->email;
        try {
            $this->models                           = $this->jsonDecode (
                file_get_contents (HPAPI_MODELS_CFG)
               ,false
               ,HPAPI_JSON_DEPTH
            );
        }
        catch (\Exception $e) {
            $this->diagnostic ($e->getMessage());
            $this->object->response->error          = HPAPI_STR_DB_DFN;
            $this->end ();
        }
        try {
            $this->db                               = new \Hpapi\Db ($this,$this->models->HpapiModel);
        }
        catch (\Exception $e) {
            $this->diagnostic ($e->getMessage());
            $this->object->response->error          = HPAPI_STR_DB_OBJ;
            $this->end ();
        }
        $key                                        = $this->authenticate ();
        if (HPAPI_PRIVILEGES_DYNAMIC) {
            $privileges                             = $this->callPrivileges ();
        }
        else {
            if (is_readable(HPAPI_PRIVILEGES_FILE)) {
                $privileges                         = require HPAPI_PRIVILEGES_FILE;
            }
            if (!is_array($privileges)) {
                $privileges                         = $this->callPrivileges ();
                try {
                    $this->exportArray (HPAPI_PRIVILEGES_FILE,$privileges);
                }
                catch (\Exception $e) {
                    $this->diagnostic ($e->getMessage());
                    $this->object->response->error  = HPAPI_STR_PRIV_WRITE;
                    $this->end ();
                }
            }
        }
        $this->privilege                            = $this->access ($privileges,$key);
        $this->object->response->returnValue        = $this->executeMethod ($this->object->method);
        $this->end ();
    }

    public function __destruct ( ) {
    }

    protected function access ($privilege,$key) {
        $method                                     = $this->object->method->vendor;
        $method                                    .= '::';
        $method                                    .= $this->object->method->package;
        $method                                    .= '::';
        $method                                    .= $this->object->method->class;
        $method                                    .= '::';
        $method                                    .= $this->object->method->method;
        if (!array_key_exists($method,$privilege)) {
             $this->object->response->error         = HPAPI_STR_ACCESS_MTD;
            $this->end ();
        }
        $privilege                                  = $privilege[$method];
        if (!preg_match('<'.$privilege['remoteAddrPattern'].'>',$_SERVER['REMOTE_ADDR'])) {
            $this->diagnostic (HPAPI_DG_PRIV_REM_ADDR);
            $this->object->response->authStatus     = HPAPI_STR_AUTH_REM_ADDR_PKG;
            $this->object->response->error          = HPAPI_STR_AUTH_DENIED;
            $this->end ();
        }
        if ($privilege['requiresKey']) {
            if (!property_exists($this->object,'key') || $this->object->key!=$key) {
                $this->diagnostic (HPAPI_DG_PRIV_KEY);
                $this->object->response->authStatus = HPAPI_STR_AUTH_KEY;
                $this->object->response->error      = HPAPI_STR_AUTH_DENIED;
                $this->end ();
            }
        }
        $access                                     = false;
        $match                                      = false;
        foreach ($privilege['usergroups'] as $privg) {
            foreach ($this->groupsAllowed as $authg) {
                if ($authg['usergroup']==$privg) {
                    $match                          = true;
                    if (preg_match('<'.$authg['remoteAddrPattern'].'>',$_SERVER['REMOTE_ADDR'])) {
                        $access                     = true;
                        break 2;
                    }
                    else {
                         $this->diagnostic (HPAPI_DG_ACCESS_GRP_REM_ADDR);
                    }
                }
            }
        }
        if (!$access) {
            if (!$match) {
                $this->diagnostic (HPAPI_DG_ACCESS_GRP);
            }
            $this->object->response->error          = HPAPI_STR_AUTH_DENIED;
            $this->end ();
        }
        return $privilege;
    }

    public function addSplash ($message) {
        array_push ($this->object->response->splash,$message);
    }

    protected function authenticate ( ) {
        // Blacklist
        if ($type=$this->blacklistMatch($this->object)) {
            $this->diagnostic (HPAPI_DG_BLACKLIST.' (type='.$type.')');
            $this->object->response->authStatus     = HPAPI_STR_AUTH_BLACKLIST;
            $this->object->response->error          = HPAPI_STR_AUTH_DENIED;
            $this->end ();
        }
        // Authentication data
        try {
            $results                                = $this->db->call (
                'hpapiAuthDetails'
                ,$this->object->email
            );
        }
        catch (\Exception $e) {
            $this->diagnostic ($e->getMessage());
            $this->object->response->error          = HPAPI_STR_ERROR_DB;
            $this->end ();
        }
        foreach ($results as $g) {
            array_push ($this->groupsAvailable,array('usergroup'=>$g['usergroup'],'remoteAddrPattern'=>$g['groupRemoteAddrPattern']));
        }
        // Revoke old key releases
        try {
            $this->db->call (
                'hpapiKeyreleaseRevoke'
                ,$this->object->email
                ,$this->timestamp
            );
        }
        catch (\Exception $e) {
            $this->diagnostic ($e->getMessage());
            $this->object->response->error          = HPAPI_STR_ERROR_DB;
            $this->end ();
        }
        if (!count($results)) {
            $this->diagnostic (HPAPI_DG_PRIV_RESULTS);
            $this->object->response->authStatus     = HPAPI_STR_AUTH_EMAIL;
            $this->object->response->error          = HPAPI_STR_AUTH_DENIED;
            $this->end ();
        }
        $auth                                       = $results[0];
        // Key for returning on success
        $key                                        = null;
        if ($auth['key'] && !$auth['keyExpired']) {
            $key                                    = $auth['key'];
        }
        // Authentication checks
        if (!preg_match('<'.$auth['userRemoteAddrPattern'].'>',$_SERVER['REMOTE_ADDR'])) {
            $this->diagnostic (HPAPI_DG_USER_REM_ADDR);
            $this->object->response->authStatus     = HPAPI_STR_AUTH_REM_ADDR;
            $this->object->response->error          = HPAPI_STR_AUTH_DENIED;
            $this->end ();
        }
        if (!$auth['active']) {
            $this->diagnostic (HPAPI_DG_USER_ACTIVE);
            $this->object->response->authStatus     = HPAPI_STR_AUTH_ACTIVE;
            $this->object->response->error          = HPAPI_STR_AUTH_DENIED;
            $this->end ();
        }
        if (property_exists($this->object,'password')) {
            if (password_verify($this->object->password,$auth['passwordHash'])) {
                $this->object->response->authStatus = HPAPI_STR_AUTH_OK;
                // Valid password so store and return fresh token
                $this->setToken ();
                // Load user groups
                $this->groupsAllowed                = $this->groupsAvailable;
            }
            else {
                $this->diagnostic (HPAPI_DG_PASSWORD);
                $this->object->response->authStatus = HPAPI_STR_AUTH_PASSWORD;
                // Load anon user group
                foreach ($this->groupsAvailable as $g) {
                    if ($g['usergroup']==HPAPI_USERGROUP_ANON) {
                        array_push ($this->groupsAllowed,array('usergroup'=>HPAPI_USERGROUP_ANON,'remoteAddrPattern'=>$g['remoteAddrPattern']));
                        break;
                    }
                }
            }
        }
        else {
            if ($this->object->token==$auth['token'] && $auth['tokenExpires']>$this->timestamp && $auth['tokenRemoteAddr']==$_SERVER['REMOTE_ADDR']) {
                $this->object->response->authStatus = HPAPI_STR_AUTH_OK;
                // Load user groups
                $this->groupsAllowed                = $this->groupsAvailable;
            }
            else {
                if ($this->object->token!=$auth['token']) {
                    $this->diagnostic (HPAPI_DG_TOKEN_MATCH.': '.$this->object->token.' != '.$auth['token']);
                }
                elseif ($this->timestamp>=$auth['tokenExpires']) {
                    $this->diagnostic (HPAPI_DG_TOKEN_EXPIRY.': '.$auth['tokenExpires'].' >= '.$this->timestamp);
                }
                elseif ($auth['tokenRemoteAddr']!=$_SERVER['REMOTE_ADDR']) {
                    $this->diagnostic (HPAPI_DG_REM_ADDR.': '.$auth['tokenRemoteAddr'].' != '.$_SERVER['REMOTE_ADDR']);
                }
                $this->object->response->authStatus = HPAPI_STR_AUTH_TOKEN;
            }
        }
        if (!$auth['verified']) {
            $this->object->response->authStatus     = HPAPI_STR_AUTH_VERIFY;
            $this->object->email                    = '';
        }
        // Define current user
        $this->userId                               = $auth['userId'];
        if ($auth['respondWithKey'] && $this->timestamp<$auth['keyReleaseUntil']) {
            // Adopt the key for this transaction
            $this->object->key                      = $auth['key'];
            // Return released key to client
            $this->object->response->newKey         = $auth['key'];
        }
        return $key;
    }

    public function blacklistMatch ($request) {
        if (is_readable(HPAPI_BLACKLIST_ARRAY)) {
            $blacklist                              = include HPAPI_BLACKLIST_ARRAY;
        }
        else {
            $this->diagnostic (HPAPI_DG_BLACKLIST_ARRAY.': '.HPAPI_BLACKLIST_ARRAY);
        }
        foreach ($blacklist as $item) {
            if ($item[2]<$this->timestamp) {
                continue;
            }
            if ($item[0]=='remAddr' && $item[1]==$_SERVER['REMOTE_ADDR']) {
                return 'remAddr';
            }
            if ($item[0]=='key' && $item[1]==$request->key) {
                return 'key';
            }
            if ($item[0]=='email' && $item[1]==$request->email) {
                return 'email';
            }
            if ($item[0]=='pwd' && $item[1]==$request->password) {
                return 'pwd';
            }
        }
        return false;
    }

    public function callPrivileges () {
        try {
            $methods                                = $this->db->call (
                'hpapiMethodPrivileges'
            );
        }
        catch (\Exception $e) {
            $this->diagnostic ($e->getMessage());
            $this->object->response->error          = HPAPI_STR_ERROR_DB;
            $this->end ();
        }
        $privileges                                 = array ();
        foreach ($methods as $m) {
            $method                                 = $m['method'];
            unset ($m['method']);
            if (!array_key_exists($method,$privileges)) {
                $privileges[$method]                        = array ();
                $privileges[$method]['usergroups']          = array ();
                $privileges[$method]['arguments']           = array ();
                $privileges[$method]['sprs']                = array ();
                $privileges[$method]['package']             = $m['packageNotes'];
                $privileges[$method]['requiresKey']         = $m['requiresKey'];
                $privileges[$method]['remoteAddrPattern']   = $m['remoteAddrPattern'];
                $privileges[$method]['notes']               = $m['methodNotes'];
                $privileges[$method]['label']               = $m['methodLabel'];
            }
            if (!$m['usergroup']) {
                continue;
            }
            if (!in_array($m['usergroup'],$privileges[$method]['usergroups'])) {
                array_push ($privileges[$method]['usergroups'],$m['usergroup']);
            }
            if (!$m['argument']) {
                continue;
            }
            if (array_key_exists($m['argument'],$privileges[$method]['arguments'])) {
                continue;
            }
            unset ($m['usergroup']);
            unset ($m['packageNotes']);
            unset ($m['methodNotes']);
            unset ($m['packageNotes']);
            $privileges[$method]['arguments'][$m['argument']]   = $m;
        }
        try {
            $sprs                                               = $this->db->call (
                'hpapiSprPrivileges'
            );
        }
        catch (\Exception $e) {
            $this->diagnostic ($e->getMessage());
            $this->object->response->error                      = HPAPI_STR_ERROR_DB;
            $this->end ();
        }
        foreach ($sprs as $s) {
            if (!array_key_exists($s['method'],$privileges)) {
                continue;
            }
            if (!$s['spr']) {
                continue;
            }
            $method                                                 = $s['method'];
            $spr                                                    = $s['spr'];
            unset ($s['method']);
            unset ($s['spr']);
            if (!array_key_exists($spr,$privileges[$method]['sprs'])) {
                $privileges[$method]['sprs'][$spr]                  = array ();
                $privileges[$method]['sprs'][$spr]['arguments']     = array ();
                $privileges[$method]['sprs'][$spr]['model']         = $s['model'];
                $privileges[$method]['sprs'][$spr]['modelNotes']    = $s['modelNotes'];
                $privileges[$method]['sprs'][$spr]['notes']         = $s['sprNotes'];
            }
            if (!$s['argument']) {
                continue;
            }
            if (array_key_exists($s['argument'],$privileges[$method]['sprs'][$spr]['arguments'])) {
                continue;
            }
            unset ($s['model']);
            unset ($s['modelNotes']);
            unset ($s['sprNotes']);
            $privileges[$method]['sprs'][$spr]['arguments'][$s['argument']] = $s;
        }
        return $privileges;
    }

    public function classPath ($method) {
        $path           = HPAPI_DIR_HPAPI.'/'.$method->vendor.'/'.$method->package;
        $path          .= str_replace ("\\",'/',$method->class);
        $path          .= HPAPI_CLASS_SUFFIX;
        return $path;
    }

    public function dbCall ( ) {
        $arguments          = func_get_args ();
        try {
            $spr            = (string) array_shift ($arguments);
            if(!strlen($spr)) {
                throw new \Exception (HPAPI_STR_DB_SPR_NO_SPR);
                return false;
            }
        }
        catch (\Exception $e) {
            throw new \Exception (HPAPI_STR_DB_SPR_NO_SPR);
            return false;
        }
        if (!array_key_exists($spr,$this->privilege['sprs'])) {
            throw new \Exception (HPAPI_STR_DB_SPR_AVAIL.': `'.$spr.'`');
            return false;
        }
        if (count($arguments)!=count($this->privilege['sprs'][$spr]['arguments'])) {
            $this->diagnostic (HPAPI_STR_DB_SPR_ARGS.': `'.$spr.'`');
            throw new \Exception (HPAPI_STR_DB_SPR_ARGS.': `'.$spr.'`');
            return false;
        }
        foreach ($this->privilege['sprs'][$spr]['arguments'] AS $count=>$arg) {
            try {
                $this->validation ($spr,$count,$arguments[$count-1],$arg);
            }
            catch (\Exception $e) {
                $this->diagnostic (HPAPI_STR_DB_SPR_ARG_VAL.': `'.$spr.'`');
                throw new \Exception (HPAPI_STR_DB_SPR_ARG_VAL.': '.$e->getMessage());
                return false;
            }
            $count++;
        }
        try {
            $db             = new \Hpapi\Db ($this,$this->models->{$this->privilege['sprs'][$spr]['model']});
        }
        catch (\Exception $e) {
            throw new \Exception ($e->getMessage());
            return false;
        }
        try {
            $return         = $db->call ($spr,...$arguments);
            $db->close ();
        }
        catch (\Exception $e) {
            $this->diagnostic ($e->getMessage());
            throw new \Exception ($e->getMessage());
            return false;
        }
        $db->close ();
        return $return;
    }

    public function decodePost ( ) {
        $post           = trim (file_get_contents('php://input'));
        if (strlen($post)==0) {
            throw new \Exception (HPAPI_STR_DECODE_NOTHING);
            return false;
        }
        if (strlen($post)>HPAPI_POST_BYTES_MAX) {
            throw new \Exception (HPAPI_STR_DECODE_LENGTH.' ( >'.HPAPI_POST_BYTES_MAX.'B )');
            return false;
        }
        if ($this->contentType==HPAPI_CONTENT_TYPE_JSON) {
            try {
                $json   = $this->jsonDecode ($post,false,HPAPI_JSON_DEPTH);
            }
            catch (\Exception $e) {
                throw new \Exception (HPAPI_STR_JSON_DECODE.': '.$e);
                return false;
            }
            return $json;
        }
        else {
            throw new \Exception (HPAPI_STR_CONTENT_TYPE.' '.$this->contentTypeRequested);
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

    public function diagnostic ($msg) {
        if ($this->returnDiagnostic) {
            if (!property_exists($this->object,'diagnostic')) {
                $this->object->diagnostic = '';
            }
            $this->object->diagnostic .= $msg."\n";
        }
    }

    public function end ( ) {
        if (property_exists($this->object,'error') && strlen($this->object->error)>0) {
             if (preg_match('<^[0-9]*\s*([0-9]*)\s>',$this->object->error,$m)) {
                $this->object->httpErrorCode        = $m[0];
                http_response_code ($m[0]);
            }
        }
        if ($this->tokenExtend && property_exists($this->object,'token') && !$this->token) {
            try {
                $this->db->call (
                    'hpapiTokenExtend'
                   ,$this->userId
                   ,$this->tokenExpiry + HPAPI_TOKEN_EXTRA_SECONDS
                );
            }
            catch (\Exception $e) {
                $this->diagnostic (HPAPI_DG_TOKEN_EXTEND.': '.$e->getMessage());
            }
            $this->object->response->tokenExpires   = $this->tokenExpiry;
        }
        elseif ($this->token) {
            try {
                $this->db->call (
                    'hpapiToken'
                   ,$this->userId
                   ,$this->token
                   ,$this->tokenExpiry + HPAPI_TOKEN_EXTRA_SECONDS
                   ,$_SERVER['REMOTE_ADDR']
                );
            }
            catch (\Exception $e) {
                $this->diagnostic (HPAPI_DG_TOKEN.': '.$e->getMessage());
            }
            $this->object->response->token          = $this->token;
            $this->object->response->tokenExpires   = $this->tokenExpiry;
        }
        try {
            $this->log ();
        }
        catch (\Exception $e) {
             $this->diagnostic ($e->getMessage());
        }
        if ($this->db) {
            $this->db->close ();
        }
        $email = '';
        if (property_exists($this->object,'key')) {
            unset ($this->object->key);
        }
        if (property_exists($this->object,'email')) {
            $email = $this->object->email;
            unset ($this->object->email);
        }
        if (property_exists($this->object,'password')) {
            unset ($this->object->password);
        }
        if (property_exists($this->object,'token')) {
            unset ($this->object->token);
        }
        try {
            $this->logLast (trim(file_get_contents('php://input'))."\n".var_export($this->object,true));
        }
        catch (\Exception $e) {
            $this->diagnostic ($e->getMessage());
        }
        if (!$this->returnDiagnostic) {
            unset ($this->object->method);
        }
        if ($this->contentType==HPAPI_CONTENT_TYPE_JSON) {
            echo $this->jsonEncode ($this->object,HPAPI_JSON_OPTIONS,HPAPI_JSON_DEPTH);
            echo "\n";
            exit;
        }
        $this->object->remoteAddr                   = $_SERVER['REMOTE_ADDR'];
        var_export ($this->object);
        echo "\n";
        exit;
    }

    protected function executeMethod ($m) {
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
        if (count($m->arguments)!=count($this->privilege['arguments'])) {
              $this->object->response->error        = HPAPI_STR_DB_MTD_ARGS;
              $this->end ();
        }
        foreach ($this->privilege['arguments'] AS $count=>$arg) {
            try {
                $this->validation ($m->method,$count,$m->arguments[$count-1],$arg);
            }
            catch (\Exception $e) {
                $this->diagnostic ($e->getMessage());
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
                $this->diagnostic ($e->getMessage());
                $this->object->response->error      = HPAPI_STR_METHOD_DFN_INC;
                $this->end ();
            }
        }
        try {
            require_once $file;
        }
        catch (\Exception $e) {
            $this->diagnostic ($e->getMessage());
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
            $this->diagnostic ($e->getMessage());
            $this->object->response->error          = HPAPI_STR_METHOD_CLS_NEW;
            $this->end ();
        }
        if (!method_exists($object,$m->method)) {
            $this->object->response->error          = HPAPI_STR_METHOD_MTD_GOT;
            $this->end ();
        }
        try {
            $args                                   = array ();
            foreach ($m->arguments as $arg) {
                if (is_object($arg)) {
                    $copy                           = $this->jsonEncode ($arg);
                    array_push ($args,$this->jsonDecode($copy));
                }
                array_push ($args,$arg);
            }
            $return_value                           = $object->{$m->method} (...$args);
        }
        catch (\Exception $e) {
            $this->object->response->error          = $e->getMessage();
            $this->end ();
        }
        return $return_value;
    }

    public function exportArray ($file,$array) {
        if (!is_writable($file)) {
            throw new \Exception (HPAPI_STR_EXPORT_ARRAY_FILE.': '.realpath(dirname($file)).'/'.basename($file));
            return false;
        }
        if (!is_array($array)) {
            throw new \Exception (HPAPI_STR_EXPORT_ARRAY_ARR);
            return false;
        }
        try {
            $str                                    = "<?php\nreturn ";
            $str                                   .= var_export ($array,true);
            $str                                   .= ";\n";
            $fp                                     = fopen ($file,'w');
            fwrite ($fp,$str);
            fclose ($fp);
        }
        catch (\Exception $e) {
            throw new \Exception ($e->getMessage);
            return false;
        }
    }

    public function groupAllowed ($groupName) {
        foreach ($this->groupsAllowed as $ug) {
            if ($ug['usergroup']==$groupName) {
                return true;
            }
        }
        return false;
    }

    public function groupAvailable ($groupName) {
        foreach ($this->groupsAvailable as $ug) {
            if ($ug['usergroup']==$groupName) {
                return true;
            }
        }
        return false;
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

    public function jsonDecode ($json,$assoc=false,$depth=512) {
        $var = json_decode ($json,$assoc,$depth);
        if (($e=json_last_error())!=JSON_ERROR_NONE) {
            throw new \Exception ($e.' '.json_last_error_msg());
            return false;
        }
        return $var;
    }

    public function jsonEncode ($json,$options=0,$depth=512) {
        $str = json_encode ($json,$options,$depth);
        if (($e=json_last_error())!=JSON_ERROR_NONE) {
            throw new \Exception ($e.' '.json_last_error_msg());
            return false;
        }
        return $str;
    }

    public function log ( ) {
        if (!$this->db) {
            return false;
        }
        $diagnostic = '';
        if (property_exists($this->object,'diagnostic')) {
            $diagnostic = $this->object->diagnostic;
        }
        try {
            if (property_exists($this->object,'key')) {
                $key = $this->object->key;
            }
            else {
                $key = '';
            }
            $this->db->call (
                'hpapiLogRequest'
               ,$this->timestamp
               ,$this->microtime
               ,$key
               ,$this->userId
               ,$this->email
               ,$_SERVER['REMOTE_ADDR']
               ,$_SERVER['HTTP_USER_AGENT']
               ,$this->object->method->vendor
               ,$this->object->method->package
               ,$this->object->method->class
               ,$this->object->method->method
               ,$this->object->response->authStatus
               ,$this->object->response->error.''
               ,$diagnostic
            );
        }
        catch (\Exception $e) {
            throw new \Exception ($e);
            return false;
        }
        return true;
    }

    protected function logLast ($output) {
        if (!HPAPI_LOG_LAST_OUTPUT) {
            return true;
        }
        try {
            $str    = '_SERVER = '.print_r($_SERVER,true)."\n";
            $str   .= ' OUTPUT = '.$output;
            $fp     = fopen (HPAPI_LOG_LAST_FILE,'w');
            fwrite ($fp,$str);
            fclose ($fp);
        }
        catch (\Exception $e) {
            throw new \Exception ($e->getMessage);
            return false;
        }
    }

    public function packagePath ($method) {
        $path   = HPAPI_DIR_HPAPI;
        $path  .= '/'.$method->vendor;
        $path  .= '/'.$method->package;
        return $path;
    }

    public function parse2d ($data,$keyField=null) {
        if (!is_array($data)) {
            throw new \Exception (HPAPI_STR_2D_ARRAY);
            return false;
        }
        if ($keyField!==null) {
            $ol = new \stdClass ();
        }
        else {
            $ol = array ();
        }
        foreach ($data as $row) {
            if (!is_array($row)) {
                throw new \Exception (HPAPI_STR_2D_ARRAY);
                return false;
            }
            $item = new \stdClass ();
            foreach ($row as $k=>$v) {
                $item->$k = $v;
            }
            if (is_array($ol)) {
                array_push ($ol,$item);
            }
            elseif (array_key_exists($keyField,$item)) {
                $ol->{$item->$keyField} = $item;
            }
        }
        return $ol;
    }

    private function parseContentType ( ) {
        // Without Content-Type header
        if (!array_key_exists('CONTENT_TYPE',$_SERVER)) {
            $pattern = '<[^A-z]'.HPAPI_CONTENT_TYPE_HTML.'[^A-z]>i';
            if (array_key_exists('HTTP_ACCEPT',$_SERVER) && preg_match($pattern,' '.$_SERVER['HTTP_ACCEPT'].' ')) {
                if (strlen(HPAPI_URL_HTML_HEADER)) {
                    $this->logLast (HPAPI_URL_HTML_HEADER."\n");
                    header ('Location: '.HPAPI_URL_HTML_HEADER);
                    exit;
                }
            }
            if (strlen(HPAPI_URL_OTHER_HEADER)) {
                $this->logLast (HPAPI_URL_OTHER_HEADER."\n");
                header ('Location: '.HPAPI_URL_OTHER_HEADER);
                exit;
            }
            $this->contentTypeRequested = HPAPI_CONTENT_TYPE_UNKNOWN;
            return HPAPI_CONTENT_TYPE_TEXT;
        }
        $type = explode (';',$_SERVER['CONTENT_TYPE']);
        if (strlen(HPAPI_URL_HTML_HEADER) && ($type=trim($type[0]))==HPAPI_CONTENT_TYPE_HTML) {
            $this->logLast (HPAPI_URL_HTML_HEADER."\n");
            header ('Location: '.HPAPI_URL_HTML_HEADER);
            exit;
        }
        $this->contentTypeRequested = $type;
        $type = explode ('/',$type);
        if ($type[1]=='json') {
            return HPAPI_CONTENT_TYPE_JSON;
        }
        if (HPAPI_URL_OTHER_HEADER) {
            $this->logLast (HPAPI_URL_OTHER_HEADER."\n");
            header ('Location: '.HPAPI_URL_OTHER_HEADER);
            exit;
        }
        return HPAPI_CONTENT_TYPE_TEXT;
    }

    public function passwordHash ($plain) {
        return password_hash ($plain,HPAPI_HASH_ALGO,array('cost'=>HPAPI_HASH_COST));
    }

    public function pdoDriver ($dsn) {
        $drv = explode (':',$dsn);
        return $drv[0];
    }

    public function resetPrivileges ( ) {
        if (!is_writable(HPAPI_PRIVILEGES_FILE)) {
            throw new \Exception (HPAPI_STR_RESET_PRIVS_FILE);
            return false;
        }
        try {
            $fp                                 = fopen (HPAPI_PRIVILEGES_FILE,'w');
            fwrite ($fp,"<?php\nreturn false;\n");
            fclose ($fp);
        }
        catch (\Exception $e) {
            throw new \Exception ($e->getMessage);
            return false;
        }
    }

    public function setToken ($token=null) {
        if ($token) {
            $this->token = $token;
        }
        else {
            $this->token = bin2hex (random_bytes(HPAPI_TOKEN_BYTES));
        }
    }

    public function setTokenExpiry ($seconds) {
        $this->tokenExpiry = $seconds;
    }

    public function setTokenExtend ($bool) {
        $this->tokenExtend = $bool;
    }

    public function validation ($name,$argNum,$value,$defn) {
        if (is_object($defn)) {
            $arr = array ();
            foreach ($defn as $k=>$v) {
                $arr[$k] = $v;
            }
            $defn = $arr;
            unset ($arr);
        }
        $defnParameters = array ('constraints','emptyAllowed','expression','lengthMaximum','lengthMinimum','pattern','phpFilter','valueMaximum','valueMinimum');
        foreach ($defnParameters as $p) {
            if (!array_key_exists($p,$defn)) {
                throw new \Exception (HPAPI_STR_VALID_DEFN_PARAM.' "'.$p.'"');
                return false;
            }
        }
        if ($defn['emptyAllowed'] && !strlen($value)) {
            return true;
        }
        $e          = null;
        if ($defn['pattern']=='object' && !is_object($value)) {
            $e      = HPAPI_STR_VALID_PATTERN.' <'.$defn['expression'].'>';
        }
        elseif (strlen($defn['expression']) && !preg_match('<'.$defn['expression'].'>',$value)) {
            $e      = HPAPI_STR_VALID_EXPRESSION.' <'.$defn['expression'].'>';
        }
        elseif (strlen($defn['phpFilter']) && filter_var($value,constant($defn['phpFilter']))===false) {
            $e      = HPAPI_STR_VALID_PHP_FILTER.' '.$defn['phpFilter'];
        }
        elseif ($defn['lengthMinimum']>0 && strlen($value)<$defn['lengthMinimum']) {
            $e      = HPAPI_STR_VALID_LMIN.' '.$defn['lengthMinimum'];
        }
        elseif ($defn['lengthMaximum']>0 && strlen($value)>$defn['lengthMaximum']) {
            $e      = HPAPI_STR_VALID_LMAX.' '.$defn['lengthMaximum'];
        }
        elseif (strlen($defn['valueMinimum']) && $value<$defn['valueMinimum']) {
            $e      = HPAPI_STR_VALID_VMIN.' '.$defn['valueMinimum'];
        }
        elseif (strlen($defn['valueMaximum']) && $value>$defn['valueMaximum']) {
            $e      = HPAPI_STR_VALID_VMAX.' '.$defn['valueMaximum'];
        }
        else {
            return true;
        }
        $cstr       = $defn['constraints'];
        if (defined($defn['constraints'])) {
            $cstr   = constant ($defn['constraints']);
        }
        $label      = $name;
        if (array_key_exists('name',$defn)) {
            $label  = $defn['name'];
        }
        $this->addSplash ($label.' '.$cstr);
        throw new \Exception ($name.'['.$argNum.']: '.$e);
        return false;
    }

    public function vendorPath ($method) {
        $path   = HPAPI_DIR_HPAPI;
        $path  .= '/'.$method->vendor;
        return $path;
    }

}

