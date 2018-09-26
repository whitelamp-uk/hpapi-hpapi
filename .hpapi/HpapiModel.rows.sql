
SET NAMES utf8;
SET time_zone = '+00:00';
SET foreign_key_checks = 0;
SET sql_mode = 'NO_AUTO_VALUE_ON_ZERO';

INSERT IGNORE INTO `hpapi_level` (`level_level`, `level_name`, `level_notes`) VALUES
(0,	'This',	'The user group being tested and no other.'),
(1,	'System',	'Background process user with unconstrained omnipotence.'),
(2,	'Business Administration',	'Unrestricted access to this organisation\'s data assets but should not have the ability to manipulate this system via its configuration data.'),
(3,	'System administration',	'Potentially god-like - but ethical constraints say not. Full access to configuration for and support of this system but having no right of access to the data assets of this organisation.'),
(10,	'Management',	'Staff with access to more-than-usual data and/or methods.'),
(100,	'Staff',	'Staff with access to general office administration data and methods.'),
(1000,	'Field',	'Staff typically accessing data from networks not controlled by this organisation.'),
(10000,	'Agent',	'Agent acting on behalf of an organisation having data management policies and GDPR obligations.'),
(100000,	'Public',	'Public registered customer or web site user.'),
(10000000,	'Anonymous',	'Users unidentified except for the use of a valid API key.');

INSERT INTO `hpapi_method` (`method_vendor`, `method_package`, `method_class`, `method_method`, `method_label`, `method_notes`) VALUES
('whitelamp-uk',	'hpapi-utility',	'\\Hpapi\\Utility',	'describeMethod',	'Method description',	'Method, argument and validation details'),
('whitelamp-uk',	'hpapi-utility',	'\\Hpapi\\Utility',	'methods',	'My methods',	'Methods available to the current user.'),
('whitelamp-uk',	'hpapi-utility',	'\\Hpapi\\Utility',	'usergroups',	'My user groups',	'User groups for the current user.'),
('whitelamp-uk',	'hpapi-utility',	'\\Hpapi\\Utility',	'uuid',	'Get UUID',	'Hpapi default UUID generating method.');

INSERT INTO `hpapi_methodarg` (`methodarg_vendor`, `methodarg_package`, `methodarg_class`, `methodarg_method`, `methodarg_argument`, `methodarg_Name`, `methodarg_Empty_Allowed`, `methodarg_Pattern`) VALUES
('whitelamp-uk',	'hpapi-utility',	'\\Hpapi\\Utility',	'describeMethod',	1,	'Vendor',	0,	'vendor'),
('whitelamp-uk',	'hpapi-utility',	'\\Hpapi\\Utility',	'describeMethod',	2,	'Package',	0,	'package'),
('whitelamp-uk',	'hpapi-utility',	'\\Hpapi\\Utility',	'describeMethod',	3,	'Class',	0,	'class'),
('whitelamp-uk',	'hpapi-utility',	'\\Hpapi\\Utility',	'describeMethod',	4,	'Method',	0,	'method'),
('whitelamp-uk',	'hpapi-utility',	'\\Hpapi\\Utility',	'uuid',	1,	'Date (yyyymmdd)',	1,	'yyyymmdd'),
('whitelamp-uk',	'hpapi-utility',	'\\Hpapi\\Utility',	'uuid',	2,	'Time (hhmmss)',	1,	'hhmmss');

INSERT IGNORE INTO `hpapi_model` (`model_model`, `model_notes`, `model_dsn`, `model_usr`, `model_pwd`) VALUES
('HpapiModel',	'Model for the API itself. Consequently there are no dns/usr/pwd details for a blueprint.',	'',	'',	'');

INSERT IGNORE INTO `hpapi_package` (`package_vendor`, `package_package`, `package_notes`) VALUES
('whitelamp-uk',	'hpapi-utility',	'Hpapi utility class(es).');

