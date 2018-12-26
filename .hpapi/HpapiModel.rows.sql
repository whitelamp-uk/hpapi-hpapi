
-- Copyright 2018 Whitelamp http://www.whitelamp.com/

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

INSERT IGNORE INTO `hpapi_package` (`vendor`, `package`, `requires_key`, `notes`) VALUES
('whitelamp-uk',	'hpapi-utility',	0,	'Hpapi utility class(es).');

INSERT IGNORE INTO `hpapi_pattern` (`pattern`, `constraints`, `expression`, `input`, `php_filter`, `length_minimum`, `length_maximum`, `value_minimum`, `value_maximum`) VALUES
('alpha-lc-64',	'HPAPI_PATTERN_DESC_ALPHA_LC',	'^[a-z]*$',	'text',	'',	1,	64,	'',	''),
('class',	'HPAPI_PATTERN_DESC_CLASS',	'^\\\\[A-Z][A-z]*\\\\[A-Z][A-z]*$',	'text',	'',	4,	64,	'',	''),
('datetime',	'HPAPI_PATTERN_DESC_DATETIME',	'^[0-9]{4}-[0-9]{2}-[0-9]{2}(\\s|T)[0-9]{2}:[0-9]{2}:[0-9]{2}$',	'datetime-local',	'',	0,	0,	'',	''),
('db-boolean',	'HPAPI_PATTERN_DESC_DB_BOOL',	'',	'checkbox',	'FILTER_VALIDATE_INT',	0,	0,	'0',	'1'),
('email',	'HPAPI_PATTERN_DESC_EMAIL',	'',	'email',	'FILTER_VALIDATE_EMAIL',	3,	254,	'',	''),
('geo-coordinate',	'HPAPI_PATTERN_GEO_COORD',	'^-?[0-9]+(\\.[0-9])?$',	'text',	'',	0,	0,	'-360',	'360'),
('hhmmss',	'HPAPI_PATTERN_DESC_HHMMSS',	'^[0-9]{6}$',	'text',	'',	0,	0,	'000000',	'235959'),
('int-11-pos-neg',	'HPAPI_PATTERN_DESC_INT_11_POS_NEG',	'',	'text',	'FILTER_VALIDATE_INT',	1,	11,	'',	''),
('int-11-positive',	'HPAPI_PATTERN_DESC_INT_11_POS',	'',	'text',	'FILTER_VALIDATE_INT',	1,	11,	'0',	''),
('int-2-positive',	'HPAPI_PATTERN_DESC_INT_2_POS',	'',	'text',	'FILTER_VALIDATE_INT',	1,	2,	'0',	''),
('int-4-positive',	'HPAPI_PATTERN_DESC_INT_4_POS',	'',	'text',	'FILTER_VALIDATE_INT',	1,	4,	'0',	''),
('ipv4',	'HPAPI_PATTERN_DESC_IPV4',	'((^|\\.)((25[0-5])|(2[0-4]\\d)|(1\\d\\d)|([1-9]?\\d))){4}$',	'text',	' ',	7,	15,	'',	''),
('method',	'HPAPI_PATTERN_DESC_METHOD',	'^[a-z][A-Za-z0-9]*$',	'text',	'',	2,	64,	'',	''),
('object',	'HPAPI_PATTERN_DESC_OBJECT',	'',	'textarea',	'',	0,	0,	'',	''),
('package',	'HPAPI_PATTERN_DESC_PACKAGE',	'^[a-z][a-z\\-]*[a-z]$',	'text',	'',	2,	64,	'',	''),
('password-1',	'HPAPI_PATTERN_DESC_PASSWORD_1',	'^(?=.*\\d)(?=.*[a-z])(?=.*[A-Z])(?!.*\\s).*$',	'password',	'',	8,	255,	'',	''),
('path-hpapi',	'HPAPI_PATTERN_DESC_URI_PATH',	'/[a-z0-9\\-_/]+\\.[a-z]+',	'text',	'',	4,	255,	'',	''),
('uuid-v4',	'HPAPI_PATTERN_DESC_UUIDV4',	'^[a-f0-9]{8}-[a-f0-9]{4}-[a-f0-9]{4}-[a-f0-9]{4}-[a-f0-9]{12}$',	'text',	'',	36,	36,	'',	''),
('varchar-140',	'HPAPI_PATTERN_DESC_VARCHAR_140',	'',	'text',	'',	1,	140,	'',	''),
('varchar-16',	'HPAPI_PATTERN_DESC_VARCHAR_16',	'',	'text',	'',	1,	16,	'',	''),
('varchar-2',	'HPAPI_PATTERN_DESC_VARCHAR_2',	'',	'text',	'',	1,	2,	'',	''),
('varchar-255',	'HPAPI_PATTERN_DESC_VARCHAR_255',	'',	'text',	'',	1,	255,	'',	''),
('varchar-32',	'HPAPI_PATTERN_DESC_VARCHAR_32',	'',	'text',	'',	1,	32,	'',	''),
('varchar-4',	'HPAPI_PATTERN_DESC_VARCHAR_4',	'',	'text',	'',	1,	4,	'',	''),
('varchar-4096',	'HPAPI_PATTERN_DESC_VARCHAR_4096',	'',	'textarea',	'',	1,	4096,	'',	''),
('varchar-6',	'HPAPI_PATTERN_DESC_VARCHAR_6',	'',	'text',	'',	1,	6,	'',	''),
('varchar-64',	'HPAPI_PATTERN_DESC_VARCHAR_64',	'',	'text',	'',	1,	64,	'',	''),
('vendor',	'HPAPI_PATTERN_DESC_VENDOR',	'^[a-z][a-z\\-]*[a-z]$',	'text',	'',	2,	64,	'',	''),
('yyyy-mm-dd',	'HPAPI_PATTERN_DESC_YYYY_MM_DD',	'^[0-9]{4}-[0-9]{2}-[0-9]{2}$',	'date',	'',	10,	10,	'2000-01-01',	'2100-12-31'),
('yyyymmdd',	'HPAPI_PATTERN_DESC_YYYYMMDD',	'^[0-9]{8}$',	'text',	'',	0,	0,	'20000101',	'99991231');


INSERT IGNORE INTO `hpapi_usergroup` (`usergroup`, `level`, `name`, `remote_addr_pattern`, `notes`) VALUES
('system',	1,	'System',	'^::1$',	'Automated system routines.'),
('admin',	2,	'Administrators',	'^.*$',	'Users performing high level administration of business data within the model.'),
('agent',	10000,	'Client Agents',	'^.*$',	'Custom user group for users acting on behalf of a company client. They may or may not be operating via a third party agency organsiation (eg. a lottery provider).'),
('anon',	10000000,	'Unknown Users',	'^.*$',	'Users having no identity.'),
('field',	1000,	'Field staff',	'^.*$',	'Staff at off-site locations'),
('linemanager',	1000,	'Line managers',	'^.*$',	'Line managers at off-site locations using doorstepper.js'),
('manager',	10,	'Managers',	'^.*$',	'Admin users with relatively high privileges'),
('staff',	100,	'Office staff',	'^.*$',	'Admin users with limited privileges'),
('sysadmin',	3,	'System Administrators',	'^.*$',	'Users performing high level administration of configuration data within the model.');

