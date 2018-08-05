<?php

// Level of identification for allowing a response 
define ( 'HPAPI_ANON_LEVEL_NONE',           0                                                                                       );
define ( 'HPAPI_ANON_LEVEL_EMAIL',          1                                                                                       );
define ( 'HPAPI_ANON_LEVEL_USER',           2                                                                                       );
define ( 'HPAPI_ANON_LEVEL_KEY',            3                                                                                       );

// File suffix for PHP classes
define ( 'HPAPI_CLASS_SUFFIX',              '.class.php'                                                                            );

// Content header values
define ( 'HPAPI_CONTENT_TYPE_HTML',         'text/html'                                                                             );
define ( 'HPAPI_CONTENT_TYPE_JSON',         'application/json; charset=utf-8'                                                       );
define ( 'HPAPI_CONTENT_TYPE_TEXT',         'text/plain; charset=utf-8'                                                             );
define ( 'HPAPI_CONTENT_TYPE_UNKNOWN',      'unknown/unknown'                                                                       );

// Definitions for `hpapi_pattern`.`pattern_Constraints` for hpapi (and supporting class) methods and stored procedures
define ( 'HPAPI_PATTERN_DESC_CLASS',        'must be a valid PHP class name'                                                        );
define ( 'HPAPI_PATTERN_DESC_DB_BOOL',      'must be 0 or 1'                                                                        );
define ( 'HPAPI_PATTERN_DESC_INT_HHMMSS',   'must be 6 digits representing a time - HHMMSS'                                         );
define ( 'HPAPI_PATTERN_DESC_INT_YYYYMMDD', 'must be 8 digits representing a date - YYYYMMDD'                                       );
define ( 'HPAPI_PATTERN_DESC_MEDIA_URI',    'must be linux-friendly media request URI'                                              );
define ( 'HPAPI_PATTERN_DESC_IPV4',         'must be valid IPv4 address'                                                            );
define ( 'HPAPI_PATTERN_DESC_PASSWORD_1',   'must have at least 8 characters with at least one: big letter, small letter, number'   );
define ( 'HPAPI_PATTERN_DESC_ALPHA_LC',     'must have only small letters (up to 64 characters)'                                    );
define ( 'HPAPI_PATTERN_DESC_VARCHAR_255',  'must have no more than 255 characters of any type'                                     );
define ( 'HPAPI_PATTERN_DESC_VARCHAR_64',   'must have no more than 64 characters of any type'                                      );

// Initiating response
define ( 'HPAPI_STR_INIT',                  '005 500 \Hpapi\Hpapi could not be initialised'                                         );
define ( 'HPAPI_STR_SSL',                   '006 400 SSL required but not used'                                                     );
define ( 'HPAPI_STR_CONTENT_TYPE',          '007 400 Client header indicates wrong content type'                                    );
define ( 'HPAPI_STR_JSON_DECODE',           '008 400 Cannot decode request'                                                         );
define ( 'HPAPI_STR_SYS_CFG',               '009 500 Could not load system configuration'                                           );
define ( 'HPAPI_STR_AUTH_DENIED',           '010 403 Access denied'                                                                 );
define ( 'HPAPI_STR_PLAIN',                 '011 WARNING - UNENCRYPTED CONNECTION'                                                  );

// Validating posted object properties
define ( 'HPAPI_STR_DATETIME',              '021 400 Property "datetime" does not exist'                                            );
define ( 'HPAPI_STR_KEY',                   '022 400 Property "key" does not exist'                                                 );
define ( 'HPAPI_STR_EMAIL',                 '023 400 Property "email" does not exist'                                               );
define ( 'HPAPI_STR_PASSWORD',              '024 400 Property "password" does not exist'                                            );
define ( 'HPAPI_STR_METHOD',                '025 400 Property "method" does not exist'                                              );
define ( 'HPAPI_STR_METHOD_OBJ',            '026 400 Property "method" is not an object'                                            );
define ( 'HPAPI_STR_METHOD_VENDOR',         '027 400 Method property "vendor" was not given'                                        );
define ( 'HPAPI_STR_METHOD_PACKAGE',        '028 400 Method property "package" was not given'                                       );
define ( 'HPAPI_STR_METHOD_CLASS',          '029 400 Method property "class" was not given'                                         );
define ( 'HPAPI_STR_METHOD_METHOD',         '030 400 Method property "method" was not given'                                        );
define ( 'HPAPI_STR_DB_CFG',                '031 500 DB configuration error - could not load database configuration'                );
define ( 'HPAPI_STR_DB_DFN',                '032 500 DB configuration error - could not load database definition'                   );
define ( 'HPAPI_STR_DB_OBJ',                '033 500 Could not construct database object'                                           );
define ( 'HPAPI_STR_DB_CONN',               '034 500 Could not connect to database'                                                 );

// Evaluating authentication status
define ( 'HPAPI_STR_AUTH_RECOG',            '041 Anonymous access (user not recognised)'                                            );
define ( 'HPAPI_STR_AUTH_ACTIVE',           '042 Anonymous access (user not active)'                                                );
define ( 'HPAPI_STR_AUTH_EMAIL',            '043 Anonymous access (email not recognised)'                                           );
define ( 'HPAPI_STR_AUTH_VERIFY',           '044 Anonymous access (email not verified)'                                             );
define ( 'HPAPI_STR_AUTH_PWD',              '045 Anonymous access (email not authenticated)'                                        );
define ( 'HPAPI_STR_AUTH_OK',               '046 Access allowed (fully authenticated)'                                              );

