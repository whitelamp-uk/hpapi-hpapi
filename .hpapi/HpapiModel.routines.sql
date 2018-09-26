

SET NAMES utf8;
SET time_zone = '+00:00';


DELIMITER $$


DROP PROCEDURE IF EXISTS `hpapiAuthDetails`$$
CREATE PROCEDURE `hpapiAuthDetails`(
  IN        `ts` INT(11) UNSIGNED
 ,IN        `ky` CHAR(52) CHARSET ascii
 ,IN        `em` VARCHAR(254) CHARSET ascii
)
BEGIN
  SELECT
    `id` AS `userID` 
   ,`active` AS `userActive` 
   ,`password_hash` AS `passwordHash` 
   ,`email` IS NOT NULL AS `emailFound` 
   ,`email_verified` AS `emailVerified` 
   ,`key`
   ,`key_release` AS `respondWithKey`
   ,`hpapi_user`.`remote_addr_pattern` AS `remoteAddrPattern`
  FROM `hpapi_user`
  LEFT JOIN `hpapi_keyrelease`
         ON `keyrelease_user_uuid`=`user_uuid`
  WHERE `email_email`=em
    AND 
    AND `cur_key`.`key_Key`=`user_key`

    AND (
         (`key`=ky AND `key_expired`='0')
      OR (`key_release`>0 AND `key_release_until`>ts)
    )
  LIMIT 0,1
  ;
END$$


DROP PROCEDURE IF EXISTS `hpapiLogRequest`$$
CREATE PROCEDURE `hpapiLogRequest`(
  IN        `dt` VARCHAR(32) CHARSET ascii
 ,IN        `mt` DECIMAL(9,8) UNSIGNED
 ,IN        `ky` VARCHAR(64) CHARSET ascii
 ,IN        `em` VARCHAR(254) CHARSET utf8
 ,IN        `rma` VARCHAR(64) CHARSET ascii
 ,IN        `ua` VARCHAR(255) CHARSET ascii
 ,IN        `vdr` VARCHAR(64) CHARSET ascii
 ,IN        `pkg` VARCHAR(64) CHARSET ascii
 ,IN        `cls` VARCHAR(64) CHARSET ascii
 ,IN        `mtd` VARCHAR(64) CHARSET ascii
 ,IN        `err` VARCHAR(64) CHARSET utf8
 ,IN        `ntc` VARCHAR(64) CHARSET utf8
)
BEGIN
  INSERT INTO `hpapi_log`
  SET
    `datetime`=dt
   ,`microtime`=mt
   ,`key`=ky
   ,`email`=em
   ,`remote_addr`=rma
   ,`user_agent`=ua
   ,`vendor`=vdr
   ,`package`=pkg
   ,`class`=cls
   ,`method`=mtd
   ,`error`=err
   ,`notice`=ntc
  ;
END $$


DROP PROCEDURE IF EXISTS `hpapiMethodargs`$$
CREATE PROCEDURE `hpapiMethodargs`(
  IN        `userID` INT(11) UNSIGNED
 ,IN        `methodVendor` VARCHAR(64) CHARSET ascii
 ,IN        `methodPackage` VARCHAR(64) CHARSET ascii
 ,IN        `methodClass` VARCHAR(64) CHARSET ascii
 ,IN        `methodMethod` VARCHAR(64) CHARSET ascii
)
BEGIN
  SELECT
    `hpapi_method`.`label` AS `label`
   ,`hpapi_method`.`notes` AS `notes`
   ,`hpapi_methodarg`.`argument` AS `argument`
   ,`hpapi_methodarg`.`name` AS `name`
   ,`hpapi_methodarg`.`empty_allowed` AS `emptyAllowed`
   ,`hpapi_pattern`.`pattern` AS `pattern`
   ,`hpapi_pattern`.`constraints` AS `constraints`
   ,`hpapi_pattern`.`expression` AS `expression`
   ,`hpapi_pattern`.`php_filter` AS `phpFilter`
   ,`hpapi_pattern`.`length_minimum` AS `lengthMinimum`
   ,`hpapi_pattern`.`length_maximum` AS `lengthMaximum`
   ,`hpapi_pattern`.`value_minimum` AS `valueMinimum`
   ,`hpapi_pattern`.`value_maximum` AS `valueMaximum`
   ,IFNULL(`ug`.`remote_addr_pattern`,`anon`.`remote_addr_pattern`) AS `remoteAddrPattern`
  FROM `hpapi_method`
  LEFT JOIN `hpapi_methodarg` USING (`vendor`,`package`,`class`,`method`)
  LEFT JOIN `hpapi_pattern` USING (`pattern`)
  LEFT JOIN `hpapi_run` USING (`vendor`,`package`,`class`,`method`)
  LEFT JOIN `hpapi_membership`
         ON `hpapi_membership`.`usergroup`=`hpapi_run`.`usergroup`
        AND `hpapi_membership`.`user_id`=userID
  LEFT JOIN `hpapi_usergroup` AS `ug` USING (`usergroup`)
  LEFT JOIN `hpapi_usergroup` AS `anon`
         ON `anon`.`usergroup`='anon'
  WHERE `hpapi_method`.`vendor`=methodVendor
    AND `hpapi_method`.`package`=methodPackage
    AND `hpapi_method`.`class`=methodClass
    AND `hpapi_method`.`method`=methodMethod
    AND (
        `hpapi_membership`.`user_id` IS NOT NULL
     OR `hpapi_run`.`usergroup`='anon'
    )
  ORDER BY `hpapi_methodarg`.`argument`
  ;
