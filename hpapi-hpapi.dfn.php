<?php

/* Copyright 2018 Whitelamp http://www.whitelamp.com/ */

// The hpapi model
define ( 'HPAPI_MODEL_NAME',                'HpapiModel'                                                                            );

// File suffix for PHP classes
define ( 'HPAPI_CLASS_SUFFIX',              '.class.php'                                                                            );

// Content header values
define ( 'HPAPI_CONTENT_TYPE_HTML',         'text/html'                                                                             );
define ( 'HPAPI_CONTENT_TYPE_JSON',         'application/json; charset=utf-8'                                                       );
define ( 'HPAPI_CONTENT_TYPE_TEXT',         'text/plain; charset=utf-8'                                                             );
define ( 'HPAPI_CONTENT_TYPE_UNKNOWN',      'unknown/unknown'                                                                       );

// Definitions for `hpapi_pattern`.`constraints` for hpapi (and supporting class) methods and stored procedures
define ( 'HPAPI_PATTERN_DESC_ALPHA_LC',     'must have only small letters (up to 64 characters)'                                    );
define ( 'HPAPI_PATTERN_DESC_CLASS',        'must be a valid PHP class name'                                                        );
define ( 'HPAPI_PATTERN_DESC_DATETIME',     'must be universal datetime format yyyy-mm-dd hh:mm:ss+hh:mm'                           );
define ( 'HPAPI_PATTERN_DESC_DB_BOOL',      'must be 0 or 1'                                                                        );
define ( 'HPAPI_PATTERN_DESC_EMAIL',        'must be a valid email address'                                                         );
define ( 'HPAPI_PATTERN_GEO_COORD',         'must be a valid decimal geo-coordinate value'                                          );
define ( 'HPAPI_PATTERN_DESC_HHMMSS',       'must be 6 digits representing a time - HHMMSS'                                         );
define ( 'HPAPI_PATTERN_DESC_INT_11_POS',   'must be a positive integer of no more than 11 digits'                                  );
define ( 'HPAPI_PATTERN_DESC_INT_11_POS_NEG','must be an integer of no more than 11 digits'                                         );
define ( 'HPAPI_PATTERN_DESC_INT_2_POS',    'must be a positive integer of no more than 2 digits'                                   );
define ( 'HPAPI_PATTERN_DESC_INT_4_POS',    'must be a positive integer of no more than 4 digits'                                   );
define ( 'HPAPI_PATTERN_DESC_IPV4',         'must be valid IPv4 address'                                                            );
define ( 'HPAPI_PATTERN_DESC_OBJECT',       'must be a data object'                                                                 );
define ( 'HPAPI_PATTERN_DESC_METHOD',       'must be valid format for a method name'                                                );
define ( 'HPAPI_PATTERN_DESC_PACKAGE',      'must be valid format for a package name'                                               );
define ( 'HPAPI_PATTERN_DESC_PASSWORD_1',   'must have at least 8 characters with at least one: big letter, small letter, number'   );
define ( 'HPAPI_PATTERN_DESC_URI_PATH',     'must be a Linux-friendly request URI path'                                             );
define ( 'HPAPI_PATTERN_DESC_UUIDV4',       'must be UUID v4 format'                                                                );
define ( 'HPAPI_PATTERN_DESC_VARCHAR_140',  'must have no more than 140 characters'                                                 );
define ( 'HPAPI_PATTERN_DESC_VARCHAR_16',   'must have no more than 16 characters'                                                  );
define ( 'HPAPI_PATTERN_DESC_VARCHAR_2',    'must have no more than 2 characters'                                                   );
define ( 'HPAPI_PATTERN_DESC_VARCHAR_255',  'must have no more than 255 characters'                                                 );
define ( 'HPAPI_PATTERN_DESC_VARCHAR_32',   'must have no more than 32 characters'                                                  );
define ( 'HPAPI_PATTERN_DESC_VARCHAR_4',    'must have no more than 4 characters'                                                   );
define ( 'HPAPI_PATTERN_DESC_VARCHAR_4096', 'must have no more than 4096 characters'                                                );
define ( 'HPAPI_PATTERN_DESC_VARCHAR_6',    'must have no more than 6 characters'                                                   );
define ( 'HPAPI_PATTERN_DESC_VARCHAR_64',   'must have no more than 64 characters'                                                  );
define ( 'HPAPI_PATTERN_DESC_VENDOR',       'must be valid format for a vendor name'                                                );
define ( 'HPAPI_PATTERN_DESC_YYYY_MM_DD',   'must be a standard formatted date - YYYY-MM-DD'                                        );
define ( 'HPAPI_PATTERN_DESC_YYYYMMDD',     'must be 8 digits representing a date - YYYYMMDD'                                       );

