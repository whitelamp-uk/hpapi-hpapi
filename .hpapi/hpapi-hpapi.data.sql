-- Adminer 4.6.2 MySQL dump

SET NAMES utf8;
SET time_zone = '+00:00';
SET foreign_key_checks = 0;
SET sql_mode = 'NO_AUTO_VALUE_ON_ZERO';

INSERT IGNORE INTO `hpapi_call` (`call_Model`, `call_Spr`, `call_Vendor`, `call_Package`, `call_Class`, `call_Method`) VALUES
('HpapiModel',	'hpapiMethodargs',	'whitelamp',	'hpapi-utility',	'\\Hpapi\\Utility',	'describeMethod'),
('HpapiModel',	'hpapiMethods',	'whitelamp',	'hpapi-utility',	'\\Hpapi\\Utility',	'methods'),
('HpapiModel',	'hpapiUsergroups',	'whitelamp',	'hpapi-utility',	'\\Hpapi\\Utility',	'usergroups'),
('HpapiModel',	'hpapiUUID',	'whitelamp',	'hpapi-utility',	'\\Hpapi\\Utility',	'uuid');

INSERT IGNORE INTO `hpapi_email` (`email_Verified`, `email_Email`, `email_User_UUID`) VALUES
(1,	'sysadmin@no.where',	'20180720110427::322025bd-8ff2-11e8-902b-001f16148bc1'),
(1,	'test.1@no.where',	'20180720110427::57d2eff7-8ff3-11e8-902b-001f16148bc1');

INSERT IGNORE INTO `hpapi_key` (`key_Expired`, `key_Key`, `key_Remote_Addr_Pattern`, `key_User_UUID`, `key_Vendor`, `key_Package`) VALUES
(0,	'20180725104327::0e0f4ce8-8fee-11e8-902b-001f16148bc1',	'^127\\.0\\.0\\.[0-9]*$',	'20180720110427::322025bd-8ff2-11e8-902b-001f16148bc1',	'whitelamp',	'hpapi-utility'),
(0,	'20180720110427::89c56ad8-8ff3-11e8-902b-001f16148bc1',	'^127\\.0\\.0\\.[0-9]*$',	'20180720110427::57d2eff7-8ff3-11e8-902b-001f16148bc1',	'whitelamp',	'hpapi-utility');

INSERT IGNORE INTO `hpapi_level` (`level_Level`, `level_Name`, `level_Notes`) VALUES
(0,	'System',	'Background processes with god-like powers.'),
(1,	'Administration',	'Unrestricted access to the data assets of the organisation but should not have the ability to manipulate the system via its configuration data.'),
(2,	'System administration',	'Potentially god-like but ethical constraints say they are not. Full access to configuration and support of a system but no access to the data assets of the organisation.'),
(10,	'Management',	'Staff with access to more-than-usual data and/or methods.'),
(100,	'Staff',	'Staff with access to general office administration data and methods.'),
(1000,	'Agent (internal)',	'Agent for the internal organisation having a set of data and methods to support activities from the outside of the organisation.'),
(10000,	'Agent (external)',	'Agent acting on behalf of an external organisation having data management policies and GDPR obligations.'),
(1000000,	'Public',	'Public registered customer or web site user having personal agency only.'),
(10000000,	'Anonymous',	'Unidentified user with a valid API key but passing no other authentication');

INSERT IGNORE INTO `hpapi_membership` (`membership_User_UUID`, `membership_Usergroup`) VALUES
('20180720110427::57d2eff7-8ff3-11e8-902b-001f16148bc1',	'admin'),
('20180720000000::2d38515c-8ff9-11e8-902b-001f16148bc1',	'anon'),
('20180720110427::322025bd-8ff2-11e8-902b-001f16148bc1',	'sysadmin');

INSERT IGNORE INTO `hpapi_method` (`method_Vendor`, `method_Package`, `method_Class`, `method_Method`, `method_Label`, `method_Notes`) VALUES
('whitelamp',	'hpapi-utility',	'\\Hpapi\\Utility',	'describeMethod',	'Method description',	'Method, argument and validation details'),
('whitelamp',	'hpapi-utility',	'\\Hpapi\\Utility',	'methods',	'My methods',	'Methods available to the current user.'),
('whitelamp',	'hpapi-utility',	'\\Hpapi\\Utility',	'usergroups',	'My user groups',	'User groups for the current user.'),
('whitelamp',	'hpapi-utility',	'\\Hpapi\\Utility',	'uuid',	'Get UUID',	'Hpapi default UUID generating method.');

INSERT IGNORE INTO `hpapi_methodarg` (`methodarg_Vendor`, `methodarg_Package`, `methodarg_Class`, `methodarg_Method`, `methodarg_Argument`, `methodarg_Name`, `methodarg_Empty_Allowed`, `methodarg_Pattern`) VALUES
('whitelamp',	'hpapi-utility',	'\\Hpapi\\Utility',	'describeMethod',	1,	'Vendor',	0,	'vendor'),
('whitelamp',	'hpapi-utility',	'\\Hpapi\\Utility',	'describeMethod',	2,	'Package',	0,	'package'),
('whitelamp',	'hpapi-utility',	'\\Hpapi\\Utility',	'describeMethod',	3,	'Class',	0,	'class'),
('whitelamp',	'hpapi-utility',	'\\Hpapi\\Utility',	'describeMethod',	4,	'Method',	0,	'method'),
('whitelamp',	'hpapi-utility',	'\\Hpapi\\Utility',	'uuid',	1,	'Date (yyyymmdd)',	1,	'yyyymmdd'),
('whitelamp',	'hpapi-utility',	'\\Hpapi\\Utility',	'uuid',	2,	'Time (hhmmss)',	1,	'hhmmss');

