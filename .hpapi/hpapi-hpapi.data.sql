-- Adminer 4.6.2 MySQL dump

SET NAMES utf8;
SET time_zone = '+00:00';
SET foreign_key_checks = 0;
SET sql_mode = 'NO_AUTO_VALUE_ON_ZERO';

INSERT INTO `hpapi_accessdb` (`accessdb_Model`, `accessdb_Database`, `accessdb_Usergroup`, `accessdb_Usr`, `accessdb_Pwd`) VALUES
('mymodel',	'BABNET',	'canvasser',	'doorstepper',	'abcde');

INSERT INTO `hpapi_accessmtd` (`accessmtd_Vendor`, `accessmtd_Package`, `accessmtd_Class`, `accessmtd_Method`, `accessmtd_Usergroup`) VALUES
('burden-and-burden',	'doorstepper',	'\\Bab\\Doorstepper',	'assignmentsPostcode',	'anon');

INSERT INTO `hpapi_call` (`call_Model`, `call_Spr`, `call_Usergroup`) VALUES
('mymodel',	'babAssignmentsPostcode',	'canvasser');

INSERT INTO `hpapi_callevent` (`callevent_Model`, `callevent_Database`, `callevent_Spr`, `callevent_Transport`) VALUES
('mymodel',	'SCT2',	'babAssignmentsPostcode',	'transport1');

INSERT INTO `hpapi_column` (`column_Model`, `column_Table`, `column_Column`, `column_Ignore`, `column_Heading`, `column_Hint`, `column_Is_UUID`, `column_Means_Is_Readable`, `column_Means_Is_Trashed`, `column_Means_Edit_Datetime`, `column_Means_Editor`) VALUES
('mymodel',	'mytable',	'mycolumn1',	0,	'C1',	'My column 1',	0,	0,	0,	0,	0);

INSERT INTO `hpapi_columnevent` (`columnevent_Model`, `columnevent_Database`, `columnevent_Table`, `columnevent_Column`, `columnevent_Transport`, `columnevent_Export_On_Insert`, `columnevent_Export_On_Update`) VALUES
('mymodel',	'bab-inside',	'mytable',	'mycolumn1',	'transport1',	0,	0);

INSERT INTO `hpapi_database` (`database_Model`, `database_Database`, `database_DSN`, `database_Dir_Export`, `database_Dir_Import`, `database_Notes`) VALUES
('mymodel',	'bab-inside',	'mysql:host=babnet;dbname=bab_model;port=3306;charset=utf8',	'',	'',	'Intranet business model database'),
('mymodel',	'bab-outside-001',	'mysql:host=live001.burdenandburden.co.uk;dbname=bab_model;port=3306;charset=utf8',	'',	'',	'Internet-located business model database'),
('mymodel',	'BABNET',	'mysql:host=babnet;dbname=bab_model;port=3306;charset=utf8',	'',	'',	'Intranet business model database'),
('mymodel',	'SCT2',	'mysql:host=live001.burdenandburden.co.uk;dbname=bab_model;port=3306;charset=utf8',	'',	'',	'Internet-located business model database');


INSERT INTO `hpapi_export` (`export_Model`, `export_Database`, `export_Transport`, `export_Export_Datetime`, `export_Expiry_Datetime`, `export_SQL`) VALUES
('mymodel',	'bab-outside-001',	'transport1',	'2018-07-07T16:25:54+00:00',	'2018-07-08T16:25:54+00:00',	'myStoredProcedure(\'68cad87d-8202-11e8-a9fa-001f16148bc1\',\'foo\',\'Bar\');\r\n'),
('mymodel',	'bab-outside-001',	'transportother',	'2018-07-01T16:14:03+00:00',	'2018-07-06T16:14:03+00:00',	'CALL somethingOrOther(\'123\');\r\n');

INSERT INTO `hpapi_import` (`import_Model`, `import_Database`, `import_Transport`, `import_Cron_Time`) VALUES
('mymodel',	'bab-inside',	'transportother',	'05 06 * * * *');

INSERT INTO `hpapi_imported` (`imported_Model`, `imported_Database`, `imported_Transport`, `imported_Export_Model`, `imported_Export_Database`, `imported_Export_Datetime`, `imported_Import_Datetime`) VALUES
('mymodel',	'bab-inside',	'transportother',	'mymodel',	'bab-outside-001',	'2018-07-01T16:14:03+00:00',	'');


INSERT INTO `hpapi_membership` (`membership_User_UUID`, `membership_Usergroup`) VALUES
('fa58e4c3-c3f1-11e7-beba-d8d3859a9e13',	'anon'),
('fa5b07a2-c3f1-11e7-beba-d8d3859a9e13',	'public'),
('fa5b03f7-c3f1-11e7-beba-d8d3859a9e13',	'sysadmin');

