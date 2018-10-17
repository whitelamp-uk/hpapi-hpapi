

SET NAMES utf8;
SET time_zone = '+00:00';


DELIMITER $$


DROP PROCEDURE IF EXISTS `hpapiKeyreleaseRevoke`$$
CREATE PROCEDURE `hpapiKeyreleaseRevoke`(
  IN        `ts` INT(11) UNSIGNED
 ,IN        `ky` VARCHAR(64) CHARSET ascii
)
BEGIN
  UPDATE `hpapi_user`
  SET
    `key_release`=0
  WHERE UNIX_TIMESTAMP(`key_release_until`)<ts
     OR `key`=ky
  ;
END $$


DROP PROCEDURE IF EXISTS `hpapiAuthDetails`$$
CREATE PROCEDURE `hpapiAuthDetails`(
  IN        `em` VARCHAR(254) CHARSET ascii
)
BEGIN
  SELECT
    `id` AS `userID` 
   ,`active` AS `userActive` 
   ,`password_hash` AS `passwordHash` 
   ,`email_verified` AS `emailVerified` 
   ,`key`
   ,`key_expired` AS `keyExpired`
   ,`key_release` AS `respondWithKey`
   ,UNIX_TIMESTAMP(`key_release_until`) AS `keyReleaseUntil`
   ,`hpapi_user`.`remote_addr_pattern` AS `userRemoteAddrPattern`
   ,`hpapi_usergroup`.`usergroup`
   ,`hpapi_usergroup`.`remote_addr_pattern` AS `groupRemoteAddrPattern`
  FROM `hpapi_user`
  LEFT JOIN `hpapi_usergroup`
         ON 1
  LEFT JOIN `hpapi_membership`
         ON `hpapi_membership`.`user_id`=`hpapi_user`.`id`
        AND `hpapi_membership`.`usergroup`=`hpapi_usergroup`.`usergroup`
  WHERE `hpapi_user`.`email`=em
    AND (
         `hpapi_usergroup`.`usergroup`='anon'
      OR `hpapi_membership`.`usergroup` IS NOT NULL
    )
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
  LEFT JOIN `hpapi_usergroup` AS `ug`
         ON `ug`.`usergroup`=`hpapi_membership`.`usergroup`
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
    `hpapi_spr`.`model`
   ,`hpapi_spr`.`spr`
   ,`hpapi_spr`.`notes`
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
  IF ((SELECT COUNT(`id`) FROM `hpapi_user`) = 0) THEN
    INSERT INTO `hpapi_user` (`id`, `active`, `uuid`, `key`, `key_expired`, `key_release`, `key_release_until`, `remote_addr_pattern`, `name`, `notes`, `email`, `email_verified`, `email_fallback`, `email_fallback_verified`, `password_hash`) VALUES
    (1,	1,	'322025bd-8ff2-11e8-902b-001f16148bc1',	'0e0f4ce8-8fee-11e8-902b-001f16148bc1',	0,	0,	'0000-00-00 00:00:00',	'^.*$',	'Sysadmin Temp',	'Temporary system administrator',	'sysadmin@no.where',	1,	'',	0,	'$2y$10$hLSdApW6.30YLK3ze49uSu7OV0gmS3ZT65pufxDPGiMxsmW3bykeq'),
    (2,	1,	'57d2eff7-8ff3-11e8-902b-001f16148bc1',	'89c56ad8-8ff3-11e8-902b-001f16148bc1',	0,	0,	'0000-00-00 00:00:00',	'^.*$',	'Admin Temp',	'Temporary organisation administrator',	'orgadmin@no.where',	1,	'',	0,	'$2y$10$hLSdApW6.30YLK3ze49uSu7OV0gmS3ZT65pufxDPGiMxsmW3bykeq'),
    (3,	1,	'caf791cb-d224-11e8-956a-00165e0004e8',	'caf791fc-d224-11e8-956a-00165e0004e8',	0,	0,	'0000-00-00 00:00:00',	'^.*$',	'Example field staff',	'Example lower-level field staff member',	'test.1@no.where',	1,	'',	1,	'$2y$10$hLSdApW6.30YLK3ze49uSu7OV0gmS3ZT65pufxDPGiMxsmW3bykeq');
    INSERT INTO `hpapi_membership` (`user_id`, `usergroup`) VALUES
    (1,	'sysadmin'),
    (2,	'admin'),
    (3,	'field');
    SELECT 'Inserted test users into hpapi_user and hpapi_membership' AS `Completed`;
  ELSE
    SELECT 'Refusing to add test users - rows found in hpapi_user' AS `Refused`;
  END IF
  ;
