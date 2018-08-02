-- Adminer 4.6.2 MySQL dump

SET NAMES utf8;
SET time_zone = '+00:00';


DELIMITER $$



DROP PROCEDURE IF EXISTS `hpapiGrantMembership`$$
CREATE PROCEDURE `hpapiGrantMembership`(
  IN        `userUUID` CHAR(52) CHARSET ascii
 ,IN        `usergroup` varchar(64) CHARSET ascii
)
BEGIN
  INSERT INTO `hpapi_membership`
  SET
    `membership_UserUUID`=userUUID
   ,`membership_Usergroup`=usergroup
  ;
END$$

DROP PROCEDURE IF EXISTS `hpapiRevokeMembership`$$
CREATE PROCEDURE `hpapiRevokeMembership`(
  IN        `userUUID` CHAR(52) CHARSET ascii
 ,IN        `usergroup` varchar(64) CHARSET ascii
)
BEGIN
  DELETE FROM `hpapi_membership`
  WHERE `membership_UserUUID`=userUUID
    AND `membership_Usergroup`=usergroup
    AND CHAR_LENGTH(`membership_UserUUID`)>0
  ;
END$$

DROP PROCEDURE IF EXISTS `hpapiGrantRun`$$
CREATE PROCEDURE `hpapiGrantRun`(
  IN        `usergroup` varchar(64) CHARSET ascii
 ,IN        `vendor` varchar(64) CHARSET ascii
 ,IN        `package` varchar(64) CHARSET ascii
 ,IN        `class` varchar(64) CHARSET ascii
 ,IN        `method` varchar(64) CHARSET ascii
)
BEGIN
  INSERT INTO `hpapi_run`
  SET
    `run_Usergroup`=usergroup
   ,`run_Vendor`=vendor
   ,`run_Package`=package
   ,`run_Class`=class
   ,`run_Method`=method
  ;
END$$

DROP PROCEDURE IF EXISTS `hpapiRevokeRun`$$
CREATE PROCEDURE `hpapiRevokeRun`(
  IN        `usergroup` varchar(64) CHARSET ascii
 ,IN        `vendor` varchar(64) CHARSET ascii
 ,IN        `package` varchar(64) CHARSET ascii
 ,IN        `class` varchar(64) CHARSET ascii
 ,IN        `method` varchar(64) CHARSET ascii
)
BEGIN
  DELETE FROM `hpapi_run`
  WHERE `run_Usergroup`=usergroup
    AND `run_Vendor`=vendor
    AND `run_Package`=package
    AND `run_Class`=class
    AND `run_Method`=method
  ;
END$$

DROP PROCEDURE IF EXISTS `hpapiGrantCall`$$
CREATE PROCEDURE `hpapiGrantCall`(
  IN        `model` varchar(64) CHARSET ascii
 ,IN        `spr` varchar(64) CHARSET ascii
 ,IN        `vendor` varchar(64) CHARSET ascii
 ,IN        `package` varchar(64) CHARSET ascii
 ,IN        `class` varchar(64) CHARSET ascii
 ,IN        `method` varchar(64) CHARSET ascii
)
BEGIN
  INSERT INTO `hpapi_call`
  SET
    `call_Model`=model
   ,`call_Spr`=spr
   ,`call_Vendor`=vendor
   ,`call_Package`=package
   ,`call_Class`=class
   ,`call_Method`=method
  ;
END$$

DROP PROCEDURE IF EXISTS `hpapiRevokeCall`$$
CREATE PROCEDURE `hpapiRevokeCall`(
  IN        `model` varchar(64) CHARSET ascii
 ,IN        `spr` varchar(64) CHARSET ascii
 ,IN        `vendor` varchar(64) CHARSET ascii
 ,IN        `package` varchar(64) CHARSET ascii
 ,IN        `class` varchar(64) CHARSET ascii
 ,IN        `method` varchar(64) CHARSET ascii
)
BEGIN
  DELETE FROM `hpapi_call`
  WHERE `call_Model`=model
    AND `call_Spr`=spr
    AND `call_Vendor`=vendor
    AND `call_Package`=package
    AND `call_Class`=class
    AND `call_Method`=method
  ;
END$$

DROP PROCEDURE IF EXISTS `hpapiMethods`$$
CREATE PROCEDURE `hpapiMethods`(
  IN        `userUUID` CHAR(52) CHARSET ascii
 ,IN        `authenticated` INT(1) UNSIGNED
)
BEGIN
  SELECT
    GROUP_CONCAT(DISTINCT `membership_Usergroup` SEPARATOR ',') AS `usergroups`
   ,`method_Vendor` AS `vendor`
   ,`method_Package` AS `package` 
   ,`method_Class` AS `class`
   ,`method_Method` AS `method`
   ,`method_Label` AS `label`
   ,`method_Notes` AS `notes`
  FROM `hpapi_method`
  LEFT JOIN `hpapi_run`
         ON `run_Vendor`=`method_Vendor`
        AND `run_Package`=`method_Package`
        AND `run_Class`=`method_Class`
        AND `run_Method`=`method_Method`
  LEFT JOIN `hpapi_membership`
         ON `membership_Usergroup`=`run_Usergroup`
        AND (
             `membership_Usergroup`='anon'
          OR (
               authenticated>'0'
           AND `membership_User_UUID`=userUUID
          )
        )
  WHERE `membership_Usergroup` IS NOT NULL
  GROUP BY `vendor`,`package`,`class`,`method`
  ORDER BY `vendor`,`package`,`class`,`method`
  ;