END$$


DROP PROCEDURE IF EXISTS `hpapiSprargs`$$
CREATE PROCEDURE `hpapiSprargs`(
  IN        `vdr` VARCHAR(64) CHARSET ascii
 ,IN        `pkg` VARCHAR(64) CHARSET ascii
 ,IN        `cls` VARCHAR(64) CHARSET ascii
 ,IN        `mtd` VARCHAR(64) CHARSET ascii
)
BEGIN
  SELECT
    `hpapi_sprarg`.`model`
   ,`hpapi_sprarg`.`spr`
   ,`hpapi_sprarg`.`notes`
   ,`hpapi_sprarg`.`argument`
   ,`hpapi_sprarg`.`name`
   ,`hpapi_sprarg`.`empty_allowed` AS `emptyAllowed`
   ,`hpapi_pattern`.`pattern`
   ,`hpapi_pattern`.`constraints`
   ,`hpapi_pattern`.`expression`
   ,`hpapi_pattern`.`php_filter` AS `phpFilter`
   ,`hpapi_pattern`.`length_minimum` AS `lengthMinimum`
   ,`hpapi_pattern`.`length_maximum` AS `lengthMaximum`
   ,`hpapi_pattern`.`value_minimum` AS `valueMinimum`
   ,`hpapi_pattern`.`value_maximum` AS `valueMaximum`
  FROM `hpapi_method`
  LEFT JOIN `hpapi_call` USING (`vendor`,`package`,`class`,`method`)
  LEFT JOIN `hpapi_spr` USING (`model`,`spr`)
  LEFT JOIN `hpapi_sprarg` USING (`model`,`spr`)
  LEFT JOIN `hpapi_pattern` USING (`pattern`)
  WHERE `hpapi_method`.`vendor`=vdr
    AND `hpapi_method`.`package`=pkg
    AND `hpapi_method`.`class`=cls
    AND `hpapi_method`.`method`=mtd
  GROUP BY `hpapi_spr`.`model`,`hpapi_spr`.`spr`,`hpapi_sprarg`.`argument`
  ORDER BY `hpapi_spr`.`model`,`hpapi_spr`.`spr`,`hpapi_sprarg`.`argument`
  ;
END$$


DROP PROCEDURE IF EXISTS `hpapiInsertTestUsers`$$
CREATE PROCEDURE `hpapiInsertTestUsers`(
)
BEGIN
  IF ((SELECT COUNT(`user_id`) FROM `hpapi_user`) = 0) THEN
    INSERT INTO `hpapi_user` (`id`, `active`, `uuid`, `key`, `key_expired`, `key_release`, `key_release_until`, `remote_addr_pattern`, `name`, `notes`, `email`, `email_verified`, `email_fallback`, `email_fallback_verified`, `password_hash`) VALUES
    (1, 1,  '20180720110427::322025bd-8ff2-11e8-902b-001f16148bc1', '20180725104327::0e0f4ce8-8fee-11e8-902b-001f16148bc1', 0,  0,  0,  '^.*$', 'Sysadmin Temp',  'Temporary system administrator', 'sysadmin@no.where',  1,  '', 0,  '20180720110427::322025bd-8ff2-11e8-902b-001f16148bc1'),
    (2, 1,  '20180720110427::57d2eff7-8ff3-11e8-902b-001f16148bc1', '20180720110427::89c56ad8-8ff3-11e8-902b-001f16148bc1', 0,  1,  0,  '^.*$', 'Admin Temp', 'Temporary organisation administrator', 'orgadmin@no.where',  1,  '', 0,  '$2y$10$hLSdApW6.30YLK3ze49uSu7OV0gmS3ZT65pufxDPGiMxsmW3bykeq');
    SELECT 'Inserted test users into hpapi_key, hpapi_user, hpapi_email and hpapi_membership' AS `Completed`;
  ELSE
    SELECT 'Refusing to add test users - rows found in hpapi_user' AS `Refused`;
  END IF
  ;
END$$


DELIMITER ;


