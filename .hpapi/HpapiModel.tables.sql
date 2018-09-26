
SET NAMES utf8;
SET time_zone = '+00:00';
SET foreign_key_checks = 0;


CREATE TABLE IF NOT EXISTS `hpapi_call` (
  `call_model` varchar(64) CHARACTER SET ascii NOT NULL,
  `call_spr` varchar(64) CHARACTER SET ascii NOT NULL,
  `call_vendor` varchar(64) CHARACTER SET ascii NOT NULL,
  `call_package` varchar(64) CHARACTER SET ascii NOT NULL,
  `call_class` varchar(64) CHARACTER SET ascii NOT NULL,
  `call_method` varchar(64) CHARACTER SET ascii NOT NULL,
  PRIMARY KEY (`call_model`,`call_spr`,`call_vendor`,`call_package`,`call_class`,`call_method`),
  KEY `call_vendor` (`call_vendor`,`call_package`,`call_class`,`call_method`),
  CONSTRAINT `hpapi_call_ibfk_5` FOREIGN KEY (`call_vendor`, `call_package`, `call_class`, `call_method`) REFERENCES `hpapi_method` (`method_vendor`, `method_package`, `method_class`, `method_method`),
  CONSTRAINT `hpapi_call_ibfk_6` FOREIGN KEY (`call_Model`, `call_Spr`) REFERENCES `hpapi_spr` (`spr_Model`, `spr_Spr`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


CREATE TABLE IF NOT EXISTS `hpapi_email` (
  `email_verified` int(1) unsigned NOT NULL DEFAULT '0',
  `email_email` varchar(255) NOT NULL,
  `email_user_UUID` varchar(52) NOT NULL,
  PRIMARY KEY (`email_email`),
  KEY `email_user_uuid` (`email_user_uuid`),
  CONSTRAINT `hpapi_email_ibfk_1` FOREIGN KEY (`email_user_uuid`) REFERENCES `hpapi_user` (`user_uuid`)
) ENGINE=InnoDB DEFAULT CHARSET=ascii;


CREATE TABLE IF NOT EXISTS `hpapi_key` (
  `key_key` varchar(52) CHARACTER SET ascii NOT NULL,
  `key_expired` int(1) unsigned NOT NULL DEFAULT '0',
  `key_remote_addr_pattern` varchar(64) CHARACTER SET ascii NOT NULL DEFAULT '^.*$',
  PRIMARY KEY (`key_key`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


CREATE TABLE IF NOT EXISTS `hpapi_keyrelease` (
  `keyrelease_key` varchar(64) CHARACTER SET ascii NOT NULL,
  `keyrelease_expires_datetime` varchar(32) CHARACTER SET ascii NOT NULL,
  PRIMARY KEY (`keyrelease_Key`),
  CONSTRAINT `hpapi_keyrelease_ibfk_1` FOREIGN KEY (`keyrelease_key`) REFERENCES `hpapi_key` (`key_key`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


CREATE TABLE IF NOT EXISTS `hpapi_level` (
  `level_level` int(11) unsigned NOT NULL,
  `level_name` varchar(64) NOT NULL,
  `level_notes` text NOT NULL,
  PRIMARY KEY (`level_Level`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


CREATE TABLE IF NOT EXISTS `hpapi_log` (
  `log_datetime` varchar(32) CHARACTER SET ascii NOT NULL,
  `log_microtime` decimal(9,8) unsigned NOT NULL,
  `log_key` varchar(64) CHARACTER SET ascii NOT NULL,
  `log_email` varchar(254) CHARACTER SET ascii NOT NULL,
  `log_remote_addr` varchar(64) CHARACTER SET ascii NOT NULL,
  `log_user_agent` varchar(255) CHARACTER SET ascii NOT NULL,
  `log_vendor` varchar(64) CHARACTER SET ascii NOT NULL,
  `log_package` varchar(64) CHARACTER SET ascii NOT NULL,
  `log_class` varchar(64) CHARACTER SET ascii NOT NULL,
  `log_method` varchar(64) CHARACTER SET ascii NOT NULL,
  `log_error` varchar(64) NOT NULL,
  `log_notice` varchar(64) NOT NULL,
  PRIMARY KEY (`log_datetime`,`log_microtime`,`log_key`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE IF NOT EXISTS `hpapi_membership` (
  `membership_user_uuid` varchar(64) CHARACTER SET ascii NOT NULL,
  `membership_usergroup` varchar(64) CHARACTER SET ascii NOT NULL,
  PRIMARY KEY (`membership_user_uuid`,`membership_usergroup`),
  KEY `membership_usergroup` (`membership_usergroup`),
  CONSTRAINT `hpapi_membership_ibfk_1` FOREIGN KEY (`membership_user_uuid`) REFERENCES `hpapi_user` (`user_uuid`),
  CONSTRAINT `hpapi_membership_ibfk_2` FOREIGN KEY (`membership_usergroup`) REFERENCES `hpapi_usergroup` (`usergroup_usergroup`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


CREATE TABLE IF NOT EXISTS `hpapi_method` (
  `method_vendor` varchar(64) CHARACTER SET ascii NOT NULL,
  `method_package` varchar(64) CHARACTER SET ascii NOT NULL,
  `method_class` varchar(64) CHARACTER SET ascii NOT NULL,
  `method_method` varchar(64) CHARACTER SET ascii NOT NULL,
  `method_label` varchar(64) NOT NULL,
  `method_notes` text NOT NULL,
  PRIMARY KEY (`method_vendor`,`method_package`,`method_class`,`method_method`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


CREATE TABLE IF NOT EXISTS `hpapi_methodarg` (
  `methodarg_vendor` varchar(64) CHARACTER SET ascii NOT NULL,
  `methodarg_package` varchar(64) CHARACTER SET ascii NOT NULL,
  `methodarg_class` varchar(64) CHARACTER SET ascii NOT NULL,
  `methodarg_method` varchar(64) CHARACTER SET ascii NOT NULL,
  `methodarg_argument` int(4) unsigned NOT NULL DEFAULT '1',
  `methodarg_name` varchar(64) NOT NULL,
  `methodarg_empty_allowed` int(1) unsigned NOT NULL DEFAULT '0',
  `methodarg_pattern` varchar(64) CHARACTER SET ascii NOT NULL,
  PRIMARY KEY (`methodarg_vendor`,`methodarg_package`,`methodarg_class`,`methodarg_method`,`methodarg_argument`),
  KEY `methodarg_pattern` (`methodarg_pattern`),
  CONSTRAINT `hpapi_methodarg_ibfk_1` FOREIGN KEY (`methodarg_pattern`) REFERENCES `hpapi_pattern` (`pattern_pattern`),
  CONSTRAINT `hpapi_methodarg_ibfk_3` FOREIGN KEY (`methodarg_vendor`, `methodarg_package`, `methodarg_class`, `methodarg_method`) REFERENCES `hpapi_method` (`method_Vendor`, `method_Package`, `method_Class`, `method_Method`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


CREATE TABLE IF NOT EXISTS `hpapi_model` (
  `model_model` varchar(64) CHARACTER SET ascii NOT NULL,
  `model_notes` text NOT NULL,
  `model_dsn` varchar(255) NOT NULL,
  `model_usr` varchar(255) NOT NULL,
  `model_pwd` varchar(255) NOT NULL,
  PRIMARY KEY (`model_model`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


CREATE TABLE IF NOT EXISTS `hpapi_package` (
  `package_vendor` varchar(64) CHARACTER SET ascii NOT NULL,
  `package_package` varchar(64) CHARACTER SET ascii NOT NULL,
  `package_notes` text NOT NULL,
  PRIMARY KEY (`package_vendor`,`package_package`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;



CREATE TABLE IF NOT EXISTS `hpapi_pattern` (
  `pattern_pattern` varchar(64) CHARACTER SET ascii NOT NULL,
  `pattern_constraints` varchar(255) NOT NULL,
  `pattern_expression` varchar(255) NOT NULL,
  `pattern_input` varchar(64) CHARACTER SET ascii NOT NULL DEFAULT 'text',
  `pattern_php_filter` varchar(64) CHARACTER SET ascii NOT NULL,
  `pattern_length_minimum` int(11) unsigned NOT NULL DEFAULT '0',
  `pattern_length_maximum` int(11) unsigned NOT NULL DEFAULT '0',
  `pattern_value_minimum` varchar(255) NOT NULL,
  `pattern_value_maximum` varchar(255) NOT NULL,
  PRIMARY KEY (`pattern_pattern`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


CREATE TABLE IF NOT EXISTS `hpapi_run` (
  `run_usergroup` varchar(64) CHARACTER SET ascii NOT NULL,
  `run_vendor` varchar(64) CHARACTER SET ascii NOT NULL,
  `run_package` varchar(64) CHARACTER SET ascii NOT NULL,
  `run_class` varchar(64) CHARACTER SET ascii NOT NULL,
  `run_method` varchar(64) CHARACTER SET ascii NOT NULL,
  PRIMARY KEY (`run_vendor`,`run_package`,`run_class`,`run_method`,`run_usergroup`),
  KEY `run_usergroup` (`run_usergroup`),
  CONSTRAINT `hpapi_run_ibfk_2` FOREIGN KEY (`run_vendor`, `run_package`, `run_class`, `run_method`) REFERENCES `hpapi_method` (`method_vendor`, `method_package`, `method_class`, `method_method`),
  CONSTRAINT `hpapi_run_ibfk_3` FOREIGN KEY (`run_usergroup`) REFERENCES `hpapi_usergroup` (`usergroup_usergroup`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


CREATE TABLE IF NOT EXISTS `hpapi_spr` (
  `spr_model` varchar(64) CHARACTER SET ascii NOT NULL,
  `spr_spr` varchar(64) CHARACTER SET ascii NOT NULL,
  `spr_notes` text NOT NULL,
  PRIMARY KEY (`spr_model`,`spr_spr`),
  CONSTRAINT `hpapi_spr_ibfk_1` FOREIGN KEY (`spr_model`) REFERENCES `hpapi_model` (`model_model`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


CREATE TABLE IF NOT EXISTS `hpapi_sprarg` (
  `sprarg_model` varchar(64) CHARACTER SET ascii NOT NULL,
  `sprarg_spr` varchar(64) CHARACTER SET ascii NOT NULL,
  `sprarg_argument` int(1) unsigned NOT NULL DEFAULT '1',
  `sprarg_name` varchar(64) NOT NULL,
  `sprarg_empty_allowed` int(1) unsigned NOT NULL DEFAULT '0',
  `sprarg_pattern` varchar(255) CHARACTER SET ascii NOT NULL,
  PRIMARY KEY (`sprarg_model`,`sprarg_spr`,`sprarg_argument`),
  KEY `sprarg_pattern` (`sprarg_pattern`),
  CONSTRAINT `hpapi_sprarg_ibfk_2` FOREIGN KEY (`sprarg_pattern`) REFERENCES `hpapi_pattern` (`pattern_pattern`),
  CONSTRAINT `hpapi_sprarg_ibfk_3` FOREIGN KEY (`sprarg_model`, `sprarg_spr`) REFERENCES `hpapi_spr` (`spr_model`, `spr_spr`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


CREATE TABLE IF NOT EXISTS `hpapi_user` (
  `user_active` int(1) unsigned NOT NULL DEFAULT '1',
  `user_uuid` varchar(64) CHARACTER SET ascii NOT NULL,
  `user_notes` text NOT NULL,
  `user_name` varchar(64) NOT NULL,
  `user_key` varchar(64) CHARACTER SET ascii DEFAULT NULL,
  `user_password_hash` varchar(255) CHARACTER SET ascii NOT NULL DEFAULT '',
  PRIMARY KEY (`user_uuid`),
  KEY `user_key` (`user_key`),
  CONSTRAINT `hpapi_user_ibfk_1` FOREIGN KEY (`user_key`) REFERENCES `hpapi_key` (`key_key`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


CREATE TABLE IF NOT EXISTS `hpapi_usergroup` (
  `usergroup_usergroup` varchar(64) CHARACTER SET ascii NOT NULL,
  `usergroup_level` int(11) unsigned NOT NULL,
  `usergroup_name` varchar(64) NOT NULL,
  `usergroup_remote_addr_pattern` varchar(64) CHARACTER SET ascii NOT NULL DEFAULT '^.*$',
  `usergroup_notes` text NOT NULL,
  PRIMARY KEY (`usergroup_usergroup`),
  KEY `usergroup_level` (`usergroup_level`),
  CONSTRAINT `hpapi_usergroup_ibfk_1` FOREIGN KEY (`usergroup_level`) REFERENCES `hpapi_level` (`level_level`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