INSERT INTO `hpapi_pattern` (`pattern_pattern`, `pattern_constraints`, `pattern_expression`, `pattern_input`, `pattern_php_filter`, `pattern_length_minimum`, `pattern_length_maximum`, `pattern_value_minimum`, `pattern_value_maximum`) VALUES
('alpha-lc-64',	'HPAPI_PATTERN_DESC_ALPHA_LC',	'^[a-z]*$',	'text',	'',	1,	64,	'',	''),
('class',	'HPAPI_PATTERN_DESC_CLASS',	'^\\\\[A-Z][A-z]*\\\\[A-Z][A-z]*$',	'text',	'',	4,	64,	'',	''),
('db-boolean',	'HPAPI_PATTERN_DESC_DB_BOOL',	'',	'checkbox',	'FILTER_VALIDATE_INT',	0,	0,	'0',	'1'),
('email',	'HPAPI_PATTERN_DESC_EMAIL',	'',	'email',	'FILTER_VALIDATE_EMAIL',	3,	254,	'',	''),
('hhmmss',	'HPAPI_PATTERN_DESC_HHMMSS',	'^[0-9]{6}$',	'text',	'',	0,	0,	'000000',	'235959'),
('ipv4',	'HPAPI_PATTERN_DESC_IPV4',	'((^|\\.)((25[0-5])|(2[0-4]\\d)|(1\\d\\d)|([1-9]?\\d))){4}$',	'text',	' ',	7,	15,	'',	''),
('method',	'HPAPI_PATTERN_DESC_METHOD',	'^[a-z][A-Za-z0-9]*$',	'text',	'',	2,	64,	'',	''),
('package',	'HPAPI_PATTERN_DESC_PACKAGE',	'^[a-z][a-z\\-]*[a-z]$',	'text',	'',	2,	64,	'',	''),
('password-1',	'HPAPI_PATTERN_DESC_PASSWORD_1',	'^(?=.*\\d)(?=.*[a-z])(?=.*[A-Z])(?!.*\\s).*$',	'password',	'',	8,	255,	'',	''),
('path-hpapi',	'HPAPI_PATTERN_DESC_MEDIA_URI',	'/[a-z0-9\\-_/]+\\.[a-z]+',	'text',	'',	4,	255,	'',	''),
('uuid-hpapi',	'HPAPI_PATTERN_DESC_UUID_HPAPI',	'^[0-9]{14}::[a-f0-9]{8}-[a-f0-9]{4}-[a-f0-9]{4}-[a-f0-9]{4}-[a-f0-9]{12}$',	'text',	'',	52,	52,	'',	''),
('uuid-v4',	'HPAPI_PATTERN_DESC_UUIDV4',	'^[a-f0-9]{8}-[a-f0-9]{4}-[a-f0-9]{4}-[a-f0-9]{4}-[a-f0-9]{12}$',	'text',	'',	36,	36,	'',	''),
('varchar-255',	'HPAPI_PATTERN_DESC_VARCHAR_255',	'',	'text',	'',	1,	255,	'',	''),
('varchar-64',	'HPAPI_PATTERN_DESC_VARCHAR_64',	'',	'text',	'',	1,	64,	'',	''),
('vendor',	'HPAPI_PATTERN_DESC_VENDOR',	'^[a-z][a-z\\-]*[a-z]$',	'text',	'',	2,	64,	'',	''),
('yyyy-mm-dd',	'HPAPI_PATTERN_DESC_YYYY_MM_DD',	'^[0-9]{4}-[0-9]{2}-[0-9]{2}$',	'date',	'',	10,	10,	'2000-01-01',	'2100-12-31'),
('yyyymmdd',	'HPAPI_PATTERN_DESC_YYYYMMDD',	'^[0-9]{8}$',	'text',	'',	0,	0,	'20000101',	'99991231');

INSERT INTO `hpapi_spr` (`spr_model`, `spr_spr`, `spr_notes`) VALUES
('HpapiModel',	'hpapiAuthenticate',	'Authenticate a given key/email/password/method.'),
('HpapiModel',	'hpapiMethodargs',	'Used by \\Hpapi\\Hpapi::authenticate() on every request but registered here because it is also deployed by \\Hpapi\\Utility::describeMethod()'),
('HpapiModel',	'hpapiMethods',	'List of methods for a user UUID (authenticated or not).'),
('HpapiModel',	'hpapiSprargs',	'List of stored procedure arguments for a given method.'),
('HpapiModel',	'hpapiUsergroups',	'Usergroups for a user UUID.'),
('HpapiModel',	'hpapiUUID',	'Return UUID based on YYMMDD, HHMMSS and UUID v4.');