END$$

DROP PROCEDURE IF EXISTS `hpapiMethodPrivileges`$$
CREATE PROCEDURE `hpapiMethodPrivileges`(
)
BEGIN
  SELECT
    CONCAT(
      `hpapi_method`.`vendor`
     ,'::'
     ,`hpapi_method`.`package`
     ,'::'
     ,`hpapi_method`.`class`
     ,'::'
     ,`hpapi_method`.`method`
    ) AS `method`
   ,`hpapi_package`.`notes` AS `packageNotes`
   ,`hpapi_method`.`notes` AS `methodNotes`
   ,`hpapi_method`.`label` AS `methodLabel`
   ,`hpapi_methodarg`.`argument` AS `argument`
   ,`hpapi_methodarg`.`name` AS `name`
   ,`hpapi_methodarg`.`empty_allowed` AS `emptyAllowed`
   ,`hpapi_pattern`.`constraints`
   ,`hpapi_pattern`.`expression`
   ,`hpapi_pattern`.`php_filter` AS `phpFilter`
   ,`hpapi_pattern`.`length_minimum` AS `lengthMinimum`
   ,`hpapi_pattern`.`length_maximum` AS `lengthMaximum`
   ,`hpapi_pattern`.`value_minimum` AS `valueMinimum`
   ,`hpapi_pattern`.`value_maximum` AS `valueMaximum`
   ,`hpapi_run`.`usergroup`
  FROM `hpapi_package`
  LEFT JOIN `hpapi_method` USING (`vendor`,`package`)
  LEFT JOIN `hpapi_methodarg` USING (`vendor`,`package`,`class`,`method`)
  LEFT JOIN `hpapi_pattern` USING (`pattern`)
  LEFT JOIN `hpapi_run` USING (`vendor`,`package`,`class`,`method`)
  ORDER BY
      `hpapi_package`.`vendor`
     ,`hpapi_package`.`package`
     ,`hpapi_method`.`class`
     ,`hpapi_method`.`method`
     ,`hpapi_methodarg`.`argument`
  ;
END$$

DROP PROCEDURE IF EXISTS `hpapiSprPrivileges`$$
CREATE PROCEDURE `hpapiSprPrivileges`(
)
BEGIN
  SELECT
    CONCAT(
      `hpapi_method`.`vendor`
     ,'::'
     ,`hpapi_method`.`package`
     ,'::'
     ,`hpapi_method`.`class`
     ,'::'
     ,`hpapi_method`.`method`
    ) AS `method`
   ,`hpapi_model`.`model`
   ,`hpapi_model`.`notes` AS `modelNotes`
   ,`hpapi_spr`.`spr`
   ,`hpapi_spr`.`notes` AS `sprNotes`
   ,`hpapi_sprarg`.`argument`
   ,`hpapi_sprarg`.`name`
   ,`hpapi_sprarg`.`empty_allowed` AS `emptyAllowed`
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
  LEFT JOIN `hpapi_model` USING (`model`)
  LEFT JOIN `hpapi_sprarg` USING (`model`,`spr`)
  LEFT JOIN `hpapi_pattern` USING (`pattern`)
  ORDER BY
      `hpapi_method`.`vendor`
     ,`hpapi_method`.`package`
     ,`hpapi_method`.`class`
     ,`hpapi_method`.`method`
     ,`hpapi_sprarg`.`argument`
  ;
END$$


DELIMITER ;