// Validating posted object->method
define ( 'HPAPI_STR_METHOD_VDR',            '051 400 Method property "vendor" does not exist'                                       );
define ( 'HPAPI_STR_METHOD_VDR_STR',        '052 400 Method property "vendor" is not a string'                                      );
define ( 'HPAPI_STR_METHOD_VDR_PTH',        '053 400 Method vendor directory not found'                                             );
define ( 'HPAPI_STR_METHOD_PKG',            '054 400 Method property "package" does not exist'                                      );
define ( 'HPAPI_STR_METHOD_PKG_STR',        '055 400 Method property "package" is not a string'                                     );
define ( 'HPAPI_STR_METHOD_PKG_PTH',        '056 400 Method package directory not found'                                            );
define ( 'HPAPI_STR_METHOD_CLS',            '057 400 Method property "class" does not exist'                                        );
define ( 'HPAPI_STR_METHOD_CLS_STR',        '058 400 Method property "class" is not a string'                                       );
define ( 'HPAPI_STR_METHOD_CLS_PTH',        '059 400 Method package does not contain class file'                                    );
define ( 'HPAPI_STR_METHOD_MTD',            '060 400 Method property "method" does not exist'                                       );
define ( 'HPAPI_STR_METHOD_MTD_STR',        '061 400 Method property "method" is not a string'                                      );
define ( 'HPAPI_STR_METHOD_ARGS',           '062 400 Method property "arguments" does not exist'                                    );
define ( 'HPAPI_STR_METHOD_ARGS_ARR',       '063 400 Method property "arguments" is not an array'                                   );
define ( 'HPAPI_STR_METHOD_DFN_INC',        '064 500 Could not include definition file'                                             );
define ( 'HPAPI_STR_METHOD_CLS_INC',        '065 500 Could not include class file'                                                  );
define ( 'HPAPI_STR_METHOD_CLS_GOT',        '066 500 Class file included but class does not exist'                                  );
define ( 'HPAPI_STR_METHOD_CLS_NEW',        '067 500 Class exists but could not be instantiated'                                    );
define ( 'HPAPI_STR_METHOD_MTD_GOT',        '068 500 Method not in instantiated class'                                              );
define ( 'HPAPI_STR_AUTH',                  '069 403 Not allowed'                                                                   );

// Running method
define ( 'HPAPI_STR_DB_MTD_ARGS',           '081 400 Incorrect argument count for method'                                           );
define ( 'HPAPI_STR_DB_MTD_ARG_VAL',        '082 400 Invalid method argument'                                                       );
define ( 'HPAPI_STR_DB_SPR_MODEL',          '083 500 No database for data model'                                                    );
define ( 'HPAPI_STR_METHOD_EXCEPTION',      '084 Method threw an exception'                                                         );
define ( 'HPAPI_STR_DB_Z',                  '085 Empty arguments to database function'                                              );
define ( 'HPAPI_STR_DB_MTD_ACCESS',         '086 Method is not available'                                                           );
define ( 'HPAPI_STR_DB_MTD_LOCN',           '087 Method is not available for client location'                                       );

// Calling stored procedures
define ( 'HPAPI_STR_DB_SPR_ARGS',           '101 500 Incorrect argument count for stored procedure'                                 );
define ( 'HPAPI_STR_DB_SPR_ARG_VAL',        '102 500 Invalid stored procedure argument'                                             );
define ( 'HPAPI_STR_DB_SPR_ARG_TYPE',       '103 500 Illegal data type for stored procedure argument'                               );
define ( 'HPAPI_STR_DB_SPR_PREP',           '104 Query preparation failed'                                                          );
define ( 'HPAPI_STR_DB_SPR_BIND',           '105 Query binding failed'                                                              );
define ( 'HPAPI_STR_DB_SPR_EXEC',           '106 Query execution failed'                                                            );
define ( 'HPAPI_STR_ERROR_DB',              '107 500 Data retrieval error'                                                          );

// Method notices
define ( 'HPAPI_STR_DECODE_LENGTH',         '\Hpapi\Hpapi::decodePost(): posted data is too long'                                   );
define ( 'HPAPI_STR_DB_EMPTY',              '\Hpapi\Db::call(): empty argument(s)'                                                  );
define ( 'HPAPI_STR_DIAGNOSTIC_ONLY',       '\Hpapi\Utility::sprs(): only returns data as diagnostic'                               );
define ( 'HPAPI_STR_2D_ARRAY',              '\Hpapi\Utility::parse2D(): a 2-D array was not given'                                  );

// Validation strings
define ( 'HPAPI_STR_VALID_EXPRESSION',      'must match regular expression'                                                         );
define ( 'HPAPI_STR_VALID_PHP_FILTER',      'must pass validation filter'                                                           );
define ( 'HPAPI_STR_VALID_LMIN',            'must have character length at least'                                                   );
define ( 'HPAPI_STR_VALID_LMAX',            'must have character length no more than'                                               );
define ( 'HPAPI_STR_VALID_VMIN',            'must have value at least'                                                              );
define ( 'HPAPI_STR_VALID_VMAX',            'must have value no more than'                                                          );

// Userland configuration - definitions and classes
require_once HPAPI_DIR_CONFIG.'/hpapi-hpapi.cfg.php';

?>
