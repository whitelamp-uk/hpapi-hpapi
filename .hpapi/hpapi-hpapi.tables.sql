-- Adminer 4.6.2 MySQL dump

SET NAMES utf8;
SET time_zone = '+00:00';
SET foreign_key_checks = 0;

CREATE TABLE IF NOT EXISTS `hpapi_call` (
  `call_Model` varchar(64) CHARACTER SET ascii NOT NULL,
  `call_Spr` varchar(64) CHARACTER SET ascii NOT NULL,
  `call_Vendor` varchar(64) CHARACTER SET ascii NOT NULL,
  `call_Package` varchar(64) CHARACTER SET ascii NOT NULL,
  `call_Class` varchar(64) CHARACTER SET ascii NOT NULL,
  `call_Method` varchar(64) CHARACTER SET ascii NOT NULL,
  PRIMARY KEY (`call_Model`,`call_Spr`,`call_Vendor`,`call_Package`,`call_Class`,`call_Method`),
  KEY `call_Vendor` (`call_Vendor`,`call_Package`,`call_Class`,`call_Method`),
  CONSTRAINT `hpapi_call_ibfk_5` FOREIGN KEY (`call_Vendor`, `call_Package`, `call_Class`, `call_Method`) REFERENCES `hpapi_method` (`method_Vendor`, `method_Package`, `method_Class`, `method_Method`),
  CONSTRAINT `hpapi_call_ibfk_6` FOREIGN KEY (`call_Model`, `call_Spr`) REFERENCES `hpapi_spr` (`spr_Model`, `spr_Spr`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE IF NOT EXISTS `hpapi_database` (
  `database_Node` varchar(64) CHARACTER SET ascii NOT NULL DEFAULT '',
  `database_Model` varchar(64) CHARACTER SET ascii NOT NULL,
  `database_Notes` text NOT NULL,
  PRIMARY KEY (`database_Node`,`database_Model`),
  KEY `database_Model` (`database_Model`),
  CONSTRAINT `hpapi_database_ibfk_1` FOREIGN KEY (`database_Node`) REFERENCES `hpapi_node` (`node_Node`),
  CONSTRAINT `hpapi_database_ibfk_2` FOREIGN KEY (`database_Model`) REFERENCES `hpapi_model` (`model_Model`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


CREATE TABLE IF NOT EXISTS `hpapi_email` (
  `email_Verified` int(1) unsigned NOT NULL DEFAULT '0',
  `email_Email` varchar(255) NOT NULL,
  `email_User_UUID` varchar(52) NOT NULL,
  PRIMARY KEY (`email_Email`),
  KEY `email_User_UUID` (`email_User_UUID`),
  CONSTRAINT `hpapi_email_ibfk_1` FOREIGN KEY (`email_User_UUID`) REFERENCES `hpapi_user` (`user_UUID`)
) ENGINE=InnoDB DEFAULT CHARSET=ascii;


CREATE TABLE IF NOT EXISTS `hpapi_export` (
  `export_Node` varchar(64) CHARACTER SET ascii NOT NULL,
  `export_Model` varchar(64) CHARACTER SET ascii NOT NULL,
  `export_Transport` varchar(64) CHARACTER SET ascii NOT NULL,
  `export_Export_Datetime` varchar(32) CHARACTER SET ascii NOT NULL,
  `export_Expiry_Datetime` varchar(32) CHARACTER SET ascii NOT NULL,
  `export_SQL` text NOT NULL,
  PRIMARY KEY (`export_Model`,`export_Transport`,`export_Export_Datetime`),
  KEY `export_Transport` (`export_Transport`),
  KEY `export_Node` (`export_Node`,`export_Model`),
  CONSTRAINT `hpapi_export_ibfk_2` FOREIGN KEY (`export_Transport`) REFERENCES `hpapi_transport` (`transport_Transport`),
  CONSTRAINT `hpapi_export_ibfk_3` FOREIGN KEY (`export_Node`, `export_Model`) REFERENCES `hpapi_database` (`database_Node`, `database_Model`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


CREATE TABLE IF NOT EXISTS `hpapi_import` (
  `import_Node` varchar(64) CHARACTER SET ascii NOT NULL,
  `import_Model` varchar(64) CHARACTER SET ascii NOT NULL,
  `import_Transport` varchar(64) CHARACTER SET ascii NOT NULL,
  `import_Cron_Time` varchar(32) CHARACTER SET ascii NOT NULL,
  PRIMARY KEY (`import_Node`,`import_Model`,`import_Transport`),
  KEY `import_Transport` (`import_Transport`),
  CONSTRAINT `hpapi_import_ibfk_2` FOREIGN KEY (`import_Transport`) REFERENCES `hpapi_transport` (`transport_Transport`),
  CONSTRAINT `hpapi_import_ibfk_3` FOREIGN KEY (`import_Node`, `import_Model`) REFERENCES `hpapi_database` (`database_Node`, `database_Model`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


CREATE TABLE IF NOT EXISTS `hpapi_imported` (
  `imported_Node` varchar(64) CHARACTER SET ascii NOT NULL,
  `imported_Model` varchar(64) CHARACTER SET ascii NOT NULL,
  `imported_Transport` varchar(64) CHARACTER SET ascii NOT NULL,
  `imported_Export_Node` varchar(64) CHARACTER SET ascii NOT NULL,
  `imported_Export_Model` varchar(64) CHARACTER SET ascii NOT NULL,
  `imported_Export_Datetime` varchar(32) CHARACTER SET ascii NOT NULL,
  `imported_Import_Datetime` varchar(32) CHARACTER SET ascii NOT NULL,
  PRIMARY KEY (`imported_Node`,`imported_Model`,`imported_Transport`,`imported_Export_Datetime`),
  KEY `imported_Export_Model` (`imported_Export_Model`),
  KEY `imported_Export_Node` (`imported_Export_Node`,`imported_Export_Model`,`imported_Transport`,`imported_Export_Datetime`),
  CONSTRAINT `hpapi_imported_ibfk_3` FOREIGN KEY (`imported_Node`, `imported_Model`) REFERENCES `hpapi_database` (`database_Node`, `database_Model`),
  CONSTRAINT `hpapi_imported_ibfk_5` FOREIGN KEY (`imported_Export_Node`, `imported_Export_Model`, `imported_Transport`, `imported_Export_Datetime`) REFERENCES `hpapi_export` (`export_Node`, `export_Model`, `export_Transport`, `export_Export_Datetime`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


CREATE TABLE IF NOT EXISTS `hpapi_insert` (
  `insert_Model` varchar(64) CHARACTER SET ascii NOT NULL,
  `insert_Table` varchar(64) CHARACTER SET ascii NOT NULL,
  `insert_Usergroup` varchar(64) CHARACTER SET ascii NOT NULL,
  PRIMARY KEY (`insert_Model`,`insert_Table`,`insert_Usergroup`),
  KEY `insert_Usergroup` (`insert_Usergroup`),
  CONSTRAINT `hpapi_insert_ibfk_1` FOREIGN KEY (`insert_Model`, `insert_Table`) REFERENCES `hpapi_table` (`table_Model`, `table_Table`),
  CONSTRAINT `hpapi_insert_ibfk_2` FOREIGN KEY (`insert_Usergroup`) REFERENCES `hpapi_usergroup` (`usergroup_Usergroup`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


CREATE TABLE IF NOT EXISTS `hpapi_key` (
  `key_Expired` int(1) unsigned NOT NULL DEFAULT '0',
  `key_Key` varchar(52) CHARACTER SET ascii NOT NULL,
  `key_Remote_Addr_Pattern` varchar(64) CHARACTER SET ascii NOT NULL,
  `key_User_UUID` varchar(52) CHARACTER SET ascii NOT NULL,
  `key_Vendor` varchar(64) CHARACTER SET ascii NOT NULL,
  `key_Package` varchar(64) CHARACTER SET ascii NOT NULL,
  PRIMARY KEY (`key_User_UUID`,`key_Vendor`,`key_Package`,`key_Key`),
  UNIQUE KEY `key_Key` (`key_Key`),
  KEY `key_Vendor` (`key_Vendor`,`key_Package`),
  CONSTRAINT `hpapi_key_ibfk_2` FOREIGN KEY (`key_User_UUID`) REFERENCES `hpapi_user` (`user_UUID`),
  CONSTRAINT `hpapi_key_ibfk_3` FOREIGN KEY (`key_Vendor`, `key_Package`) REFERENCES `hpapi_package` (`package_Vendor`, `package_Package`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


CREATE TABLE IF NOT EXISTS `hpapi_level` (
  `level_Level` int(11) unsigned NOT NULL,
  `level_Name` varchar(64) NOT NULL,
  `level_Notes` text NOT NULL,
  PRIMARY KEY (`level_Level`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


CREATE TABLE IF NOT EXISTS `hpapi_membership` (
  `membership_User_UUID` varchar(64) CHARACTER SET ascii NOT NULL DEFAULT '',
  `membership_Usergroup` varchar(64) CHARACTER SET ascii NOT NULL DEFAULT '0',
  PRIMARY KEY (`membership_User_UUID`,`membership_Usergroup`),
  KEY `membership_Usergroup` (`membership_Usergroup`),
  CONSTRAINT `hpapi_membership_ibfk_1` FOREIGN KEY (`membership_User_UUID`) REFERENCES `hpapi_user` (`user_UUID`),
  CONSTRAINT `hpapi_membership_ibfk_2` FOREIGN KEY (`membership_Usergroup`) REFERENCES `hpapi_usergroup` (`usergroup_Usergroup`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


CREATE TABLE IF NOT EXISTS `hpapi_method` (
  `method_Vendor` varchar(64) CHARACTER SET ascii NOT NULL,
  `method_Package` varchar(64) CHARACTER SET ascii NOT NULL,
  `method_Class` varchar(64) CHARACTER SET ascii NOT NULL,
  `method_Method` varchar(64) CHARACTER SET ascii NOT NULL,
  `method_Label` varchar(64) NOT NULL,
  `method_Notes` text NOT NULL,
  PRIMARY KEY (`method_Vendor`,`method_Package`,`method_Class`,`method_Method`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


CREATE TABLE IF NOT EXISTS `hpapi_methodarg` (
  `methodarg_Vendor` varchar(64) CHARACTER SET ascii NOT NULL,
  `methodarg_Package` varchar(64) CHARACTER SET ascii NOT NULL,
  `methodarg_Class` varchar(64) CHARACTER SET ascii NOT NULL,
  `methodarg_Method` varchar(64) CHARACTER SET ascii NOT NULL,
  `methodarg_Argument` int(4) unsigned NOT NULL DEFAULT '1',
  `methodarg_Name` varchar(64) NOT NULL,
  `methodarg_Empty_Allowed` int(1) unsigned NOT NULL DEFAULT '0',
  `methodarg_Pattern` varchar(64) CHARACTER SET ascii NOT NULL,
  PRIMARY KEY (`methodarg_Vendor`,`methodarg_Package`,`methodarg_Class`,`methodarg_Method`,`methodarg_Argument`),
  KEY `methodarg_Pattern` (`methodarg_Pattern`),
  CONSTRAINT `hpapi_methodarg_ibfk_1` FOREIGN KEY (`methodarg_Pattern`) REFERENCES `hpapi_pattern` (`pattern_Pattern`),
  CONSTRAINT `hpapi_methodarg_ibfk_3` FOREIGN KEY (`methodarg_Vendor`, `methodarg_Package`, `methodarg_Class`, `methodarg_Method`) REFERENCES `hpapi_method` (`method_Vendor`, `method_Package`, `method_Class`, `method_Method`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


CREATE TABLE IF NOT EXISTS `hpapi_model` (
  `model_Model` varchar(64) CHARACTER SET ascii NOT NULL,
  `model_Notes` text NOT NULL,
  `model_DSN` varchar(255) NOT NULL,
  `model_Usr` varchar(255) NOT NULL,
  `model_Pwd` varchar(255) NOT NULL,
  PRIMARY KEY (`model_Model`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


CREATE TABLE IF NOT EXISTS `hpapi_node` (
  `node_Node` varchar(64) CHARACTER SET ascii NOT NULL,
  `node_Name` varchar(64) NOT NULL,
  PRIMARY KEY (`node_Node`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


CREATE TABLE IF NOT EXISTS `hpapi_package` (
  `package_Vendor` varchar(64) CHARACTER SET ascii NOT NULL,
  `package_Package` varchar(64) CHARACTER SET ascii NOT NULL,
  `package_Notes` text NOT NULL,
  PRIMARY KEY (`package_Vendor`,`package_Package`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


CREATE TABLE IF NOT EXISTS `hpapi_pattern` (
  `pattern_Pattern` varchar(64) CHARACTER SET ascii NOT NULL,
  `pattern_Constraints` varchar(255) NOT NULL,
  `pattern_Expression` varchar(255) NOT NULL,
  `pattern_Input` varchar(64) CHARACTER SET ascii NOT NULL DEFAULT 'text',
  `pattern_Php_Filter` varchar(64) CHARACTER SET ascii NOT NULL,
  `pattern_Length_Minimum` int(11) unsigned NOT NULL DEFAULT '0',
  `pattern_Length_Maximum` int(11) unsigned NOT NULL DEFAULT '0',
  `pattern_Value_Minimum` varchar(255) NOT NULL,
  `pattern_Value_Maximum` varchar(255) NOT NULL,
  PRIMARY KEY (`pattern_Pattern`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


CREATE TABLE IF NOT EXISTS `hpapi_run` (
  `run_Usergroup` varchar(64) CHARACTER SET ascii NOT NULL,
  `run_Vendor` varchar(64) CHARACTER SET ascii NOT NULL,
  `run_Package` varchar(64) CHARACTER SET ascii NOT NULL,
  `run_Class` varchar(64) CHARACTER SET ascii NOT NULL,
  `run_Method` varchar(64) CHARACTER SET ascii NOT NULL,
  PRIMARY KEY (`run_Vendor`,`run_Package`,`run_Class`,`run_Method`,`run_Usergroup`),
  KEY `run_Usergroup` (`run_Usergroup`),
  CONSTRAINT `hpapi_run_ibfk_2` FOREIGN KEY (`run_Vendor`, `run_Package`, `run_Class`, `run_Method`) REFERENCES `hpapi_method` (`method_Vendor`, `method_Package`, `method_Class`, `method_Method`),
  CONSTRAINT `hpapi_run_ibfk_3` FOREIGN KEY (`run_Usergroup`) REFERENCES `hpapi_usergroup` (`usergroup_Usergroup`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


CREATE TABLE IF NOT EXISTS `hpapi_spr` (
  `spr_Model` varchar(64) CHARACTER SET ascii NOT NULL,
  `spr_Spr` varchar(64) CHARACTER SET ascii NOT NULL,
  `spr_Notes` text NOT NULL,
  PRIMARY KEY (`spr_Model`,`spr_Spr`),
  CONSTRAINT `hpapi_spr_ibfk_1` FOREIGN KEY (`spr_Model`) REFERENCES `hpapi_model` (`model_Model`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


CREATE TABLE IF NOT EXISTS `hpapi_sprarg` (
  `sprarg_Model` varchar(64) CHARACTER SET ascii NOT NULL,
  `sprarg_Spr` varchar(64) CHARACTER SET ascii NOT NULL,
  `sprarg_Argument` int(1) unsigned NOT NULL DEFAULT '1',
  `sprarg_Name` varchar(64) NOT NULL,
  `sprarg_Empty_Allowed` int(1) unsigned NOT NULL DEFAULT '0',
  `sprarg_Pattern` varchar(255) CHARACTER SET ascii NOT NULL,
  PRIMARY KEY (`sprarg_Model`,`sprarg_Spr`,`sprarg_Argument`),
  KEY `sprarg_Pattern` (`sprarg_Pattern`),
  CONSTRAINT `hpapi_sprarg_ibfk_2` FOREIGN KEY (`sprarg_Pattern`) REFERENCES `hpapi_pattern` (`pattern_Pattern`),
  CONSTRAINT `hpapi_sprarg_ibfk_3` FOREIGN KEY (`sprarg_Model`, `sprarg_Spr`) REFERENCES `hpapi_spr` (`spr_Model`, `spr_Spr`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


CREATE TABLE IF NOT EXISTS `hpapi_sprevent` (
  `sprevent_Node` varchar(64) CHARACTER SET ascii NOT NULL,
  `sprevent_Model` varchar(64) CHARACTER SET ascii NOT NULL,
  `sprevent_Spr` varchar(64) CHARACTER SET ascii NOT NULL,
  `sprevent_Transport` varchar(64) CHARACTER SET ascii NOT NULL,
  PRIMARY KEY (`sprevent_Node`,`sprevent_Model`,`sprevent_Spr`,`sprevent_Transport`),
  KEY `sprevent_Model` (`sprevent_Model`,`sprevent_Spr`),
  KEY `sprevent_Transport` (`sprevent_Transport`),
  CONSTRAINT `hpapi_sprevent_ibfk_3` FOREIGN KEY (`sprevent_Transport`) REFERENCES `hpapi_transport` (`transport_Transport`),
  CONSTRAINT `hpapi_sprevent_ibfk_5` FOREIGN KEY (`sprevent_Node`, `sprevent_Model`) REFERENCES `hpapi_database` (`database_Node`, `database_Model`),
  CONSTRAINT `hpapi_sprevent_ibfk_6` FOREIGN KEY (`sprevent_Model`, `sprevent_Spr`) REFERENCES `hpapi_spr` (`spr_Model`, `spr_Spr`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


CREATE TABLE IF NOT EXISTS `hpapi_sql` (
  `sql_Process` varchar(64) CHARACTER SET ascii NOT NULL,
  `sql_Pdo_Driver` varchar(16) CHARACTER SET ascii NOT NULL,
  `sql_Query` varchar(255) NOT NULL,
  PRIMARY KEY (`sql_Process`,`sql_Pdo_Driver`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


CREATE TABLE IF NOT EXISTS `hpapi_table` (
  `table_Model` varchar(64) CHARACTER SET ascii NOT NULL,
  `table_Table` varchar(64) CHARACTER SET ascii NOT NULL,
  `table_Title` varchar(64) NOT NULL,
  `table_Description` varchar(255) NOT NULL,
  PRIMARY KEY (`table_Model`,`table_Table`),
  CONSTRAINT `hpapi_table_ibfk_1` FOREIGN KEY (`table_Model`) REFERENCES `hpapi_model` (`model_Model`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='table_Ignore = do not include in the model';


CREATE TABLE IF NOT EXISTS `hpapi_tableevent` (
  `tableevent_Node` varchar(64) CHARACTER SET ascii NOT NULL,
  `tableevent_Model` varchar(64) CHARACTER SET ascii NOT NULL,
  `tableevent_Table` varchar(64) CHARACTER SET ascii NOT NULL,
  `tableevent_Transport` varchar(64) CHARACTER SET ascii NOT NULL,
  `tableevent_Export_Inserts` int(1) unsigned NOT NULL,
  `tableevent_Export_Deletes` int(1) unsigned NOT NULL,
  PRIMARY KEY (`tableevent_Node`,`tableevent_Model`,`tableevent_Table`,`tableevent_Transport`),
  KEY `tableevent_Model` (`tableevent_Model`,`tableevent_Table`),
  KEY `tableevent_Transport` (`tableevent_Transport`),
  CONSTRAINT `hpapi_tableevent_ibfk_2` FOREIGN KEY (`tableevent_Model`, `tableevent_Table`) REFERENCES `hpapi_table` (`table_Model`, `table_Table`),
  CONSTRAINT `hpapi_tableevent_ibfk_3` FOREIGN KEY (`tableevent_Transport`) REFERENCES `hpapi_transport` (`transport_Transport`),
  CONSTRAINT `hpapi_tableevent_ibfk_4` FOREIGN KEY (`tableevent_Node`, `tableevent_Model`) REFERENCES `hpapi_database` (`database_Node`, `database_Model`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


CREATE TABLE IF NOT EXISTS `hpapi_transport` (
  `transport_Transport` varchar(64) CHARACTER SET ascii NOT NULL,
  `transport_Notes` text NOT NULL,
  `transport_Persistence_Days` int(4) unsigned NOT NULL,
  PRIMARY KEY (`transport_Transport`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='Grouping of SQL for export to (many) database instances';


CREATE TABLE IF NOT EXISTS `hpapi_trash` (
  `delete_Model` varchar(64) CHARACTER SET ascii NOT NULL,
  `delete_Table` varchar(64) CHARACTER SET ascii NOT NULL,
  `delete_Usergroup` varchar(64) CHARACTER SET ascii NOT NULL,
  PRIMARY KEY (`delete_Model`,`delete_Table`,`delete_Usergroup`),
  KEY `delete_Usergroup` (`delete_Usergroup`),
  CONSTRAINT `hpapi_trash_ibfk_1` FOREIGN KEY (`delete_Model`, `delete_Table`) REFERENCES `hpapi_table` (`table_Model`, `table_Table`),
  CONSTRAINT `hpapi_trash_ibfk_2` FOREIGN KEY (`delete_Usergroup`) REFERENCES `hpapi_usergroup` (`usergroup_Usergroup`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


CREATE TABLE IF NOT EXISTS `hpapi_update` (
  `update_Model` varchar(64) CHARACTER SET ascii NOT NULL,
  `update_Table` varchar(64) CHARACTER SET ascii NOT NULL,
  `update_Column` varchar(64) CHARACTER SET ascii NOT NULL,
  `update_Usergroup` varchar(64) CHARACTER SET ascii NOT NULL,
  PRIMARY KEY (`update_Model`,`update_Table`,`update_Column`,`update_Usergroup`),
  KEY `update_Usergroup` (`update_Usergroup`),
  CONSTRAINT `hpapi_update_ibfk_2` FOREIGN KEY (`update_Model`, `update_Table`, `update_Column`) REFERENCES `hpapi_column` (`column_Model`, `column_Table`, `column_Column`),
  CONSTRAINT `hpapi_update_ibfk_3` FOREIGN KEY (`update_Usergroup`) REFERENCES `hpapi_usergroup` (`usergroup_Usergroup`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


CREATE TABLE IF NOT EXISTS `hpapi_user` (
  `user_Active` int(1) unsigned NOT NULL DEFAULT '1',
  `user_UUID` varchar(64) CHARACTER SET ascii NOT NULL,
  `user_Notes` text NOT NULL,
  `user_Name` varchar(64) NOT NULL,
  `user_Password_Hash` varchar(255) CHARACTER SET ascii NOT NULL DEFAULT '',
  PRIMARY KEY (`user_UUID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


CREATE TABLE IF NOT EXISTS `hpapi_usergroup` (
  `usergroup_Usergroup` varchar(64) CHARACTER SET ascii NOT NULL,
  `usergroup_Level` int(4) unsigned NOT NULL,
  `usergroup_Name` varchar(64) NOT NULL,
  `usergroup_Notes` text NOT NULL,
  PRIMARY KEY (`usergroup_Usergroup`),
  KEY `usergroup_Level` (`usergroup_Level`),
  CONSTRAINT `hpapi_usergroup_ibfk_1` FOREIGN KEY (`usergroup_Level`) REFERENCES `hpapi_level` (`level_Level`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


-- 2018-08-05 22:47:53