INSERT INTO `hpapi_method` (`method_Vendor`, `method_Package`, `method_Class`, `method_Method`, `method_Notes`) VALUES
('burden-and-burden',	'doorstepper',	'\\Bab\\Doorstepper',	'assignmentsPostcode',	'List of doorstep post codes to work.');

INSERT INTO `hpapi_methodarg` (`methodarg_Vendor`, `methodarg_Package`, `methodarg_Class`, `methodarg_Method`, `methodarg_Argument`, `methodarg_Empty_Allowed`, `methodarg_Pattern`, `methodarg_Notes`) VALUES
('burden-and-burden',	'doorstepper',	'\\Bab\\Doorstepper',	'assignmentsPostcode',	1,	0,	'email',	'Currrent user\'s email');

INSERT INTO `hpapi_model` (`model_Model`, `model_Notes`, `model_DSN`, `model_Usr`, `model_Pwd`) VALUES
('model2',	'Different model',	'mysql:host=babnet;dbname=other_model_demol;port=3306;charset=utf8',	'blueprintuser',	''),
('mymodel',	'First model',	'mymodelblueprint000',	'blueprintuser',	'');

INSERT INTO `hpapi_pattern` (`pattern_Pattern`, `pattern_Description`, `pattern_Expression`, `pattern_Input`, `pattern_Php_Filter`, `pattern_Length_Minimum`, `pattern_Length_Maximum`, `pattern_Value_Minimum`, `pattern_Value_Maximum`) VALUES
('email',	'HPAPI_PATTERN_DESC_EMAIL',	'',	'email',	'FILTER_VALIDATE_EMAIL',	3,	254,	'',	''),
('uuidv4',	'HPAPI_PATTERN_DESC_UUIDV4',	'^[a-f0-9]{8}-[a-f0-9]{4}-[a-f0-9]{4}-[a-f0-9]{4}-[a-f0-9]{12}$',	'text',	'',	0,	0,	'',	'');


INSERT INTO `hpapi_spr` (`spr_Model`, `spr_Spr`, `spr_Notes`) VALUES
('mymodel',	'babAssignmentsPostcode',	''),
('mymodel',	'babAssignmentsVenue',	''),
('mymodel',	'myStoredProcedure',	'');

INSERT INTO `hpapi_sprarg` (`sprarg_Model`, `sprarg_Spr`, `sprarg_Argument`, `sprarg_Notes`, `sprarg_Pattern`) VALUES
('mymodel',	'babAssignmentsPostcode',	1,	'',	''),
('mymodel',	'babAssignmentsVenue',	1,	'',	'');

INSERT INTO `hpapi_sprevent` (`sprevent_Model`, `sprevent_Database`, `sprevent_Spr`, `sprevent_Transport`) VALUES
('mymodel',	'bab-outside-001',	'myStoredProcedure',	'transport1');

INSERT INTO `hpapi_table` (`table_Model`, `table_Table`, `table_Ignore`, `table_Title`, `table_Description`) VALUES
('mymodel',	'mytable',	0,	'My Table',	'Example table');

INSERT INTO `hpapi_tableevent` (`tableevent_Model`, `tableevent_Database`, `tableevent_Table`, `tableevent_Transport`, `tableevent_Export_Inserts`, `tableevent_Export_Deletes`) VALUES
('mymodel',	'bab-outside-001',	'mytable',	'transport1',	1,	0);

INSERT INTO `hpapi_transport` (`transport_Transport`, `transport_Notes`, `transport_Persistence_Days`) VALUES
('transport1',	'First example of a transport (collection of exported SQL)',	1),
('transportother',	'Second transport with as longer storage persistence.',	5);

INSERT INTO `hpapi_user` (`user_Active`, `user_UUID`, `user_Name`, `user_Notes`, `user_Email`, `user_Password_Hash`) VALUES
(1,	'fa58e4c3-c3f1-11e7-beba-d8d3859a9e13',	'Anonymous',	'',	'',	''),
(1,	'fa5b03f7-c3f1-11e7-beba-d8d3859a9e13',	'Sysadmin 1',	'',	'mark.page@whitelamp.com',	'$2y$10$hLSdApW6.30YLK3ze49uSu7OV0gmS3ZT65pufxDPGiMxsmW3bykeq'),
(1,	'fa5b07a2-c3f1-11e7-beba-d8d3859a9e13',	'Test User 1',	'',	'test.1@no.where',	'$2y$10$hLSdApW6.30YLK3ze49uSu7OV0gmS3ZT65pufxDPGiMxsmW3bykeq');

INSERT INTO `hpapi_usergroup` (`usergroup_Usergroup`, `usergroup_Name`, `usergroup_Notes`) VALUES
('admin',	'Administrators',	''),
('anon',	'Unknown Users',	''),
('canvasser',	'Canvassers',	'Canvassers are staff that are authorised to collect sign-ups (managers are also canvassers by specification).'),
('public',	'Public Users',	''),
('sysadmin',	'System Administrators',	'');

-- 2018-07-23 22:20:43