END$$



DROP PROCEDURE IF EXISTS `hpapiUsergroups`$$
CREATE PROCEDURE `hpapiUsergroups`(
  IN        `userUUID` CHAR(52) CHARSET ascii
 ,IN        `authenticated` INT(1) UNSIGNED
)
BEGIN
  SELECT
    `usergroup_Usergroup` AS `usergroup`
   ,`usergroup_Name` AS `name` 
   ,`level_Name` AS `securityLevel`
   ,`level_Notes` AS `securityNotes`
  FROM `hpapi_usergroup`
  LEFT JOIN `hpapi_membership`
         ON `membership_Usergroup`=`usergroup_Usergroup`
        AND (
             `membership_Usergroup`='anon'
          OR (
               authenticated>'0'
           AND `membership_User_UUID`=userUUID
          )
        )
  LEFT JOIN `hpapi_level`
         ON `level_Level`=`usergroup_Level`
  WHERE `membership_Usergroup` IS NOT NULL
  ORDER BY `level_Level`
  ;
END$$


DROP PROCEDURE IF EXISTS `hpapiAuthDetails`$$
CREATE PROCEDURE `hpapiAuthDetails`(
  IN        `keyKey` CHAR(52) CHARSET ascii
 ,IN        `emailEmail` VARCHAR(254) CHARSET ascii
)
BEGIN
  SELECT
    `user_UUID` IS NOT NULL AS `userFound` 
   ,`user_Active` AS `userActive` 
   ,`user_Password_Hash` AS `passwordHash` 
   ,`email_User_UUID` IS NOT NULL AS `emailFound` 
   ,`email_Verified` AS `emailVerified` 
  FROM `hpapi_key`
  LEFT JOIN `hpapi_user`
         ON `user_UUID`=`key_User_UUID`
  LEFT JOIN `hpapi_email`
         ON `email_User_UUID`=`user_UUID`
        AND `email_Email`=emailEmail
  WHERE `key_Key`=keyKey
    AND `key_Expired`='0'
  LIMIT 0,1
  ;
END$$


DROP PROCEDURE IF EXISTS `hpapiMethodargs`$$
CREATE PROCEDURE `hpapiMethodargs`(
  IN        `keyKey` CHAR(52) CHARSET ascii
 ,IN        `emailEmail` CHAR(254) CHARSET ascii
 ,IN        `methodVendor` VARCHAR(64) CHARSET ascii
 ,IN        `methodPackage` VARCHAR(64) CHARSET ascii
 ,IN        `methodClass` VARCHAR(64) CHARSET ascii
 ,IN        `methodMethod` VARCHAR(64) CHARSET ascii
)
BEGIN
  SELECT
    `key_Remote_Addr_Pattern` AS `remoteAddrPattern`
   ,`key_User_UUID` AS `userUUID`
   ,`method_Label` AS `label`
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
  FROM `hpapi_method`
  LEFT JOIN `hpapi_methodarg`
         ON `methodarg_Vendor`=`method_Vendor`
        AND `methodarg_Vendor`=methodVendor
        AND `methodarg_Package`=`method_Package`
        AND `methodarg_Package`=methodPackage
        AND `methodarg_Class`=`method_Class`
        AND `methodarg_Class`=methodClass
        AND `methodarg_Method`=`method_Method`
        AND `methodarg_Method`=methodMethod
  LEFT JOIN `hpapi_pattern`
         ON `pattern_Pattern`=`methodarg_Pattern`
  LEFT JOIN `hpapi_key`
         ON `key_Key`=keyKey
  LEFT JOIN `hpapi_user` AS `keycheck`
         ON `keycheck`.`user_Active`='1'
        AND `keycheck`.`user_UUID`=`key_User_UUID`
  LEFT JOIN `hpapi_email`
         ON `email_Email`=emailEmail
  LEFT JOIN `hpapi_user` AS `usrcheck`
         ON `usrcheck`.`user_UUID`=`email_User_UUID`
  LEFT JOIN `hpapi_membership`
         ON `membership_User_UUID`=`usrcheck`.`user_UUID`
  LEFT JOIN `hpapi_run`
         ON (
              `run_Usergroup`=`membership_Usergroup`
           OR `run_Usergroup`='anon'
            )
        AND `run_Vendor`=methodVendor
        AND `run_Package`=methodPackage
        AND `run_Class`=methodClass
        AND `run_Method`=methodMethod
  WHERE `keycheck`.`user_UUID` IS NOT NULL
    AND `run_Usergroup` IS NOT NULL
    AND `method_Vendor`=methodVendor
    AND `method_Package`=methodPackage
    AND `method_Class`=methodClass
    AND `method_Method`=methodMethod
  GROUP BY `method_Vendor`,`method_Package`,`method_Class`,`method_Method`,`methodarg_Argument`
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



DELIMITER ;