// Initiating response
define ( 'HPAPI_STR_INIT',                  '021 500 \Hpapi\Hpapi could not be initialised'                                         );
define ( 'HPAPI_STR_SSL',                   '022 400 SSL required but not used'                                                     );
define ( 'HPAPI_STR_CONTENT_TYPE',          '023 400 Client header indicates wrong content type'                                    );
define ( 'HPAPI_STR_JSON_DECODE',           '024 400 Cannot decode request'                                                         );
define ( 'HPAPI_STR_SYS_CFG',               '025 500 Could not load system configuration'                                           );

// Validating posted object properties
define ( 'HPAPI_STR_DATETIME',              '031 400 Property "datetime" does not exist'                                            );
define ( 'HPAPI_STR_KEY',                   '032 400 Property "key" does not exist'                                                 );
define ( 'HPAPI_STR_EMAIL',                 '033 400 Property "email" does not exist'                                               );
define ( 'HPAPI_STR_PWD_OR_TKN',            '034 400 Neither property "password" nor property "token" exists'                       );
define ( 'HPAPI_STR_METHOD',                '035 400 Property "method" does not exist'                                              );
define ( 'HPAPI_STR_METHOD_OBJ',            '036 400 Property "method" is not an object'                                            );
define ( 'HPAPI_STR_METHOD_VENDOR',         '037 400 Method property "vendor" was not given'                                        );
define ( 'HPAPI_STR_METHOD_PACKAGE',        '038 400 Method property "package" was not given'                                       );
define ( 'HPAPI_STR_METHOD_CLASS',          '039 400 Method property "class" was not given'                                         );
define ( 'HPAPI_STR_METHOD_METHOD',         '040 400 Method property "method" was not given'                                        );

// Configuration errors
define ( 'HPAPI_STR_DB_CFG',                '051 500 DB configuration error - could not load database configuration'                );
define ( 'HPAPI_STR_DB_DFN',                '052 500 DB configuration error - could not load PDO definition'                        );
define ( 'HPAPI_STR_DB_DFN_DRV',            '053 500 DB configuration error - no PDO definition for driver specified by DSN'        );
define ( 'HPAPI_STR_DB_OBJ',                '054 500 Could not construct database object'                                           );
define ( 'HPAPI_STR_DB_CONN',               '055 500 Could not connect to database'                                                 );
define ( 'HPAPI_STR_PRIV_WRITE',            '056 500 Could not write privileges'                                                    );
define ( 'HPAPI_STR_PRIV_READ',             '057 500 Could not read privileges'                                                     );
define ( 'HPAPI_STR_TOKEN_DURATION',        '058 500 No matching user group has a token duration'                                   );

// Evaluating authentication status
define ( 'HPAPI_STR_AUTH_DENIED',           '061 403 Access denied'                                                                 );
define ( 'HPAPI_STR_AUTH_KEY',              '062 Invalid key'                                                                       );
define ( 'HPAPI_STR_AUTH_REMOTE_ADDR',      '063 Access not allowed from remote address'                                            );
define ( 'HPAPI_STR_AUTH_ACTIVE',           '065 User not active'                                                                   );
define ( 'HPAPI_STR_AUTH_PWD_OR_TKN',       '066 Invalid credentials'                                                               );
define ( 'HPAPI_STR_AUTH_VERIFY',           '067 Email not verified'                                                                );
define ( 'HPAPI_STR_AUTH_OK',               '068 Fully authenticated'                                                               );
define ( 'HPAPI_STR_AUTH_GRP_REMOTE_ADDR',  '069 User group access not allowed from client location'                                );

// Validating posted object->method
define ( 'HPAPI_STR_METHOD_VDR',            '071 400 Method property "vendor" does not exist'                                       );
define ( 'HPAPI_STR_METHOD_VDR_STR',        '072 400 Method property "vendor" is not a string'                                      );
define ( 'HPAPI_STR_METHOD_VDR_PTH',        '073 400 Method vendor directory not found'                                             );
define ( 'HPAPI_STR_METHOD_PKG',            '074 400 Method property "package" does not exist'                                      );
define ( 'HPAPI_STR_METHOD_PKG_STR',        '075 400 Method property "package" is not a string'                                     );
define ( 'HPAPI_STR_METHOD_PKG_PTH',        '076 400 Method package directory not found'                                            );
define ( 'HPAPI_STR_METHOD_CLS',            '077 400 Method property "class" does not exist'                                        );
define ( 'HPAPI_STR_METHOD_CLS_STR',        '078 400 Method property "class" is not a string'                                       );
define ( 'HPAPI_STR_METHOD_CLS_PTH',        '079 400 Method package does not contain class file'                                    );
define ( 'HPAPI_STR_METHOD_MTD',            '080 400 Method property "method" does not exist'                                       );
define ( 'HPAPI_STR_METHOD_MTD_STR',        '081 400 Method property "method" is not a string'                                      );
define ( 'HPAPI_STR_METHOD_ARGS',           '082 400 Method property "arguments" does not exist'                                    );
define ( 'HPAPI_STR_METHOD_ARGS_ARR',       '083 400 Method property "arguments" is not an array'                                   );
define ( 'HPAPI_STR_METHOD_DFN_INC',        '084 500 Could not include definition file'                                             );
define ( 'HPAPI_STR_METHOD_CLS_INC',        '085 500 Could not include class file'                                                  );
define ( 'HPAPI_STR_METHOD_CLS_GOT',        '086 500 Class file included but class does not exist'                                  );
define ( 'HPAPI_STR_METHOD_CLS_NEW',        '087 500 Class exists but could not be instantiated'                                    );
define ( 'HPAPI_STR_METHOD_MTD_GOT',        '088 500 Method not in instantiated class'                                              );
define ( 'HPAPI_STR_AUTH',                  '089 403 Not allowed'                                                                   );

