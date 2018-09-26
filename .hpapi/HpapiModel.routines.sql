

SET NAMES utf8;
SET time_zone = '+00:00';


DELIMITER $$


DROP PROCEDURE IF EXISTS `hpapiAuthDetails`$$
CREATE PROCEDURE `hpapiAuthDetails`(
  IN        `dt` VARCHAR(32) CHARSET ascii
 ,IN        `keyKey` CHAR(52) CHARSET ascii
 ,IN        `emailEmail` VARCHAR(254) CHARSET ascii
)
BEGIN
  SELECT
    `user_uuid` AS `userUUID` 
   ,`user_active` AS `userActive` 
   ,`user_password_hash` AS `passwordHash` 
   ,`email_user_uuid` IS NOT NULL AS `emailFound` 
   ,`email_verified` AS `emailVerified` 
   ,`new_key`.`key_key` AS `newKey` 
   ,IFNULL(`new_key`.`key_remote_addr_pattern`,`cur_key`.`key_remote_addr_pattern`) AS `remoteAddrPattern`
  FROM `hpapi_email`
  LEFT JOIN `hpapi_user`
         ON `user_uuid`=`email_user_uuid`
  LEFT JOIN `hpapi_key` AS `cur_key`
         ON `cur_key`.`key_key`=keyKey
        AND `cur_key`.`key_expired`='0'
  LEFT JOIN `hpapi_keyrelease`
         ON `keyrelease_user_uuid`=`user_uuid`
        AND `keyrelease_expires_date`>dt
  LEFT JOIN `hpapi_key` AS `new_key`
         ON `new_key`.`key_Key`=`keyrelease_Key`
        AND `new_key`.`key_expired`='0'
  WHERE `email_email`=emailEmail
    AND `cur_key`.`key_Key`=`user_key`
    AND (
         `cur_key`.`key_Key` IS NOT NULL
      OR `new_key`.`key_Key` IS NOT NULL
    )
  LIMIT 0,1
  ;
END$$


DROP PROCEDURE IF EXISTS `hpapiKeyreleaseRevoke`$$
CREATE PROCEDURE `hpapiKeyreleaseRevoke`(
  IN        `dt` VARCHAR(32) CHARSET ascii
 ,IN        `ky` CHAR(52) CHARSET ascii
)
BEGIN
  DELETE
  FROM `hpapi_keyrelease`
  WHERE `keyrelease_expires_date`<dt
     OR `keyrelease_key`=ky
  ;
END $$


DROP PROCEDURE IF EXISTS `hpapiLogRequest`$$
CREATE PROCEDURE `hpapiLogRequest`(
  IN        `dt` VARCHAR(32) CHARSET ascii
 ,IN        `mt` DECIMAL(9,8) UNSIGNED
 ,IN        `ky` VARCHAR(64) CHARSET ascii
 ,IN        `email` VARCHAR(254) CHARSET utf8
 ,IN        `remoteAddr` VARCHAR(64) CHARSET ascii
 ,IN        `userAgent` VARCHAR(255) CHARSET ascii
 ,IN        `vendor` VARCHAR(64) CHARSET ascii
 ,IN        `package` VARCHAR(64) CHARSET ascii
 ,IN        `class` VARCHAR(64) CHARSET ascii
 ,IN        `method` VARCHAR(64) CHARSET ascii
 ,IN        `err` VARCHAR(64) CHARSET utf8
 ,IN        `ntc` VARCHAR(64) CHARSET utf8
)
BEGIN
  INSERT INTO `hpapi_log`
  SET
    `log_datetime`=dt
   ,`log_microtime`=mt
   ,`log_key`=ky
   ,`log_email`=email
   ,`log_remote_addr`=remoteAddr
   ,`log_user_agent`=userAgent
   ,`log_vendor`=vendor
   ,`log_package`=package
   ,`log_class`=class
   ,`log_method`=method
   ,`log_error`=err
   ,`log_notice`=ntc
  ;
