
-- Copyright 2018 Whitelamp http://www.whitelamp.com/

SET NAMES utf8;
SET time_zone = '+00:00';
SET foreign_key_checks = 0;


CREATE TABLE IF NOT EXISTS `hpapi_call` (
  `model` varchar(64) CHARACTER SET ascii NOT NULL,
  `spr` varchar(64) CHARACTER SET ascii NOT NULL,
  `vendor` varchar(64) CHARACTER SET ascii NOT NULL,
  `package` varchar(64) CHARACTER SET ascii NOT NULL,
  `class` varchar(64) CHARACTER SET ascii NOT NULL,
  `method` varchar(64) CHARACTER SET ascii NOT NULL,
  `created` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  `updated` TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`model`,`spr`,`vendor`,`package`,`class`,`method`),
  KEY `call_vendor` (`vendor`,`package`,`class`,`method`),
  CONSTRAINT `hpapi_call_ibfk_2` FOREIGN KEY (`model`, `spr`) REFERENCES `hpapi_spr` (`model`, `spr`),
  CONSTRAINT `hpapi_call_ibfk_4` FOREIGN KEY (`vendor`, `package`, `class`, `method`) REFERENCES `hpapi_method` (`vendor`, `package`, `class`, `method`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='Permits method to call a stored procedure';


CREATE TABLE IF NOT EXISTS `hpapi_level` (
  `level` int(11) unsigned NOT NULL,
  `name` varchar(64) NOT NULL,
  `notes` text NOT NULL,
  `created` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  `updated` TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`level`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='Security levels for user groups';


CREATE TABLE IF NOT EXISTS `hpapi_log` (
  `datetime` varchar(32) CHARACTER SET ascii NOT NULL,
  `microtime` decimal(9,8) unsigned NOT NULL,
  `key` varchar(64) CHARACTER SET ascii NOT NULL,
  `email` varchar(254) CHARACTER SET ascii NOT NULL,
  `remote_addr` varbinary(16) NOT NULL,
  `user_agent` varchar(255) CHARACTER SET ascii NOT NULL,
  `vendor` varchar(64) CHARACTER SET ascii NOT NULL,
  `package` varchar(64) CHARACTER SET ascii NOT NULL,
  `class` varchar(64) CHARACTER SET ascii NOT NULL,
  `method` varchar(64) CHARACTER SET ascii NOT NULL,
  `error` varchar(64) NOT NULL,
  `diagnostic` text NOT NULL,
  `created` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  `updated` TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`datetime`,`microtime`,`key`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='Logs each request';


CREATE TABLE IF NOT EXISTS `hpapi_membership` (
  `user_id` int(11) unsigned NOT NULL,
  `usergroup` varchar(64) CHARACTER SET ascii NOT NULL,
  `created` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`user_id`,`usergroup`),
  KEY `membership_usergroup` (`usergroup`),
  CONSTRAINT `hpapi_membership_ibfk_1` FOREIGN KEY (`usergroup`) REFERENCES `hpapi_usergroup` (`usergroup`),
  CONSTRAINT `hpapi_membership_ibfk_2` FOREIGN KEY (`user_id`) REFERENCES `hpapi_user` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='Associates users with user groups';


CREATE TABLE IF NOT EXISTS `hpapi_method` (
  `vendor` varchar(64) CHARACTER SET ascii NOT NULL,
  `package` varchar(64) CHARACTER SET ascii NOT NULL,
  `class` varchar(64) CHARACTER SET ascii NOT NULL,
  `method` varchar(64) CHARACTER SET ascii NOT NULL,
  `label` varchar(64) NOT NULL,
  `notes` text NOT NULL,
  `created` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  `updated` TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`vendor`,`package`,`class`,`method`),
  CONSTRAINT `hpapi_method_ibfk_1` FOREIGN KEY (`vendor`, `package`) REFERENCES `hpapi_package` (`vendor`, `package`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='Program methods available to the API';


CREATE TABLE IF NOT EXISTS `hpapi_methodarg` (
  `vendor` varchar(64) CHARACTER SET ascii NOT NULL,
  `package` varchar(64) CHARACTER SET ascii NOT NULL,
  `class` varchar(64) CHARACTER SET ascii NOT NULL,
  `method` varchar(64) CHARACTER SET ascii NOT NULL,
  `argument` int(4) unsigned NOT NULL DEFAULT '1',
  `name` varchar(64) NOT NULL,
  `empty_allowed` int(1) unsigned NOT NULL DEFAULT '0',
  `pattern` varchar(64) CHARACTER SET ascii NOT NULL,
  `created` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  `updated` TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`vendor`,`package`,`class`,`method`,`argument`),
  KEY `methodarg_pattern` (`pattern`),
  CONSTRAINT `hpapi_methodarg_ibfk_1` FOREIGN KEY (`pattern`) REFERENCES `hpapi_pattern` (`pattern`),
  CONSTRAINT `hpapi_methodarg_ibfk_4` FOREIGN KEY (`vendor`, `package`, `class`, `method`) REFERENCES `hpapi_method` (`vendor`, `package`, `class`, `method`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='Arguments to program methods';


CREATE TABLE IF NOT EXISTS `hpapi_model` (
  `model` varchar(64) CHARACTER SET ascii NOT NULL,
  `notes` text NOT NULL,
  `created` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  `updated` TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`model`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='Scoping of data structures known as models';


CREATE TABLE IF NOT EXISTS `hpapi_package` (
  `vendor` varchar(64) CHARACTER SET ascii NOT NULL,
  `package` varchar(64) CHARACTER SET ascii NOT NULL,
  `notes` text NOT NULL,
  `created` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  `updated` TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`vendor`,`package`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='Program vendor/packages available to the API';


CREATE TABLE IF NOT EXISTS `hpapi_pattern` (
  `pattern` varchar(64) CHARACTER SET ascii NOT NULL,
  `constraints` varchar(255) NOT NULL,
  `expression` varchar(255) NOT NULL,
  `input` varchar(64) CHARACTER SET ascii NOT NULL DEFAULT 'text',
  `php_filter` varchar(64) CHARACTER SET ascii NOT NULL,
  `length_minimum` int(11) unsigned NOT NULL DEFAULT '0',
  `length_maximum` int(11) unsigned NOT NULL DEFAULT '0',
  `value_minimum` varchar(255) NOT NULL,
  `value_maximum` varchar(255) NOT NULL,
  `created` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  `updated` TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`pattern`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='Patterns for constraining input values';


CREATE TABLE IF NOT EXISTS `hpapi_run` (
  `usergroup` varchar(64) CHARACTER SET ascii NOT NULL,
  `vendor` varchar(64) CHARACTER SET ascii NOT NULL,
  `package` varchar(64) CHARACTER SET ascii NOT NULL,
  `class` varchar(64) CHARACTER SET ascii NOT NULL,
  `method` varchar(64) CHARACTER SET ascii NOT NULL,
  `created` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  `updated` TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`vendor`,`package`,`class`,`method`,`usergroup`),
  KEY `run_usergroup` (`usergroup`),
  CONSTRAINT `hpapi_run_ibfk_1` FOREIGN KEY (`usergroup`) REFERENCES `hpapi_usergroup` (`usergroup`),
  CONSTRAINT `hpapi_run_ibfk_3` FOREIGN KEY (`vendor`, `package`, `class`, `method`) REFERENCES `hpapi_method` (`vendor`, `package`, `class`, `method`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='Permits a user group to run a program method';


CREATE TABLE IF NOT EXISTS `hpapi_spr` (
  `model` varchar(64) CHARACTER SET ascii NOT NULL,
  `spr` varchar(64) CHARACTER SET ascii NOT NULL,
  `notes` text NOT NULL,
  `created` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  `updated` TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`model`,`spr`),
  CONSTRAINT `hpapi_spr_ibfk_1` FOREIGN KEY (`model`) REFERENCES `hpapi_model` (`model`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='Stored procedures accessed by the API';


CREATE TABLE IF NOT EXISTS `hpapi_sprarg` (
  `model` varchar(64) CHARACTER SET ascii NOT NULL,
  `spr` varchar(64) CHARACTER SET ascii NOT NULL,
  `argument` int(1) unsigned NOT NULL DEFAULT '1',
  `name` varchar(64) NOT NULL,
  `empty_allowed` int(1) unsigned NOT NULL DEFAULT '0',
  `pattern` varchar(255) CHARACTER SET ascii NOT NULL,
  `created` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  `updated` TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`model`,`spr`,`argument`),
  KEY `sprarg_pattern` (`pattern`),
  CONSTRAINT `hpapi_sprarg_ibfk_2` FOREIGN KEY (`pattern`) REFERENCES `hpapi_pattern` (`pattern`),
  CONSTRAINT `hpapi_sprarg_ibfk_3` FOREIGN KEY (`model`, `spr`) REFERENCES `hpapi_spr` (`model`, `spr`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='SQL stored procedure argument constraints';


CREATE TABLE IF NOT EXISTS `hpapi_user` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `active` int(1) unsigned NOT NULL DEFAULT '1',
  `uuid` varchar(64) CHARACTER SET ascii NOT NULL,
  `key` varchar(64) CHARACTER SET ascii NOT NULL,
  `key_expired` int(1) unsigned NOT NULL DEFAULT '0',
  `key_release` int(1) unsigned NOT NULL DEFAULT '1',
  `key_release_until` timestamp NOT NULL DEFAULT '0000-00-00 00:00:00',
  `remote_addr_pattern` varchar(64) NOT NULL DEFAULT '^.*$',
  `name` varchar(64) NOT NULL,
  `notes` text NOT NULL,
  `email` varchar(254) CHARACTER SET ascii NOT NULL,
  `email_verified` int(1) unsigned NOT NULL DEFAULT '0',
  `email_fallback` varchar(254) CHARACTER SET ascii NOT NULL,
  `email_fallback_verified` int(1) unsigned NOT NULL DEFAULT '0',
  `password_hash` varchar(255) CHARACTER SET ascii NOT NULL DEFAULT '',
  `token` varchar(255) CHARACTER SET ascii NOT NULL,
  `token_expires` datetime NOT NULL,
  `token_remote_addr` varbinary(16) NOT NULL,
  `created` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `user_key` (`key`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='API users';

CREATE TABLE IF NOT EXISTS `hpapi_usergroup` (
  `usergroup` varchar(64) CHARACTER SET ascii NOT NULL,
  `level` int(11) unsigned NOT NULL,
  `name` varchar(64) NOT NULL,
  `token_duration_minutes` int(11) unsigned NOT NULL DEFAULT 1,
  `remote_addr_pattern` varchar(64) CHARACTER SET ascii NOT NULL DEFAULT '^.*$',
  `notes` text NOT NULL,
  `created` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  `updated` TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`usergroup`),
  KEY `usergroup_level` (`level`),
  CONSTRAINT `hpapi_usergroup_ibfk_1` FOREIGN KEY (`level`) REFERENCES `hpapi_level` (`level`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='API user groups';

