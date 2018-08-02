<?php

define ( 'HPAPI_ANON_LEVEL_NONE',           0                                                                                       );
define ( 'HPAPI_ANON_LEVEL_EMAIL',          1                                                                                       );
define ( 'HPAPI_ANON_LEVEL_USER',           2                                                                                       );
define ( 'HPAPI_ANON_LEVEL_KEY',            3                                                                                       );

define ( 'HPAPI_CLASS_SUFFIX',              '.class.php'                                                                            );

define ( 'HPAPI_CONTENT_TYPE_HTML',         'application/html; charset=utf-8'                                                       );
define ( 'HPAPI_CONTENT_TYPE_JSON',         'application/json; charset=utf-8'                                                       );
define ( 'HPAPI_CONTENT_TYPE_TEXT',         'text/plain; charset=utf-8'                                                             );
define ( 'HPAPI_CONTENT_TYPE_UNKNOWN',      'unknown/unknown'                                                                       );

define ( 'HPAPI_DECODE_LENGTH',             'Posted data too long'                                                                  );
define ( 'HPAPI_DECODE_HTML_SUPPORT',       'HTML (as XML) not currently supported'                                                 );

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

define ( 'HPAPI_STR_INIT',                  '002 \Hpapi\Hpapi could not be initialised'                                             );
define ( 'HPAPI_STR_SSL',                   '003 SSL required but not used'                                                         );
define ( 'HPAPI_STR_JSON_DECODE',           '004 Cannot interpret JSON'                                                             );
define ( 'HPAPI_STR_HTML_DECODE',           '005 Cannot interpret HTML'                                                             );
define ( 'HPAPI_STR_DECODE',                '006 Cannot decode posted data'                                                         );
define ( 'HPAPI_STR_DECODE_TYPE',           '007 Cannot decode content type'                                                        );

define ( 'HPAPI_STR_DATETIME',              '011 Property "datetime" does not exist'                                                );
define ( 'HPAPI_STR_KEY',                   '012 Property "key" does not exist'                                                     );
define ( 'HPAPI_STR_EMAIL',                 '013 Property "email" does not exist'                                                   );
define ( 'HPAPI_STR_PASSWORD',              '014 Property "password" does not exist'                                                );
define ( 'HPAPI_STR_METHOD',                '015 Property "method" does not exist'                                                  );
define ( 'HPAPI_STR_METHOD_OBJ',            '016 Property "method" is not an object'                                                );
define ( 'HPAPI_STR_DB_TYPE',               '017 DB configuration error - driver not supported'                                     );
define ( 'HPAPI_STR_DB_OBJ',                '018 Could not construct database object'                                               );
define ( 'HPAPI_STR_DB_CONN',               '019 Could not connect to database'                                                     );

define ( 'HPAPI_STR_AUTH_DENIED',           '031 Access denied'                                                                     );
define ( 'HPAPI_STR_AUTH_RECOG',            '032 Anonymous access (user not recognised)'                                            );
define ( 'HPAPI_STR_AUTH_ACTIVE',           '033 Anonymous access (user not active)'                                                );
define ( 'HPAPI_STR_AUTH_EMAIL',            '034 Anonymous access (email not recognised)'                                           );
define ( 'HPAPI_STR_AUTH_VERIFY',           '035 Anonymous access (email not verified)'                                             );
define ( 'HPAPI_STR_AUTH_PWD',              '036 Anonymous access (email not authenticated)'                                        );
define ( 'HPAPI_STR_AUTH_OK',               '037 Access allowed (fully authenticated)'                                              );