END $$


DROP PROCEDURE IF EXISTS `hpapiMethodargs`$$
CREATE PROCEDURE `hpapiMethodargs`(
  IN        `userUUID` CHAR(52) CHARSET ascii
 ,IN        `methodVendor` VARCHAR(64) CHARSET ascii
 ,IN        `methodPackage` VARCHAR(64) CHARSET ascii
 ,IN        `methodClass` VARCHAR(64) CHARSET ascii
 ,IN        `methodMethod` VARCHAR(64) CHARSET ascii
)
BEGIN
  SELECT
    `method_label` AS `label`
   ,`method_notes` AS `notes`
   ,`methodarg_argument` AS `argument`
   ,`methodarg_name` AS `name`
   ,`methodarg_empty_allowed` AS `emptyAllowed`
   ,`pattern_pattern` AS `pattern`
   ,`pattern_constraints` AS `constraints`
   ,`pattern_expression` AS `expression`
   ,`pattern_php_filter` AS `phpFilter`
   ,`pattern_length_minimum` AS `lengthMinimum`
   ,`pattern_length_maximum` AS `lengthMaximum`
   ,`pattern_value_minimum` AS `valueMinimum`
   ,`pattern_value_maximum` AS `valueMaximum`
   ,IFNULL(`ug`.`usergroup_remote_addr_pattern`,`anon`.`usergroup_remote_addr_pattern`) AS `remoteAddrPattern`
  FROM `hpapi_method`
  LEFT JOIN `hpapi_methodarg`
         ON `methodarg_vendor`=methodVendor
        AND `methodarg_package`=methodPackage
        AND `methodarg_class`=methodClass
        AND `methodarg_method`=methodMethod
  LEFT JOIN `hpapi_pattern`
         ON `pattern_pattern`=`methodarg_pattern`
  LEFT JOIN `hpapi_run`
         ON `run_vendor`=methodVendor
        AND `run_package`=methodPackage
        AND `run_class`=methodClass
        AND `run_method`=methodMethod
  LEFT JOIN `hpapi_membership`
         ON `membership_usergroup`=`run_usergroup`
        AND `membership_user_uuid`=userUUID
  LEFT JOIN `hpapi_usergroup` AS `ug`
         ON `ug`.`usergroup_usergroup`=`membership_usergroup`
  LEFT JOIN `hpapi_usergroup` AS `anon`
         ON `anon`.`usergroup_usergroup`='anon'
  WHERE `method_vendor`=methodVendor
    AND `method_package`=methodPackage
    AND `method_class`=methodClass
    AND `method_method`=methodMethod
    AND (
        `membership_user_uuid` IS NOT NULL
     OR `run_usergroup`='anon'
    )
  ORDER BY `methodarg_argument`
  ;
END$$


