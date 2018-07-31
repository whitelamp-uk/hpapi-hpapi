-- Adminer 4.6.2 MySQL dump

SET NAMES utf8;
SET time_zone = '+00:00';

CREATE TABLE `hpapi_accessdb` (
  `accessdb_Model` varchar(64) CHARACTER SET ascii NOT NULL,
  `accessdb_Database` varchar(64) CHARACTER SET ascii NOT NULL,
  `accessdb_Usergroup` varchar(64) CHARACTER SET ascii NOT NULL,
  `accessdb_Usr` varchar(64) NOT NULL,
  `accessdb_Pwd` varchar(64) NOT NULL,
  PRIMARY KEY (`accessdb_Model`,`accessdb_Database`,`accessdb_Usergroup`),
  KEY `accessdb_Usergroup` (`accessdb_Usergroup`),
  CONSTRAINT `hpapi_accessdb_ibfk_1` FOREIGN KEY (`accessdb_Model`, `accessdb_Database`) REFERENCES `hpapi_database` (`database_Model`, `database_Database`),
  CONSTRAINT `hpapi_accessdb_ibfk_2` FOREIGN KEY (`accessdb_Usergroup`) REFERENCES `hpapi_usergroup` (`usergroup_Usergroup`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


CREATE TABLE `hpapi_accessmtd` (
  `accessmtd_Vendor` varchar(64) CHARACTER SET ascii NOT NULL,
  `accessmtd_Package` varchar(64) CHARACTER SET ascii NOT NULL,
  `accessmtd_Class` varchar(64) CHARACTER SET ascii NOT NULL,
  `accessmtd_Method` varchar(64) CHARACTER SET ascii NOT NULL,
  `accessmtd_Usergroup` varchar(64) CHARACTER SET ascii NOT NULL,
  PRIMARY KEY (`accessmtd_Vendor`,`accessmtd_Package`,`accessmtd_Class`,`accessmtd_Method`,`accessmtd_Usergroup`),
  KEY `accessmtd_Usergroup` (`accessmtd_Usergroup`),
  CONSTRAINT `hpapi_accessmtd_ibfk_5` FOREIGN KEY (`accessmtd_Vendor`, `accessmtd_Package`, `accessmtd_Class`, `accessmtd_Method`) REFERENCES `hpapi_method` (`method_Vendor`, `method_Package`, `method_Class`, `method_Method`),
  CONSTRAINT `hpapi_accessmtd_ibfk_4` FOREIGN KEY (`accessmtd_Usergroup`) REFERENCES `hpapi_usergroup` (`usergroup_Usergroup`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


CREATE TABLE `hpapi_call` (
  `call_Model` varchar(64) CHARACTER SET ascii NOT NULL,
  `call_Spr` varchar(64) CHARACTER SET ascii NOT NULL,
  `call_Usergroup` varchar(64) CHARACTER SET ascii NOT NULL,
  PRIMARY KEY (`call_Model`,`call_Spr`,`call_Usergroup`),
  KEY `call_Usergroup` (`call_Usergroup`),
  CONSTRAINT `hpapi_call_ibfk_3` FOREIGN KEY (`call_Model`, `call_Spr`) REFERENCES `hpapi_spr` (`spr_Model`, `spr_Spr`),
  CONSTRAINT `hpapi_call_ibfk_2` FOREIGN KEY (`call_Usergroup`) REFERENCES `hpapi_usergroup` (`usergroup_Usergroup`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


CREATE TABLE `hpapi_callevent` (
  `callevent_Model` varchar(64) CHARACTER SET ascii NOT NULL,
  `callevent_Database` varchar(64) CHARACTER SET ascii NOT NULL,
  `callevent_Spr` varchar(64) CHARACTER SET ascii NOT NULL,
  `callevent_Transport` varchar(64) CHARACTER SET ascii NOT NULL,
  PRIMARY KEY (`callevent_Model`,`callevent_Database`,`callevent_Spr`,`callevent_Transport`),
  KEY `callevent_Transport` (`callevent_Transport`),
  KEY `callevent_Model` (`callevent_Model`,`callevent_Spr`),
  CONSTRAINT `hpapi_callevent_ibfk_4` FOREIGN KEY (`callevent_Model`, `callevent_Spr`) REFERENCES `hpapi_spr` (`spr_Model`, `spr_Spr`),
  CONSTRAINT `hpapi_callevent_ibfk_1` FOREIGN KEY (`callevent_Model`, `callevent_Database`) REFERENCES `hpapi_database` (`database_Model`, `database_Database`),
  CONSTRAINT `hpapi_callevent_ibfk_3` FOREIGN KEY (`callevent_Transport`) REFERENCES `hpapi_transport` (`transport_Transport`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


CREATE TABLE `hpapi_column` (
  `column_Model` varchar(64) CHARACTER SET ascii NOT NULL,
  `column_Table` varchar(64) CHARACTER SET ascii NOT NULL,
  `column_Column` varchar(64) CHARACTER SET ascii NOT NULL,
  `column_Ignore` int(1) unsigned NOT NULL,
  `column_Heading` varchar(64) NOT NULL,
  `column_Hint` varchar(255) NOT NULL,
  `column_Is_UUID` int(1) unsigned NOT NULL,
  `column_Means_Is_Readable` int(1) unsigned NOT NULL,
  `column_Means_Is_Trashed` int(1) unsigned NOT NULL,
  `column_Means_Edit_Datetime` int(1) unsigned NOT NULL,
  `column_Means_Editor` int(1) unsigned NOT NULL,
  PRIMARY KEY (`column_Model`,`column_Table`,`column_Column`),
  CONSTRAINT `hpapi_column_ibfk_1` FOREIGN KEY (`column_Model`, `column_Table`) REFERENCES `hpapi_table` (`table_Model`, `table_Table`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='column_Ignore = do not include in the model';


CREATE TABLE `hpapi_columnevent` (
  `columnevent_Model` varchar(64) CHARACTER SET ascii NOT NULL,
  `columnevent_Database` varchar(64) CHARACTER SET ascii NOT NULL,
  `columnevent_Table` varchar(64) CHARACTER SET ascii NOT NULL,
  `columnevent_Column` varchar(64) CHARACTER SET ascii NOT NULL,
  `columnevent_Transport` varchar(64) CHARACTER SET ascii NOT NULL,
  `columnevent_Export_On_Insert` int(1) unsigned NOT NULL,
  `columnevent_Export_On_Update` int(1) unsigned NOT NULL,
  PRIMARY KEY (`columnevent_Model`,`columnevent_Database`,`columnevent_Table`,`columnevent_Column`,`columnevent_Transport`),
  KEY `columnevent_Model` (`columnevent_Model`,`columnevent_Table`,`columnevent_Column`),
  KEY `columnevent_Transport` (`columnevent_Transport`),
  CONSTRAINT `hpapi_columnevent_ibfk_4` FOREIGN KEY (`columnevent_Transport`) REFERENCES `hpapi_transport` (`transport_Transport`),
  CONSTRAINT `hpapi_columnevent_ibfk_1` FOREIGN KEY (`columnevent_Model`, `columnevent_Database`) REFERENCES `hpapi_database` (`database_Model`, `database_Database`),
  CONSTRAINT `hpapi_columnevent_ibfk_3` FOREIGN KEY (`columnevent_Model`, `columnevent_Table`, `columnevent_Column`) REFERENCES `hpapi_column` (`column_Model`, `column_Table`, `column_Column`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


CREATE TABLE `hpapi_database` (
  `database_Model` varchar(64) CHARACTER SET ascii NOT NULL,
  `database_Database` varchar(64) CHARACTER SET ascii NOT NULL,
  `database_DSN` varchar(255) CHARACTER SET ascii NOT NULL,
  `database_Dir_Export` varchar(255) CHARACTER SET ascii NOT NULL,
  `database_Dir_Import` varchar(255) CHARACTER SET ascii NOT NULL,
  `database_Notes` text NOT NULL,
  PRIMARY KEY (`database_Model`,`database_Database`),
  CONSTRAINT `hpapi_database_ibfk_1` FOREIGN KEY (`database_Model`) REFERENCES `hpapi_model` (`model_Model`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


CREATE TABLE `hpapi_delete` (
  `delete_Model` varchar(64) CHARACTER SET ascii NOT NULL,
  `delete_Table` varchar(64) CHARACTER SET ascii NOT NULL,
  `delete_Usergroup` varchar(64) CHARACTER SET ascii NOT NULL,
  PRIMARY KEY (`delete_Model`,`delete_Table`,`delete_Usergroup`),
  KEY `delete_Usergroup` (`delete_Usergroup`),
  CONSTRAINT `hpapi_delete_ibfk_2` FOREIGN KEY (`delete_Usergroup`) REFERENCES `hpapi_usergroup` (`usergroup_Usergroup`),
  CONSTRAINT `hpapi_delete_ibfk_1` FOREIGN KEY (`delete_Model`, `delete_Table`) REFERENCES `hpapi_table` (`table_Model`, `table_Table`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


CREATE TABLE `hpapi_export` (
  `export_Model` varchar(64) CHARACTER SET ascii NOT NULL,
  `export_Database` varchar(64) CHARACTER SET ascii NOT NULL,
  `export_Transport` varchar(64) CHARACTER SET ascii NOT NULL,
  `export_Export_Datetime` varchar(32) CHARACTER SET ascii NOT NULL,
  `export_Expiry_Datetime` varchar(32) CHARACTER SET ascii NOT NULL,
  `export_SQL` text NOT NULL,
  PRIMARY KEY (`export_Model`,`export_Database`,`export_Transport`,`export_Export_Datetime`),
  KEY `export_Transport` (`export_Transport`),
  CONSTRAINT `hpapi_export_ibfk_2` FOREIGN KEY (`export_Transport`) REFERENCES `hpapi_transport` (`transport_Transport`),
  CONSTRAINT `hpapi_export_ibfk_1` FOREIGN KEY (`export_Model`, `export_Database`) REFERENCES `hpapi_database` (`database_Model`, `database_Database`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


CREATE TABLE `hpapi_import` (
  `import_Model` varchar(64) CHARACTER SET ascii NOT NULL,
  `import_Database` varchar(64) CHARACTER SET ascii NOT NULL,
  `import_Transport` varchar(64) CHARACTER SET ascii NOT NULL,
  `import_Cron_Time` varchar(32) CHARACTER SET ascii NOT NULL,
  PRIMARY KEY (`import_Model`,`import_Database`,`import_Transport`),
  KEY `import_Transport` (`import_Transport`),
  CONSTRAINT `hpapi_import_ibfk_1` FOREIGN KEY (`import_Model`, `import_Database`) REFERENCES `hpapi_database` (`database_Model`, `database_Database`),
  CONSTRAINT `hpapi_import_ibfk_2` FOREIGN KEY (`import_Transport`) REFERENCES `hpapi_transport` (`transport_Transport`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


CREATE TABLE `hpapi_imported` (
  `imported_Model` varchar(64) CHARACTER SET ascii NOT NULL,
  `imported_Database` varchar(64) CHARACTER SET ascii NOT NULL,
  `imported_Transport` varchar(64) CHARACTER SET ascii NOT NULL,
  `imported_Export_Model` varchar(64) CHARACTER SET ascii NOT NULL,
  `imported_Export_Database` varchar(64) CHARACTER SET ascii NOT NULL,
  `imported_Export_Datetime` varchar(32) CHARACTER SET ascii NOT NULL,
  `imported_Import_Datetime` varchar(32) CHARACTER SET ascii NOT NULL,
  PRIMARY KEY (`imported_Model`,`imported_Database`,`imported_Transport`,`imported_Export_Datetime`),
  KEY `imported_Export_Model` (`imported_Export_Model`,`imported_Export_Database`,`imported_Transport`,`imported_Export_Datetime`),
  CONSTRAINT `hpapi_imported_ibfk_3` FOREIGN KEY (`imported_Export_Model`, `imported_Export_Database`, `imported_Transport`, `imported_Export_Datetime`) REFERENCES `hpapi_export` (`export_Model`, `export_Database`, `export_Transport`, `export_Export_Datetime`),
  CONSTRAINT `hpapi_imported_ibfk_1` FOREIGN KEY (`imported_Model`, `imported_Database`) REFERENCES `hpapi_database` (`database_Model`, `database_Database`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


CREATE TABLE `hpapi_insert` (
  `insert_Model` varchar(64) CHARACTER SET ascii NOT NULL,
  `insert_Table` varchar(64) CHARACTER SET ascii NOT NULL,
  `insert_Usergroup` varchar(64) CHARACTER SET ascii NOT NULL,
  PRIMARY KEY (`insert_Model`,`insert_Table`,`insert_Usergroup`),
  KEY `insert_Usergroup` (`insert_Usergroup`),
  CONSTRAINT `hpapi_insert_ibfk_2` FOREIGN KEY (`insert_Usergroup`) REFERENCES `hpapi_usergroup` (`usergroup_Usergroup`),
  CONSTRAINT `hpapi_insert_ibfk_1` FOREIGN KEY (`insert_Model`, `insert_Table`) REFERENCES `hpapi_table` (`table_Model`, `table_Table`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


CREATE TABLE `hpapi_membership` (
  `membership_User_UUID` varchar(64) CHARACTER SET ascii NOT NULL DEFAULT '',
  `membership_Usergroup` varchar(64) CHARACTER SET ascii NOT NULL DEFAULT '0',
  PRIMARY KEY (`membership_User_UUID`,`membership_Usergroup`),
  KEY `membership_Usergroup` (`membership_Usergroup`),
  CONSTRAINT `hpapi_membership_ibfk_2` FOREIGN KEY (`membership_Usergroup`) REFERENCES `hpapi_usergroup` (`usergroup_Usergroup`),
  CONSTRAINT `hpapi_membership_ibfk_1` FOREIGN KEY (`membership_User_UUID`) REFERENCES `hpapi_user` (`user_UUID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


CREATE TABLE `hpapi_method` (
  `method_Vendor` varchar(64) CHARACTER SET ascii NOT NULL,
  `method_Package` varchar(64) CHARACTER SET ascii NOT NULL,
  `method_Class` varchar(64) CHARACTER SET ascii NOT NULL,
  `method_Method` varchar(64) CHARACTER SET ascii NOT NULL,
  `method_Notes` text NOT NULL,
  PRIMARY KEY (`method_Vendor`,`method_Package`,`method_Class`,`method_Method`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


CREATE TABLE `hpapi_methodarg` (
  `methodarg_Vendor` varchar(64) CHARACTER SET ascii NOT NULL,
  `methodarg_Package` varchar(64) CHARACTER SET ascii NOT NULL,
  `methodarg_Class` varchar(64) CHARACTER SET ascii NOT NULL,
  `methodarg_Method` varchar(64) CHARACTER SET ascii NOT NULL,
  `methodarg_Argument` int(4) unsigned NOT NULL DEFAULT '1',
  `methodarg_Empty_Allowed` int(1) unsigned NOT NULL DEFAULT '0',
  `methodarg_Pattern` varchar(64) CHARACTER SET ascii NOT NULL,
  `methodarg_Notes` text NOT NULL,
  PRIMARY KEY (`methodarg_Vendor`,`methodarg_Package`,`methodarg_Class`,`methodarg_Method`,`methodarg_Argument`),
  KEY `methodarg_Pattern` (`methodarg_Pattern`),
  CONSTRAINT `hpapi_methodarg_ibfk_3` FOREIGN KEY (`methodarg_Vendor`, `methodarg_Package`, `methodarg_Class`, `methodarg_Method`) REFERENCES `hpapi_method` (`method_Vendor`, `method_Package`, `method_Class`, `method_Method`),
  CONSTRAINT `hpapi_methodarg_ibfk_1` FOREIGN KEY (`methodarg_Pattern`) REFERENCES `hpapi_pattern` (`pattern_Pattern`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


CREATE TABLE `hpapi_model` (
  `model_Model` varchar(64) CHARACTER SET ascii NOT NULL,
  `model_Notes` text NOT NULL,
  `model_DSN` varchar(255) NOT NULL,
  `model_Usr` varchar(255) NOT NULL,
  `model_Pwd` varchar(255) NOT NULL,
  PRIMARY KEY (`model_Model`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


CREATE TABLE `hpapi_pattern` (
  `pattern_Pattern` varchar(64) CHARACTER SET ascii NOT NULL,
  `pattern_Description` varchar(255) NOT NULL,
  `pattern_Expression` varchar(255) NOT NULL,
  `pattern_Input` varchar(64) CHARACTER SET ascii NOT NULL DEFAULT 'text',
  `pattern_Php_Filter` varchar(64) CHARACTER SET ascii NOT NULL,
  `pattern_Length_Minimum` int(11) unsigned NOT NULL DEFAULT '0',
  `pattern_Length_Maximum` int(11) unsigned NOT NULL DEFAULT '0',
  `pattern_Value_Minimum` varchar(255) NOT NULL,
  `pattern_Value_Maximum` varchar(255) NOT NULL,
  PRIMARY KEY (`pattern_Pattern`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


CREATE TABLE `hpapi_select` (
  `select_Model` varchar(64) CHARACTER SET ascii NOT NULL,
  `select_Table` varchar(64) CHARACTER SET ascii NOT NULL,
  `select_Column` varchar(64) CHARACTER SET ascii NOT NULL,
  `select_Usergroup` varchar(64) CHARACTER SET ascii NOT NULL,
  PRIMARY KEY (`select_Model`,`select_Table`,`select_Column`,`select_Usergroup`),
  KEY `select_Usergroup` (`select_Usergroup`),
  CONSTRAINT `hpapi_select_ibfk_2` FOREIGN KEY (`select_Usergroup`) REFERENCES `hpapi_usergroup` (`usergroup_Usergroup`),
  CONSTRAINT `hpapi_select_ibfk_1` FOREIGN KEY (`select_Model`, `select_Table`, `select_Column`) REFERENCES `hpapi_column` (`column_Model`, `column_Table`, `column_Column`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


CREATE TABLE `hpapi_spr` (
  `spr_Model` varchar(64) CHARACTER SET ascii NOT NULL,
  `spr_Spr` varchar(64) CHARACTER SET ascii NOT NULL,
  `spr_Notes` text NOT NULL,
  PRIMARY KEY (`spr_Model`,`spr_Spr`),
  CONSTRAINT `hpapi_spr_ibfk_1` FOREIGN KEY (`spr_Model`) REFERENCES `hpapi_model` (`model_Model`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


CREATE TABLE `hpapi_sprarg` (
  `sprarg_Model` varchar(64) CHARACTER SET ascii NOT NULL,
  `sprarg_Spr` varchar(64) CHARACTER SET ascii NOT NULL,
  `sprarg_Argument` int(1) unsigned NOT NULL DEFAULT '1',
  `sprarg_Notes` text NOT NULL,
  `sprarg_Pattern` varchar(255) CHARACTER SET ascii NOT NULL,
  PRIMARY KEY (`sprarg_Model`,`sprarg_Spr`,`sprarg_Argument`),
  CONSTRAINT `hpapi_sprarg_ibfk_1` FOREIGN KEY (`sprarg_Model`, `sprarg_Spr`) REFERENCES `hpapi_spr` (`spr_Model`, `spr_Spr`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


CREATE TABLE `hpapi_sprevent` (
  `sprevent_Model` varchar(64) CHARACTER SET ascii NOT NULL,
  `sprevent_Database` varchar(64) CHARACTER SET ascii NOT NULL,
  `sprevent_Spr` varchar(64) CHARACTER SET ascii NOT NULL,
  `sprevent_Transport` varchar(64) CHARACTER SET ascii NOT NULL,
  PRIMARY KEY (`sprevent_Model`,`sprevent_Database`,`sprevent_Spr`,`sprevent_Transport`),
  KEY `sprevent_Model` (`sprevent_Model`,`sprevent_Spr`),
  KEY `sprevent_Transport` (`sprevent_Transport`),
  CONSTRAINT `hpapi_sprevent_ibfk_3` FOREIGN KEY (`sprevent_Transport`) REFERENCES `hpapi_transport` (`transport_Transport`),
  CONSTRAINT `hpapi_sprevent_ibfk_1` FOREIGN KEY (`sprevent_Model`, `sprevent_Database`) REFERENCES `hpapi_database` (`database_Model`, `database_Database`),
  CONSTRAINT `hpapi_sprevent_ibfk_2` FOREIGN KEY (`sprevent_Model`, `sprevent_Spr`) REFERENCES `hpapi_spr` (`spr_Model`, `spr_Spr`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


CREATE TABLE `hpapi_table` (
  `table_Model` varchar(64) CHARACTER SET ascii NOT NULL,
  `table_Table` varchar(64) CHARACTER SET ascii NOT NULL,
  `table_Ignore` int(1) unsigned NOT NULL,
  `table_Title` varchar(64) NOT NULL,
  `table_Description` varchar(255) NOT NULL,
  PRIMARY KEY (`table_Model`,`table_Table`),
  CONSTRAINT `hpapi_table_ibfk_1` FOREIGN KEY (`table_Model`) REFERENCES `hpapi_model` (`model_Model`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='table_Ignore = do not include in the model';


CREATE TABLE `hpapi_tableevent` (
  `tableevent_Model` varchar(64) CHARACTER SET ascii NOT NULL,
  `tableevent_Database` varchar(64) CHARACTER SET ascii NOT NULL,
  `tableevent_Table` varchar(64) CHARACTER SET ascii NOT NULL,
  `tableevent_Transport` varchar(64) CHARACTER SET ascii NOT NULL,
  `tableevent_Export_Inserts` int(1) unsigned NOT NULL,
  `tableevent_Export_Deletes` int(1) unsigned NOT NULL,
  PRIMARY KEY (`tableevent_Model`,`tableevent_Database`,`tableevent_Table`,`tableevent_Transport`),
  KEY `tableevent_Model` (`tableevent_Model`,`tableevent_Table`),
  KEY `tableevent_Transport` (`tableevent_Transport`),
  CONSTRAINT `hpapi_tableevent_ibfk_3` FOREIGN KEY (`tableevent_Transport`) REFERENCES `hpapi_transport` (`transport_Transport`),
  CONSTRAINT `hpapi_tableevent_ibfk_1` FOREIGN KEY (`tableevent_Model`, `tableevent_Database`) REFERENCES `hpapi_database` (`database_Model`, `database_Database`),
  CONSTRAINT `hpapi_tableevent_ibfk_2` FOREIGN KEY (`tableevent_Model`, `tableevent_Table`) REFERENCES `hpapi_table` (`table_Model`, `table_Table`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


CREATE TABLE `hpapi_transport` (
  `transport_Transport` varchar(64) CHARACTER SET ascii NOT NULL,
  `transport_Notes` text NOT NULL,
  `transport_Persistence_Days` int(4) unsigned NOT NULL,
  PRIMARY KEY (`transport_Transport`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='Grouping of SQL for export to (many) database instances';


CREATE TABLE `hpapi_user` (
  `user_Active` int(1) unsigned NOT NULL,
  `user_UUID` varchar(64) CHARACTER SET ascii NOT NULL,
  `user_Name` varchar(64) NOT NULL,
  `user_Notes` text NOT NULL,
  `user_Email` varchar(255) CHARACTER SET ascii NOT NULL DEFAULT '',
  `user_Password_Hash` varchar(255) CHARACTER SET ascii NOT NULL DEFAULT '',
  PRIMARY KEY (`user_UUID`),
  UNIQUE KEY `user_Email` (`user_Email`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


CREATE TABLE `hpapi_usergroup` (
  `usergroup_Usergroup` varchar(64) CHARACTER SET ascii NOT NULL,
  `usergroup_Name` varchar(64) NOT NULL,
  `usergroup_Notes` text NOT NULL,
  PRIMARY KEY (`usergroup_Usergroup`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