define ( 'HPAPI_STR_METHOD_VDR',            '041 Method property "vendor" does not exist'                                           );
define ( 'HPAPI_STR_METHOD_VDR_STR',        '042 Method property "vendor" is not a string'                                          );
define ( 'HPAPI_STR_METHOD_VDR_PTH',        '043 Method vendor directory not found'                                                 );
define ( 'HPAPI_STR_METHOD_PKG',            '044 Method property "package" does not exist'                                          );
define ( 'HPAPI_STR_METHOD_PKG_STR',        '045 Method property "package" is not a string'                                         );
define ( 'HPAPI_STR_METHOD_PKG_PTH',        '046 Method package directory not found'                                                );
define ( 'HPAPI_STR_METHOD_CLS',            '047 Method property "class" does not exist'                                            );
define ( 'HPAPI_STR_METHOD_CLS_STR',        '048 Method property "class" is not a string'                                           );
define ( 'HPAPI_STR_METHOD_CLS_PTH',        '049 Method package does not contain class file'                                        );
define ( 'HPAPI_STR_METHOD_MTD',            '050 Method property "method" does not exist'                                           );
define ( 'HPAPI_STR_METHOD_MTD_STR',        '051 Method property "method" is not a string'                                          );
define ( 'HPAPI_STR_METHOD_ARGS',           '052 Method property "arguments" does not exist'                                        );
define ( 'HPAPI_STR_METHOD_ARGS_ARR',       '053 Method property "arguments" is not an array'                                       );
define ( 'HPAPI_STR_METHOD_DFN_INC',        '054 Could not include definition file'                                                 );
define ( 'HPAPI_STR_METHOD_CLS_INC',        '055 Could not include class file'                                                      );
define ( 'HPAPI_STR_METHOD_CLS_GOT',        '056 Class file included but class does not exist'                                      );
define ( 'HPAPI_STR_METHOD_CLS_NEW',        '057 Class exists but could not be instantiated'                                        );
define ( 'HPAPI_STR_METHOD_MTD_GOT',        '058 Method not in instantiated class'                                                  );
define ( 'HPAPI_STR_AUTH',                  '059 Not allowed'                                                                       );

define ( 'HPAPI_STR_DB_MTD_ARGS',           '071 Incorrect argument count for method'                                               );
define ( 'HPAPI_STR_DB_MTD_ARG_VAL',        '072 Invalid method argument'                                                           );
define ( 'HPAPI_STR_METHOD_EXCEPTION',      '073 Method threw an exception'                                                         );
define ( 'HPAPI_STR_DB_SPR_Z',              '074 First argument zero length'                                                        );
define ( 'HPAPI_STR_DB_MTD_ACCESS',         '075 Method is not available'                                                           );
define ( 'HPAPI_STR_DB_MTD_LOCN',           '076 Method is not available for client location'                                       );

define ( 'HPAPI_STR_DB_SPR_ACCESS',         '091 Stored procedure is not available'                                                 );
define ( 'HPAPI_STR_DB_SPR_ARGS',           '092 Incorrect argument count for stored procedure'                                     );
define ( 'HPAPI_STR_DB_SPR_ARG_VAL',        '093 Invalid stored procedure argument'                                                 );
define ( 'HPAPI_STR_DB_SPR_ARG_TYPE',       '094 Illegal data type for stored procedure argument'                                   );
define ( 'HPAPI_STR_DB_SPR_PREP',           '095 Query preparation failed'                                                          );
define ( 'HPAPI_STR_DB_SPR_BIND',           '096 Query binding failed'                                                              );
define ( 'HPAPI_STR_DB_SPR_EXEC',           '097 Query execution failed'                                                            );
define ( 'HPAPI_STR_ERROR_DB',              '098 Data retrieval error'                                                              );

define ( 'HPAPI_STR_VALID_EXPRESSION',      '111 Must match regular expression'                                                     );
define ( 'HPAPI_STR_VALID_PHP_FILTER',      '112 Must pass validation filter'                                                       );
define ( 'HPAPI_STR_VALID_LMIN',            '113 Must have character length at least'                                               );
define ( 'HPAPI_STR_VALID_LMAX',            '114 Must have character length no more than'                                           );
define ( 'HPAPI_STR_VALID_VMIN',            '115 Must have value at least'                                                          );
define ( 'HPAPI_STR_VALID_VMAX',            '116 Must have value no more than'                                                      );

define ( 'HPAPI_DIAGNOSTIC_ONLY',           '201 Method only returns data as diagnostic'                                            );
define ( 'HPAPI_STR_2D_ARRAY',              '202 \Hpapi\Utility::parse2D(): a 2-D array was not given'                              );

require_once HPAPI_DIR_CONFIG.'/hpapi-hpapi.cfg.php';

?>