DROP PROCEDURE IF EXISTS `hpapiSprargs`$$
CREATE PROCEDURE `hpapiSprargs`(
  IN        `methodVendor` VARCHAR(64) CHARSET ascii
 ,IN        `methodPackage` VARCHAR(64) CHARSET ascii
 ,IN        `methodClass` VARCHAR(64) CHARSET ascii
 ,IN        `methodMethod` VARCHAR(64) CHARSET ascii
)
BEGIN
  SELECT
    `spr_model` AS `model`
   ,`spr_spr` AS `spr`
   ,`spr_notes` AS `notes`
   ,`sprarg_argument` AS `argument`
   ,`sprarg_name` AS `name`
   ,`sprarg_empty_allowed` AS `emptyAllowed`
   ,`pattern_pattern` AS `pattern`
   ,`pattern_constraints` AS `constraints`
   ,`pattern_expression` AS `expression`
   ,`pattern_php_filter` AS `phpFilter`
   ,`pattern_length_minimum` AS `lengthMinimum`
   ,`pattern_length_maximum` AS `lengthMaximum`
   ,`pattern_value_minimum` AS `valueMinimum`
   ,`pattern_value_maximum` AS `valueMaximum`
  FROM `hpapi_method`
  LEFT JOIN `hpapi_call`
     ON `call_vendor`=`method_vendor`
    AND `call_vendor`=methodVendor
    AND `call_package`=`method_package`
    AND `call_package`=methodPackage
    AND `call_class`=`method_class`
    AND `call_class`=methodClass
    AND `call_method`=`method_method`
    AND `call_method`=methodMethod
  LEFT JOIN `hpapi_spr`
         ON `spr_model`=`call_model`
        AND `spr_spr`=`call_spr`
  LEFT JOIN `hpapi_sprarg`
         ON `sprarg_model`=`spr_model`
        AND `sprarg_spr`=`spr_spr`
  LEFT JOIN `hpapi_pattern`
         ON `pattern_pattern`=`sprarg_pattern`
  WHERE `method_vendor`=methodVendor
    AND `method_package`=methodPackage
    AND `method_class`=methodClass
    AND `method_method`=methodMethod
  GROUP BY `spr_model`,`spr_spr`,`sprarg_argument`
  ORDER BY `spr_model`,`spr_spr`,`sprarg_argument`
  ;
END$$


DROP PROCEDURE IF EXISTS `hpapiInsertTestUsers`$$
CREATE PROCEDURE `hpapiInsertTestUsers`(
)
BEGIN
  IF ((SELECT COUNT(`user_uuid`) FROM `hpapi_user`) = 0) THEN
    INSERT IGNORE INTO `hpapi_key` (`key_key`, `key_expired`, `key_remote_addr_pattern`) VALUES
    ('20180720110427::89c56ad8-8ff3-11e8-902b-001f16148bc1',  0,  '^.*$'),
    ('20180725104327::0e0f4ce8-8fee-11e8-902b-001f16148bc1',  0,  '^.*$');
    INSERT IGNORE INTO `hpapi_user` (`user_Active`, `user_UUID`, `user_Notes`, `user_Name`, `user_Key`, `user_Password_Hash`) VALUES
    (1, '20180720110427::322025bd-8ff2-11e8-902b-001f16148bc1', 'Temporary system administrator',  'Sysadmin Temp',  '20180725104327::0e0f4ce8-8fee-11e8-902b-001f16148bc1', '$2y$10$hLSdApW6.30YLK3ze49uSu7OV0gmS3ZT65pufxDPGiMxsmW3bykeq'),
    (1, '20180720110427::57d2eff7-8ff3-11e8-902b-001f16148bc1', 'Temporary organisation administrator',  'Admin Temp', '20180720110427::89c56ad8-8ff3-11e8-902b-001f16148bc1', '$2y$10$hLSdApW6.30YLK3ze49uSu7OV0gmS3ZT65pufxDPGiMxsmW3bykeq');
    INSERT IGNORE INTO `hpapi_email` (`email_Verified`, `email_Email`, `email_User_UUID`) VALUES
    (1, 'sysadmin@no.where',  '20180720110427::322025bd-8ff2-11e8-902b-001f16148bc1'),
    (1, 'orgadmin@no.where',  '20180720110427::57d2eff7-8ff3-11e8-902b-001f16148bc1');
    INSERT IGNORE INTO `hpapi_membership` (`membership_User_UUID`, `membership_Usergroup`) VALUES
    ('20180720110427::322025bd-8ff2-11e8-902b-001f16148bc1',  'sysadmin'),
    ('20180720110427::57d2eff7-8ff3-11e8-902b-001f16148bc1',  'admin');
    SELECT 'Inserted test users into hpapi_key, hpapi_user, hpapi_email and hpapi_membership' AS `Completed`;
  ELSE
    SELECT 'Refusing to add test users - rows found in hpapi_user' AS `Refused`;
  END IF
  ;
END$$


DELIMITER ;


