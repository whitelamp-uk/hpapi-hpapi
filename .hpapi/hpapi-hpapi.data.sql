
SET NAMES utf8;
SET time_zone = '+00:00';
SET foreign_key_checks = 0;
SET sql_mode = 'NO_AUTO_VALUE_ON_ZERO';

INSERT IGNORE INTO `hpapi_email` (`email_Verified`, `email_Email`, `email_User_UUID`) VALUES
(1,	'sysadmin@no.where',	'20180720110427::322025bd-8ff2-11e8-902b-001f16148bc1'),
(1,	'test.1@no.where',	'20180720110427::57d2eff7-8ff3-11e8-902b-001f16148bc1');

INSERT IGNORE INTO `hpapi_key` (`key_Key`, `key_Expired`, `key_Remote_Addr_Pattern`) VALUES
('20180720110427::89c56ad8-8ff3-11e8-902b-001f16148bc1',	0,	'^127\\.0\\.0\\.[0-9]*$'),
('20180725104327::0e0f4ce8-8fee-11e8-902b-001f16148bc1',	0,	'^127\\.0\\.0\\.[0-9]*$');

INSERT IGNORE INTO `hpapi_level` (`level_Level`, `level_Name`, `level_Notes`) VALUES
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

INSERT IGNORE INTO `hpapi_membership` (`membership_User_UUID`, `membership_Usergroup`) VALUES
('20180720110427::322025bd-8ff2-11e8-902b-001f16148bc1',	'sysadmin'),
('20180720110427::57d2eff7-8ff3-11e8-902b-001f16148bc1',	'admin');

INSERT IGNORE INTO `hpapi_model` (`model_Model`, `model_Notes`, `model_DSN`, `model_Usr`, `model_Pwd`) VALUES
('HpapiModel',	'Model for the API itself. Consequently there are no dns/usr/pwd details for a blueprint.',	'',	'',	'');

INSERT IGNORE INTO `hpapi_package` (`package_Vendor`, `package_Package`, `package_Notes`) VALUES
('whitelamp-uk',	'hpapi-utility',	'Hpapi utility class(es).');

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
('yyyy-mm-dd',	'HPAPI_PATTERN_DESC_YYYY_MM_DD',	'^[0-9]{4}-[0-9]{2}-[0-9]{2}$',	'date',	'',	10,	10,	'2000-01-01',	'2100-12-31'),
('yyyymmdd',	'HPAPI_PATTERN_DESC_INT_YYYYMMDD',	'',	'text',	'FILTER_VALIDATE_INT',	8,	8,	'20000101',	'99991231');

INSERT IGNORE INTO `hpapi_user` (`user_Active`, `user_UUID`, `user_Notes`, `user_Name`, `user_Key`, `user_Password_Hash`) VALUES
(1,	'20180720110427::322025bd-8ff2-11e8-902b-001f16148bc1',	'Slow, but the penny usually drops eventually.',	'Administrator, System',	'20180725104327::0e0f4ce8-8fee-11e8-902b-001f16148bc1',	'$2y$10$hLSdApW6.30YLK3ze49uSu7OV0gmS3ZT65pufxDPGiMxsmW3bykeq'),
(1,	'20180720110427::57d2eff7-8ff3-11e8-902b-001f16148bc1',	'Test user 1',	'User, Test 1',	'20180720110427::89c56ad8-8ff3-11e8-902b-001f16148bc1',	'$2y$10$hLSdApW6.30YLK3ze49uSu7OV0gmS3ZT65pufxDPGiMxsmW3bykeq');

INSERT IGNORE INTO `hpapi_usergroup` (`usergroup_Usergroup`, `usergroup_Level`, `usergroup_Name`, `usergroup_Notes`) VALUES
('admin',	2,	'Administrators',	'Users performing high level administration of business data within the model.'),
('agent',	10000,	'Client Agents',	'Custom user group for users acting on behalf of a company client. They may or may not be operating via a third party agency organsiation (eg. a lottery provider).'),
('anon',	10000000,	'Unknown Users',	'Users having no identity.'),
('field',	1000,	'Field staff',	'Staff at off-site locations'),
('manager',	10,	'Managers',	'Admin users with relatively high privileges'),
('staff',	100,	'Office staff',	'Admin users with limited privileges'),
('sysadmin',	3,	'System Administrators',	'Users performing high level administration of configuration data within the model.');