INSERT INTO `hpapi_sprarg` (`sprarg_model`, `sprarg_spr`, `sprarg_argument`, `sprarg_name`, `sprarg_empty_allowed`, `sprarg_pattern`) VALUES
('HpapiModel',	'hpapiAuthenticate',	1,	'API key',	1,	'uuid-hpapi'),
('HpapiModel',	'hpapiAuthenticate',	2,	'Email address',	1,	'email'),
('HpapiModel',	'hpapiAuthenticate',	3,	'Hashed password',	1,	'varchar-255'),
('HpapiModel',	'hpapiAuthenticate',	4,	'Vendor handle',	0,	'vendor'),
('HpapiModel',	'hpapiAuthenticate',	5,	'Package handle',	0,	'package'),
('HpapiModel',	'hpapiAuthenticate',	6,	'Class (including namespace)',	0,	'class'),
('HpapiModel',	'hpapiAuthenticate',	7,	'Method',	0,	'method'),
('HpapiModel',	'hpapiMethodargs',	1,	'API key',	0,	'uuid-hpapi'),
('HpapiModel',	'hpapiMethodargs',	2,	'Email',	1,	'email'),
('HpapiModel',	'hpapiMethodargs',	3,	'Vendor',	0,	'vendor'),
('HpapiModel',	'hpapiMethodargs',	4,	'Package',	0,	'package'),
('HpapiModel',	'hpapiMethodargs',	5,	'Class',	0,	'class'),
('HpapiModel',	'hpapiMethodargs',	6,	'Method',	0,	'method'),
('HpapiModel',	'hpapiMethods',	1,	'User UUID',	0,	'uuid-hpapi'),
('HpapiModel',	'hpapiMethods',	2,	'Fully authenticated?',	0,	'db-boolean'),
('HpapiModel',	'hpapiSprargs',	1,	'Vendor handle',	0,	'vendor'),
('HpapiModel',	'hpapiSprargs',	2,	'Package handle',	0,	'package'),
('HpapiModel',	'hpapiSprargs',	3,	'Class (including namespace)',	0,	'class'),
('HpapiModel',	'hpapiSprargs',	4,	'Method',	0,	'method'),
('HpapiModel',	'hpapiUsergroups',	1,	'User UUID',	0,	'uuid-hpapi'),
('HpapiModel',	'hpapiUsergroups',	2,	'Fully authenticated?',	0,	'db-boolean'),
('HpapiModel',	'hpapiUUID',	1,	'Date (yyyymmdd)',	0,	'yyyymmdd'),
('HpapiModel',	'hpapiUUID',	2,	'Time (hhmmss)',	0,	'hhmmss');

INSERT INTO `hpapi_usergroup` (`usergroup_usergroup`, `usergroup_level`, `usergroup_name`, `usergroup_remote_addr_pattern`, `usergroup_notes`) VALUES
('admin',	2,	'Administrators',	'^.*$',	'Users performing high level administration of business data within the model.'),
('agent',	10000,	'Client Agents',	'^.*$',	'Custom user group for users acting on behalf of a company client. They may or may not be operating via a third party agency organsiation (eg. a lottery provider).'),
('anon',	10000000,	'Unknown Users',	'^.*$',	'Users having no identity.'),
('canvasser',	1000,	'Field staff',	'^.*$',	'Staff at off-site locations using doorstepper.js'),
('field',	1000,	'Field staff',	'^.*$',	'Staff at off-site locations'),
('linemanager',	1000,	'Line managers',	'^.*$',	'Line managers at off-site locations using doorstepper.js'),
('manager',	10,	'Managers',	'^.*$',	'Admin users with relatively high privileges'),
('staff',	100,	'Office staff',	'^.*$',	'Admin users with limited privileges'),
('sysadmin',	3,	'System Administrators',	'^.*$',	'Users performing high level administration of configuration data within the model.');

