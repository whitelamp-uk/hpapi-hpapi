
SET NAMES utf8;
SET time_zone = '+00:00';
SET foreign_key_checks = 0;
SET sql_mode = 'NO_AUTO_VALUE_ON_ZERO';

INSERT IGNORE INTO `hpapi_level` (`level`, `name`, `notes`) VALUES
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

INSERT IGNORE INTO `hpapi_model` (`model`, `notes`) VALUES
('HpapiModel',	'Model for the API itself.');

INSERT IGNORE INTO `hpapi_package` (`vendor`, `package`, `notes`) VALUES
('whitelamp-uk',	'hpapi-utility',	'Hpapi utility class(es).');

INSERT IGNORE  INTO `hpapi_pattern` (`pattern`, `constraints`, `expression`, `input`, `php_filter`, `length_minimum`, `length_maximum`, `value_minimum`, `value_maximum`, `created`, `updated`) VALUES
('alpha-lc-64',	'HPAPI_PATTERN_DESC_ALPHA_LC',	'^[a-z]*$',	'text',	'',	1,	64,	'',	'',	'2018-09-27 22:05:54',	'2018-09-27 22:05:54'),
('class',	'HPAPI_PATTERN_DESC_CLASS',	'^\\\\[A-Z][A-z]*\\\\[A-Z][A-z]*$',	'text',	'',	4,	64,	'',	'',	'2018-09-27 22:05:54',	'2018-09-27 22:05:54'),
('db-boolean',	'HPAPI_PATTERN_DESC_DB_BOOL',	'',	'checkbox',	'FILTER_VALIDATE_INT',	0,	0,	'0',	'1',	'2018-09-27 22:05:54',	'2018-09-27 22:05:54'),
('email',	'HPAPI_PATTERN_DESC_EMAIL',	'',	'email',	'FILTER_VALIDATE_EMAIL',	3,	254,	'',	'',	'2018-09-27 22:05:54',	'2018-09-27 22:05:54'),
('hhmmss',	'HPAPI_PATTERN_DESC_HHMMSS',	'^[0-9]{6}$',	'text',	'',	0,	0,	'000000',	'235959',	'2018-09-27 22:05:54',	'2018-09-27 22:05:54'),
('int-11-positive',	'HPAPI_PATTERN_DESC_INT_11_POS',	'',	'text',	'FILTER_VALIDATE_INT',	1,	11,	'',	'',	'2018-09-28 19:30:38',	'2018-09-28 19:30:38'),
('ipv4',	'HPAPI_PATTERN_DESC_IPV4',	'((^|\\.)((25[0-5])|(2[0-4]\\d)|(1\\d\\d)|([1-9]?\\d))){4}$',	'text',	' ',	7,	15,	'',	'',	'2018-09-27 22:05:54',	'2018-09-27 22:05:54'),
('method',	'HPAPI_PATTERN_DESC_METHOD',	'^[a-z][A-Za-z0-9]*$',	'text',	'',	2,	64,	'',	'',	'2018-09-27 22:05:54',	'2018-09-27 22:05:54'),
('package',	'HPAPI_PATTERN_DESC_PACKAGE',	'^[a-z][a-z\\-]*[a-z]$',	'text',	'',	2,	64,	'',	'',	'2018-09-27 22:05:54',	'2018-09-27 22:05:54'),
('password-1',	'HPAPI_PATTERN_DESC_PASSWORD_1',	'^(?=.*\\d)(?=.*[a-z])(?=.*[A-Z])(?!.*\\s).*$',	'password',	'',	8,	255,	'',	'',	'2018-09-27 22:05:54',	'2018-09-27 22:05:54'),
('path-hpapi',	'HPAPI_PATTERN_DESC_MEDIA_URI',	'/[a-z0-9\\-_/]+\\.[a-z]+',	'text',	'',	4,	255,	'',	'',	'2018-09-27 22:05:54',	'2018-09-27 22:05:54'),
('uuid-hpapi',	'HPAPI_PATTERN_DESC_UUID_HPAPI',	'^[0-9]{14}::[a-f0-9]{8}-[a-f0-9]{4}-[a-f0-9]{4}-[a-f0-9]{4}-[a-f0-9]{12}$',	'text',	'',	52,	52,	'',	'',	'2018-09-27 22:05:54',	'2018-09-27 22:05:54'),
('uuid-v4',	'HPAPI_PATTERN_DESC_UUIDV4',	'^[a-f0-9]{8}-[a-f0-9]{4}-[a-f0-9]{4}-[a-f0-9]{4}-[a-f0-9]{12}$',	'text',	'',	36,	36,	'',	'',	'2018-09-27 22:05:54',	'2018-09-27 22:05:54'),
('varchar-255',	'HPAPI_PATTERN_DESC_VARCHAR_255',	'',	'text',	'',	1,	255,	'',	'',	'2018-09-27 22:05:54',	'2018-09-27 22:05:54'),
('varchar-64',	'HPAPI_PATTERN_DESC_VARCHAR_64',	'',	'text',	'',	1,	64,	'',	'',	'2018-09-27 22:05:54',	'2018-09-27 22:05:54'),
('vendor',	'HPAPI_PATTERN_DESC_VENDOR',	'^[a-z][a-z\\-]*[a-z]$',	'text',	'',	2,	64,	'',	'',	'2018-09-27 22:05:54',	'2018-09-27 22:05:54'),
('yyyy-mm-dd',	'HPAPI_PATTERN_DESC_YYYY_MM_DD',	'^[0-9]{4}-[0-9]{2}-[0-9]{2}$',	'date',	'',	10,	10,	'2000-01-01',	'2100-12-31',	'2018-09-27 22:05:54',	'2018-09-27 22:05:54'),
('yyyymmdd',	'HPAPI_PATTERN_DESC_YYYYMMDD',	'^[0-9]{8}$',	'text',	'',	0,	0,	'20000101',	'99991231',	'2018-09-27 22:05:54',	'2018-09-27 22:05:54');

INSERT IGNORE INTO `hpapi_usergroup` (`usergroup`, `level`, `name`, `remote_addr_pattern`, `notes`) VALUES
('admin',	2,	'Administrators',	'^.*$',	'Users performing high level administration of business data within the model.'),
('agent',	10000,	'Client Agents',	'^.*$',	'Custom user group for users acting on behalf of a company client. They may or may not be operating via a third party agency organsiation (eg. a lottery provider).'),
('anon',	10000000,	'Unknown Users',	'^.*$',	'Users having no identity.'),
('canvasser',	1000,	'Field staff',	'^.*$',	'Staff at off-site locations using doorstepper.js'),
('field',	1000,	'Field staff',	'^.*$',	'Staff at off-site locations'),
('linemanager',	1000,	'Line managers',	'^.*$',	'Line managers at off-site locations using doorstepper.js'),
('manager',	10,	'Managers',	'^.*$',	'Admin users with relatively high privileges'),
('staff',	100,	'Office staff',	'^.*$',	'Admin users with limited privileges'),
('sysadmin',	3,	'System Administrators',	'^.*$',	'Users performing high level administration of configuration data within the model.');

