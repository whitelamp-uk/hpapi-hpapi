

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
    `user_UUID` AS `userUUID` 
   ,`user_Active` AS `userActive` 
   ,`user_Password_Hash` AS `passwordHash` 
   ,`email_User_UUID` IS NOT NULL AS `emailFound` 
   ,`email_Verified` AS `emailVerified` 
   ,`new_key`.`key_Key` AS `newKey` 
   ,IFNULL(`new_key`.`key_Remote_Addr_Pattern`,`cur_key`.`key_Remote_Addr_Pattern`) AS `remoteAddrPattern`
  FROM `hpapi_email`
  LEFT JOIN `hpapi_user`
         ON `user_UUID`=`email_User_UUID`
  LEFT JOIN `hpapi_key` AS `cur_key`
         ON `cur_key`.`key_Key`=keyKey
        AND `cur_key`.`key_Expired`='0'
  LEFT JOIN `hpapi_keyrelease`
         ON `keyrelease_User_UUID`=`user_UUID`
        AND `keyrelease_Expires_Date`>dt
  LEFT JOIN `hpapi_key` AS `new_key`
         ON `new_key`.`key_Key`=`keyrelease_Key`
        AND `new_key`.`key_Expired`='0'
  WHERE `email_Email`=emailEmail
    AND `cur_key`.`key_Key`=`user_Key`
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
  WHERE `keyrelease_Expires_Date`<dt
     OR `keyrelease_Key`=ky
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
    `log_Datetime`=dt
   ,`log_Microtime`=mt
   ,`log_Key`=ky
   ,`log_Email`=email
   ,`log_Remote_Addr`=remoteAddr
   ,`log_User_Agent`=userAgent
   ,`log_Vendor`=vendor
   ,`log_Package`=package
   ,`log_Class`=class
   ,`log_Method`=method
   ,`log_Error`=err
   ,`log_Notice`=ntc
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
    `method_Label` AS `label`
   ,`method_Notes` AS `notes`
   ,`methodarg_Argument` AS `argument`
   ,`methodarg_Name` AS `name`
   ,`methodarg_Empty_Allowed` AS `emptyAllowed`
   ,`pattern_Pattern` AS `pattern`
   ,`pattern_Constraints` AS `constraints`
   ,`pattern_Expression` AS `expression`
   ,`pattern_Php_Filter` AS `phpFilter`
   ,`pattern_Length_Minimum` AS `lengthMinimum`
   ,`pattern_Length_Maximum` AS `lengthMaximum`
   ,`pattern_Value_Minimum` AS `valueMinimum`
   ,`pattern_Value_Maximum` AS `valueMaximum`
   ,IFNULL(`ug`.`usergroup_Remote_Addr_Pattern`,`anon`.`usergroup_Remote_Addr_Pattern`) AS `remoteAddrPattern`
  FROM `hpapi_method`
  LEFT JOIN `hpapi_methodarg`
         ON `methodarg_Vendor`=methodVendor
        AND `methodarg_Package`=methodPackage
        AND `methodarg_Class`=methodClass
        AND `methodarg_Method`=methodMethod
  LEFT JOIN `hpapi_pattern`
         ON `pattern_Pattern`=`methodarg_Pattern`
  LEFT JOIN `hpapi_run`
         ON `run_Vendor`=methodVendor
        AND `run_Package`=methodPackage
        AND `run_Class`=methodClass
        AND `run_Method`=methodMethod
  LEFT JOIN `hpapi_membership`
         ON `membership_Usergroup`=`run_Usergroup`
        AND `membership_User_UUID`=userUUID
  LEFT JOIN `hpapi_usergroup` AS `ug`
         ON `ug`.`usergroup_Usergroup`=`membership_Usergroup`
  LEFT JOIN `hpapi_usergroup` AS `anon`
         ON `anon`.`usergroup_Usergroup`='anon'
  WHERE `method_Vendor`=methodVendor
    AND `method_Package`=methodPackage
    AND `method_Class`=methodClass
    AND `method_Method`=methodMethod
    AND (
        `membership_User_UUID` IS NOT NULL
     OR `run_Usergroup`='anon'
    )
  ORDER BY `methodarg_Argument`
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
    `spr_Model` AS `model`
   ,`spr_Spr` AS `spr`
   ,`spr_Notes` AS `notes`
   ,`sprarg_Argument` AS `argument`
   ,`sprarg_Name` AS `name`
   ,`sprarg_Empty_Allowed` AS `emptyAllowed`
   ,`pattern_Pattern` AS `pattern`
   ,`pattern_Constraints` AS `constraints`
   ,`pattern_Expression` AS `expression`
   ,`pattern_Php_Filter` AS `phpFilter`
   ,`pattern_Length_Minimum` AS `lengthMinimum`
   ,`pattern_Length_Maximum` AS `lengthMaximum`
   ,`pattern_Value_Minimum` AS `valueMinimum`
   ,`pattern_Value_Maximum` AS `valueMaximum`
  FROM `hpapi_method`
  LEFT JOIN `hpapi_call`
     ON `call_Vendor`=`method_Vendor`
    AND `call_Vendor`=methodVendor
    AND `call_Package`=`method_Package`
    AND `call_Package`=methodPackage
    AND `call_Class`=`method_Class`
    AND `call_Class`=methodClass
    AND `call_Method`=`method_Method`
    AND `call_Method`=methodMethod
  LEFT JOIN `hpapi_spr`
         ON `spr_Model`=`call_Model`
        AND `spr_Spr`=`call_Spr`
  LEFT JOIN `hpapi_sprarg`
         ON `sprarg_Model`=`spr_Model`
        AND `sprarg_Spr`=`spr_Spr`
  LEFT JOIN `hpapi_pattern`
         ON `pattern_Pattern`=`sprarg_Pattern`
  WHERE `method_Vendor`=methodVendor
    AND `method_Package`=methodPackage
    AND `method_Class`=methodClass
    AND `method_Method`=methodMethod
  GROUP BY `spr_Model`,`spr_Spr`,`sprarg_Argument`
  ORDER BY `spr_Model`,`spr_Spr`,`sprarg_Argument`
  ;
END$$


DROP PROCEDURE IF EXISTS `hpapiInsertTestUsers`$$
CREATE PROCEDURE `hpapiInsertTestUsers`(
)
BEGIN
  IF ((SELECT COUNT(`user_UUID`) FROM `hpapi_user`) = 0) THEN
    INSERT IGNORE INTO `hpapi_key` (`key_Key`, `key_Expired`, `key_Remote_Addr_Pattern`) VALUES
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