// Running method
define ( 'HPAPI_STR_DB_MTD_ARGS',           '101 400 Incorrect argument count for method'                                           );
define ( 'HPAPI_STR_DB_MTD_ARG_VAL',        '102 400 Invalid method argument'                                                       );
define ( 'HPAPI_STR_DB_SPR_MODEL',          '103 500 No database for data model'                                                    );
define ( 'HPAPI_STR_METHOD_EXCEPTION',      '104 500 Method threw an exception'                                                     );
define ( 'HPAPI_STR_DB_Z',                  '105 500 Empty arguments to database function'                                          );
define ( 'HPAPI_STR_DB_MTD_ACCESS',         '106 403 Method is not available'                                                       );
define ( 'HPAPI_STR_DB_MTD_REMOTE_ADDR',    '107 403 Remote address not allowed for user group(s)'                                  );

// Calling stored procedures
define ( 'HPAPI_STR_DB_SPR_NO_SPR',         '201 500 Method did not give stored procedure'                                          );
define ( 'HPAPI_STR_DB_SPR_AVAIL',          '202 403 Stored procedure not available'                                                );
define ( 'HPAPI_STR_DB_SPR_ARGS',           '203 500 Incorrect argument count for stored procedure'                                 );
define ( 'HPAPI_STR_DB_SPR_ARG_VAL',        '204 500 Invalid stored procedure argument'                                             );
define ( 'HPAPI_STR_DB_SPR_ARG_TYPE',       '205 500 Illegal data type for stored procedure argument'                               );
define ( 'HPAPI_STR_ERROR_DB',              '206 500 SQL execution error'                                                           );

// SSL notice
define ( 'HPAPI_STR_PLAIN',                 'WARNING - UNENCRYPTED CONNECTION'                                                      );

// Method notices
define ( 'HPAPI_STR_DECODE_NOTHING',        '\Hpapi\Hpapi::decodePost(): nothing was posted'                                        );
define ( 'HPAPI_STR_DECODE_LENGTH',         '\Hpapi\Hpapi::decodePost(): posted data is too long'                                   );
define ( 'HPAPI_STR_DB_EMPTY',              '\Hpapi\Db::call(): empty argument(s)'                                                  );
define ( 'HPAPI_STR_2D_ARRAY',              '\Hpapi\Utility::parse2D(): a 2-D array was not given'                                  );
define ( 'HPAPI_STR_EXPORT_ARRAY_FILE',     '\Hpapi\Hpapi::exportArray(): file is not writable'                                     );
define ( 'HPAPI_STR_EXPORT_ARRAY_ARR',      '\Hpapi\Hpapi::exportArray(): variable is not an array'                                 );
define ( 'HPAPI_STR_RESET_PRIVS_FILE',      '\Hpapi\Hpapi::resetPrivileges(): privileges file is not writable'                      );

// Database notices
define ( 'HPAPI_STR_DB_SPR_PREP',           'Query preparation failed'                                                              );
define ( 'HPAPI_STR_DB_SPR_BIND',           'Query binding failed'                                                                  );
define ( 'HPAPI_STR_DB_SPR_EXEC',           'Query execution failed'                                                                );

// Validation strings
define ( 'HPAPI_STR_VALID_PATTERN',         'must match pattern'                                                                    );
define ( 'HPAPI_STR_VALID_EXPRESSION',      'must match regular expression'                                                         );
define ( 'HPAPI_STR_VALID_PHP_FILTER',      'must pass validation filter'                                                           );
define ( 'HPAPI_STR_VALID_LMIN',            'must have character length at least'                                                   );
define ( 'HPAPI_STR_VALID_LMAX',            'must have character length no more than'                                               );
define ( 'HPAPI_STR_VALID_VMIN',            'must have value at least'                                                              );
define ( 'HPAPI_STR_VALID_VMAX',            'must have value no more than'                                                          );

// Userland configuration - definitions and classes
require_once HPAPI_DIR_CONFIG.'/whitelamp-uk/hpapi-hpapi.cfg.php';