INSERT IGNORE INTO `hpapi_model` (`model_Model`, `model_Notes`, `model_DSN`, `model_Usr`, `model_Pwd`) VALUES
('HpapiModel',	'Model for the API itself. Consequently there are no dns/usr/pwd details for a blueprint.',	'',	'',	'');

INSERT IGNORE INTO `hpapi_node` (`node_Node`, `node_Name`) VALUES
('paddy',	'Mark\'s laptop');

INSERT IGNORE INTO `hpapi_package` (`package_Vendor`, `package_Package`, `package_Notes`) VALUES
('whitelamp',	'hpapi-utility',	'Hpapi utility class(es).');

INSERT IGNORE INTO `hpapi_pattern` (`pattern_Pattern`, `pattern_Constraints`, `pattern_Expression`, `pattern_Input`, `pattern_Php_Filter`, `pattern_Length_Minimum`, `pattern_Length_Maximum`, `pattern_Value_Minimum`, `pattern_Value_Maximum`) VALUES
('alpha-lc-64',	'HPAPI_PATTERN_DESC_ALPHA_LC',	'^[a-z]*$',	'text',	'',	1,	64,	'',	''),
('class',	'HPAPI_PATTERN_DESC_CLASS',	'^\\\\[A-Z][A-z]*\\\\[A-Z][A-z]*$',	'text',	'',	4,	64,	'',	''),
('db-boolean',	'HPAPI_PATTERN_DESC_DB_BOOL',	'',	'checkbox',	'FILTER_VALIDATE_INT',	0,	0,	'0',	'1'),
('email',	'HPAPI_PATTERN_DESC_EMAIL',	'',	'email',	'FILTER_VALIDATE_EMAIL',	3,	254,	'',	''),
('hhmmss',	'HPAPI_PATTERN_DESC_INT_HHMMSS',	'^[0-9]*$',	'text',	'',	6,	6,	'000000',	'235959'),
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
('yyyymmdd',	'HPAPI_PATTERN_DESC_INT_YYYYMMDD',	'',	'text',	'FILTER_VALIDATE_INT',	8,	8,	'20000101',	'99991231');

INSERT IGNORE INTO `hpapi_run` (`run_Usergroup`, `run_Vendor`, `run_Package`, `run_Class`, `run_Method`) VALUES
('anon',	'whitelamp',	'hpapi-utility',	'\\Hpapi\\Utility',	'describeMethod'),
('anon',	'whitelamp',	'hpapi-utility',	'\\Hpapi\\Utility',	'methods'),
('anon',	'whitelamp',	'hpapi-utility',	'\\Hpapi\\Utility',	'usergroups'),
('anon',	'whitelamp',	'hpapi-utility',	'\\Hpapi\\Utility',	'uuid');

INSERT IGNORE INTO `hpapi_spr` (`spr_Model`, `spr_Spr`, `spr_Notes`) VALUES
('HpapiModel',	'hpapiAuthenticate',	'Authenticate a given key/email/password/method.'),
('HpapiModel',	'hpapiMethodargs',	'Used by \\Hpapi\\Hpapi::authenticate() on every request but registered here because it is also deployed by \\Hpapi\\Utility::describeMethod()'),
('HpapiModel',	'hpapiMethods',	'List of methods for a user UUID (authenticated or not).'),
('HpapiModel',	'hpapiSprargs',	'List of stored procedure arguments for a given method.'),
('HpapiModel',	'hpapiUsergroups',	'Usergroups for a user UUID.'),
('HpapiModel',	'hpapiUUID',	'Return UUID based on YYMMDD, HHMMSS and UUID v4.');

INSERT IGNORE INTO `hpapi_sprarg` (`sprarg_Model`, `sprarg_Spr`, `sprarg_Argument`, `sprarg_Name`, `sprarg_Empty_Allowed`, `sprarg_Pattern`) VALUES
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

INSERT IGNORE INTO `hpapi_user` (`user_Active`, `user_UUID`, `user_Notes`, `user_Name`, `user_Password_Hash`) VALUES
(1,	'20180720000000::2d38515c-8ff9-11e8-902b-001f16148bc1',	'Single Typhoid Mary user representing any API request identified by its membership of the \"anon\" user group and having no key or email address.',	'User, Unauthenticated',	''),
(1,	'20180720110427::322025bd-8ff2-11e8-902b-001f16148bc1',	'Slow, but the penny usually drops eventually.',	'Administrator, System',	'$2y$10$hLSdApW6.30YLK3ze49uSu7OV0gmS3ZT65pufxDPGiMxsmW3bykeq'),
(1,	'20180720110427::57d2eff7-8ff3-11e8-902b-001f16148bc1',	'Test user 1', 'User, Test 1',	'$2y$10$hLSdApW6.30YLK3ze49uSu7OV0gmS3ZT65pufxDPGiMxsmW3bykeq');

INSERT IGNORE INTO `hpapi_usergroup` (`usergroup_Usergroup`, `usergroup_Level`, `usergroup_Name`, `usergroup_Notes`) VALUES
('admin',	1,	'Administrators',	'Users performing high level administration of business data within the model.'),
('anon',	10000000,	'Unknown Users',	'Users having no identity.'),
('sysadmin',	2,	'System Administrators',	'Users performing high level administration of configuration data within the model.');

-- 2018-08-05 22:40:00
