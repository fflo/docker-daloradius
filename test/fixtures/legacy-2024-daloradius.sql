-- Test fixture: daloRADIUS database schema as of October 2024
-- (contrib/db/mariadb-daloradius.sql at upstream commit 30988bf2), the state
-- of databases created by the daloRADIUS docker image of that time.
-- The rows of the dictionary table are left out.
-- Used by smoke-test.sh to check that such a database still works.

-- MySQL dump 10.11
--
-- Host: localhost    Database: radius_099
-- ------------------------------------------------------
-- Server version	5.0.51a-24+lenny3-log

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `batch_history`
--

DROP TABLE IF EXISTS `batch_history`;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8mb4;
CREATE TABLE `batch_history` (
  `id` INT(32) NOT NULL AUTO_INCREMENT,
  `batch_name` VARCHAR(64) DEFAULT NULL COMMENT 'an identifier name of the batch instance',
  `batch_description` VARCHAR(256) DEFAULT NULL COMMENT 'general description of the entry',
  `hotspot_id` INT(32) DEFAULT '0' COMMENT 'the hotspot business id associated with this batch instance',
  `batch_status` VARCHAR(128) NOT NULL DEFAULT 'Pending' COMMENT 'the batch status',
  `creationdate` DATETIME DEFAULT '0000-00-00 00:00:00',
  `creationby` VARCHAR(128) DEFAULT NULL,
  `updatedate` DATETIME DEFAULT '0000-00-00 00:00:00',
  `updateby` VARCHAR(128) DEFAULT NULL,
  PRIMARY KEY  (`id`),
  KEY `batch_name` (`batch_name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
SET character_set_client = @saved_cs_client;

--
-- Dumping data for table `batch_history`
--

LOCK TABLES `batch_history` WRITE;
/*!40000 ALTER TABLE `batch_history` DISABLE KEYS */;
/*!40000 ALTER TABLE `batch_history` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `billing_history`
--

DROP TABLE IF EXISTS `billing_history`;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8mb4;
CREATE TABLE `billing_history` (
  `id` INT(8) UNSIGNED NOT NULL AUTO_INCREMENT,
  `username` VARCHAR(128) DEFAULT NULL,
  `planId` INT(32) DEFAULT NULL,
  `billAmount` VARCHAR(200) DEFAULT NULL,
  `billAction` VARCHAR(128) NOT NULL DEFAULT 'Unavailable',
  `billPerformer` VARCHAR(200) DEFAULT NULL,
  `billReason` VARCHAR(200) DEFAULT NULL,
  `paymentmethod` VARCHAR(200) DEFAULT NULL,
  `cash` VARCHAR(200) DEFAULT NULL,
  `creditcardname` VARCHAR(200) DEFAULT NULL,
  `creditcardnumber` VARCHAR(200) DEFAULT NULL,
  `creditcardverification` VARCHAR(200) DEFAULT NULL,
  `creditcardtype` VARCHAR(200) DEFAULT NULL,
  `creditcardexp` VARCHAR(200) DEFAULT NULL,
  `coupon` VARCHAR(200) DEFAULT NULL,
  `discount` VARCHAR(200) DEFAULT NULL,
  `notes` VARCHAR(200) DEFAULT NULL,
  `creationdate` DATETIME DEFAULT '0000-00-00 00:00:00',
  `creationby` VARCHAR(128) DEFAULT NULL,
  `updatedate` DATETIME DEFAULT '0000-00-00 00:00:00',
  `updateby` VARCHAR(128) DEFAULT NULL,
  PRIMARY KEY  (`id`),
  KEY `username` (`username`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
SET character_set_client = @saved_cs_client;

--
-- Dumping data for table `billing_history`
--

LOCK TABLES `billing_history` WRITE;
/*!40000 ALTER TABLE `billing_history` DISABLE KEYS */;
/*!40000 ALTER TABLE `billing_history` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `billing_merchant`
--

DROP TABLE IF EXISTS `billing_merchant`;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8mb4;
CREATE TABLE `billing_merchant` (
  `id` INT(8) NOT NULL AUTO_INCREMENT,
  `username` VARCHAR(128) NOT NULL DEFAULT '',
  `password` VARCHAR(128) NOT NULL DEFAULT '',
  `mac` VARCHAR(200) NOT NULL DEFAULT '',
  `pin` VARCHAR(200) NOT NULL DEFAULT '',
  `txnId` VARCHAR(200) NOT NULL DEFAULT '',
  `planName` VARCHAR(128) NOT NULL DEFAULT '',
  `planId` INT(32) NOT NULL,
  `quantity` VARCHAR(200) NOT NULL DEFAULT '',
  `business_email` VARCHAR(200) NOT NULL DEFAULT '',
  `business_id` VARCHAR(200) NOT NULL DEFAULT '',
  `txn_type` VARCHAR(200) NOT NULL DEFAULT '',
  `txn_id` VARCHAR(200) NOT NULL DEFAULT '',
  `payment_type` VARCHAR(200) NOT NULL DEFAULT '',
  `payment_tax` VARCHAR(200) NOT NULL DEFAULT '',
  `payment_cost` VARCHAR(200) NOT NULL DEFAULT '',
  `payment_fee` VARCHAR(200) NOT NULL DEFAULT '',
  `payment_total` VARCHAR(200) NOT NULL DEFAULT '',
  `payment_currency` VARCHAR(200) NOT NULL DEFAULT '',
  `first_name` VARCHAR(200) NOT NULL DEFAULT '',
  `last_name` VARCHAR(200) NOT NULL DEFAULT '',
  `payer_email` VARCHAR(200) NOT NULL DEFAULT '',
  `payer_address_name` VARCHAR(200) NOT NULL DEFAULT '',
  `payer_address_street` VARCHAR(200) NOT NULL DEFAULT '',
  `payer_address_country` VARCHAR(200) NOT NULL DEFAULT '',
  `payer_address_country_code` VARCHAR(200) NOT NULL DEFAULT '',
  `payer_address_city` VARCHAR(200) NOT NULL DEFAULT '',
  `payer_address_state` VARCHAR(200) NOT NULL DEFAULT '',
  `payer_address_zip` VARCHAR(200) NOT NULL DEFAULT '',
  `payment_date` DATETIME NOT NULL DEFAULT '0000-00-00 00:00:00',
  `payment_status` VARCHAR(200) NOT NULL DEFAULT '',
  `pending_reason` VARCHAR(200) NOT NULL DEFAULT '',
  `reason_code` VARCHAR(200) NOT NULL DEFAULT '',
  `receipt_ID` VARCHAR(200) NOT NULL DEFAULT '',
  `payment_address_status` VARCHAR(200) NOT NULL DEFAULT '',
  `vendor_type` VARCHAR(200) NOT NULL DEFAULT '',
  `payer_status` VARCHAR(200) NOT NULL DEFAULT '',
  PRIMARY KEY  (`id`),
  KEY `username` (`username`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
SET character_set_client = @saved_cs_client;

--
-- Dumping data for table `billing_merchant`
--

LOCK TABLES `billing_merchant` WRITE;
/*!40000 ALTER TABLE `billing_merchant` DISABLE KEYS */;
/*!40000 ALTER TABLE `billing_merchant` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `billing_paypal`
--

DROP TABLE IF EXISTS `billing_paypal`;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8mb4;
CREATE TABLE `billing_paypal` (
  `id` INT(8) NOT NULL AUTO_INCREMENT,
  `username` VARCHAR(128) DEFAULT NULL,
  `password` VARCHAR(128) DEFAULT NULL,
  `mac` VARCHAR(200) DEFAULT NULL,
  `pin` VARCHAR(200) DEFAULT NULL,
  `txnId` VARCHAR(200) DEFAULT NULL,
  `planName` VARCHAR(128) DEFAULT NULL,
  `planId` VARCHAR(200) DEFAULT NULL,
  `quantity` VARCHAR(200) DEFAULT NULL,
  `receiver_email` VARCHAR(200) DEFAULT NULL,
  `business` VARCHAR(200) DEFAULT NULL,
  `tax` VARCHAR(200) DEFAULT NULL,
  `mc_gross` VARCHAR(200) DEFAULT NULL,
  `mc_fee` VARCHAR(200) DEFAULT NULL,
  `mc_currency` VARCHAR(200) DEFAULT NULL,
  `first_name` VARCHAR(200) DEFAULT NULL,
  `last_name` VARCHAR(200) DEFAULT NULL,
  `payer_email` VARCHAR(200) DEFAULT NULL,
  `address_name` VARCHAR(200) DEFAULT NULL,
  `address_street` VARCHAR(200) DEFAULT NULL,
  `address_country` VARCHAR(200) DEFAULT NULL,
  `address_country_code` VARCHAR(200) DEFAULT NULL,
  `address_city` VARCHAR(200) DEFAULT NULL,
  `address_state` VARCHAR(200) DEFAULT NULL,
  `address_zip` VARCHAR(200) DEFAULT NULL,
  `payment_date` DATETIME DEFAULT NULL,
  `payment_status` VARCHAR(200) DEFAULT NULL,
  `payment_address_status` VARCHAR(200) DEFAULT NULL,
  `payer_status` VARCHAR(200) DEFAULT NULL,
  PRIMARY KEY  (`id`),
  KEY `username` (`username`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
SET character_set_client = @saved_cs_client;

--
-- Dumping data for table `billing_paypal`
--

LOCK TABLES `billing_paypal` WRITE;
/*!40000 ALTER TABLE `billing_paypal` DISABLE KEYS */;
/*!40000 ALTER TABLE `billing_paypal` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `billing_plans`
--

DROP TABLE IF EXISTS `billing_plans`;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8mb4;
CREATE TABLE `billing_plans` (
  `id` INT(8) NOT NULL AUTO_INCREMENT,
  `planName` VARCHAR(128) DEFAULT NULL,
  `planId` VARCHAR(128) DEFAULT NULL,
  `planType` VARCHAR(128) DEFAULT NULL,
  `planTimeBank` VARCHAR(128) DEFAULT NULL,
  `planTimeType` VARCHAR(128) DEFAULT NULL,
  `planTimeRefillCost` VARCHAR(128) DEFAULT NULL,
  `planBandwidthUp` VARCHAR(128) DEFAULT NULL,
  `planBandwidthDown` VARCHAR(128) DEFAULT NULL,
  `planTrafficTotal` VARCHAR(128) DEFAULT NULL,
  `planTrafficUp` VARCHAR(128) DEFAULT NULL,
  `planTrafficDown` VARCHAR(128) DEFAULT NULL,
  `planTrafficRefillCost` VARCHAR(128) DEFAULT NULL,
  `planRecurring` VARCHAR(128) DEFAULT NULL,
  `planRecurringPeriod` VARCHAR(128) DEFAULT NULL,
  `planRecurringBillingSchedule` VARCHAR(128) NOT NULL DEFAULT 'Fixed',
  `planCost` VARCHAR(128) DEFAULT NULL,
  `planSetupCost` VARCHAR(128) DEFAULT NULL,
  `planTax` VARCHAR(128) DEFAULT NULL,
  `planCurrency` VARCHAR(128) DEFAULT NULL,
  `planGroup` VARCHAR(128) DEFAULT NULL,
  `planActive` VARCHAR(32) NOT NULL DEFAULT 'yes',
  `creationdate` DATETIME DEFAULT '0000-00-00 00:00:00',
  `creationby` VARCHAR(128) DEFAULT NULL,
  `updatedate` DATETIME DEFAULT '0000-00-00 00:00:00',
  `updateby` VARCHAR(128) DEFAULT NULL,
  PRIMARY KEY  (`id`),
  KEY `planName` (`planName`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
SET character_set_client = @saved_cs_client;

--
-- Dumping data for table `billing_plans`
--

LOCK TABLES `billing_plans` WRITE;
/*!40000 ALTER TABLE `billing_plans` DISABLE KEYS */;
/*!40000 ALTER TABLE `billing_plans` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `billing_plans_profiles`
--

DROP TABLE IF EXISTS `billing_plans_profiles`;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8mb4;
CREATE TABLE `billing_plans_profiles` (
  `id` INT(32) NOT NULL AUTO_INCREMENT,
  `plan_name` VARCHAR(128) NOT NULL COMMENT 'the name of the plan',
  `profile_name` VARCHAR(256) DEFAULT NULL COMMENT 'the profile/group name',
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
SET character_set_client = @saved_cs_client;

--
-- Dumping data for table `billing_plans_profiles`
--

LOCK TABLES `billing_plans_profiles` WRITE;
/*!40000 ALTER TABLE `billing_plans_profiles` DISABLE KEYS */;
/*!40000 ALTER TABLE `billing_plans_profiles` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `billing_rates`
--

DROP TABLE IF EXISTS `billing_rates`;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8mb4;
CREATE TABLE `billing_rates` (
  `id` INT(11) UNSIGNED NOT NULL AUTO_INCREMENT,
  `rateName` VARCHAR(128) NOT NULL DEFAULT '',
  `rateType` VARCHAR(128) NOT NULL DEFAULT '',
  `rateCost` INT(32) NOT NULL DEFAULT '0',
  `creationdate` DATETIME DEFAULT '0000-00-00 00:00:00',
  `creationby` VARCHAR(128) DEFAULT NULL,
  `updatedate` DATETIME DEFAULT '0000-00-00 00:00:00',
  `updateby` VARCHAR(128) DEFAULT NULL,
  PRIMARY KEY  (`id`),
  KEY `rateName` (`rateName`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
SET character_set_client = @saved_cs_client;

--
-- Dumping data for table `billing_rates`
--

LOCK TABLES `billing_rates` WRITE;
/*!40000 ALTER TABLE `billing_rates` DISABLE KEYS */;
/*!40000 ALTER TABLE `billing_rates` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `dictionary`
--

DROP TABLE IF EXISTS `dictionary`;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8mb4;
CREATE TABLE `dictionary` (
  `id` INT(10) NOT NULL AUTO_INCREMENT,
  `Type` VARCHAR(30) DEFAULT NULL,
  `Attribute` VARCHAR(64) DEFAULT NULL,
  `Value` VARCHAR(64) DEFAULT NULL,
  `Format` VARCHAR(20) DEFAULT NULL,
  `Vendor` VARCHAR(32) DEFAULT NULL,
  `RecommendedOP` VARCHAR(32) DEFAULT NULL,
  `RecommendedTable` VARCHAR(32) DEFAULT NULL,
  `RecommendedHelper` VARCHAR(32) DEFAULT NULL,
  `RecommendedTooltip` VARCHAR(512) DEFAULT NULL,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=9718 DEFAULT CHARSET=utf8mb4;
SET character_set_client = @saved_cs_client;

--
-- Dumping data for table `dictionary`
--

LOCK TABLES `dictionary` WRITE;
/*!40000 ALTER TABLE `dictionary` DISABLE KEYS */;
/*!40000 ALTER TABLE `dictionary` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `hotspots`
--

DROP TABLE IF EXISTS `hotspots`;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8mb4;
CREATE TABLE `hotspots` (
  `id` BIGINT(20) NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(200) DEFAULT NULL,
  `mac` VARCHAR(200) DEFAULT NULL,
  `geocode` VARCHAR(200) DEFAULT NULL,
  `owner` VARCHAR(200) DEFAULT NULL,
  `email_owner` VARCHAR(200) DEFAULT NULL,
  `manager` VARCHAR(200) DEFAULT NULL,
  `email_manager` VARCHAR(200) DEFAULT NULL,
  `address` VARCHAR(200) DEFAULT NULL,
  `company` VARCHAR(200) DEFAULT NULL,
  `phone1` VARCHAR(200) DEFAULT NULL,
  `phone2` VARCHAR(200) DEFAULT NULL,
  `type` VARCHAR(200) DEFAULT NULL,
  `companywebsite` VARCHAR(200) DEFAULT NULL,
  `companyemail` VARCHAR(200) DEFAULT NULL,
  `companycontact` VARCHAR(200) DEFAULT NULL,
  `companyphone` VARCHAR(200) DEFAULT NULL,
  `creationdate` DATETIME DEFAULT '0000-00-00 00:00:00',
  `creationby` VARCHAR(128) DEFAULT NULL,
  `updatedate` DATETIME DEFAULT '0000-00-00 00:00:00',
  `updateby` VARCHAR(128) DEFAULT NULL,
  PRIMARY KEY  (`id`),
  KEY `name` (`name`),
  KEY `mac` (`mac`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
SET character_set_client = @saved_cs_client;

--
-- Dumping data for table `hotspots`
--

LOCK TABLES `hotspots` WRITE;
/*!40000 ALTER TABLE `hotspots` DISABLE KEYS */;
/*!40000 ALTER TABLE `hotspots` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `invoice`
--

DROP TABLE IF EXISTS `invoice`;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8mb4;
CREATE TABLE `invoice` (
  `id` INT(32) NOT NULL AUTO_INCREMENT,
  `user_id` INT(32) DEFAULT NULL COMMENT 'user id of the userbillinfo table',
  `batch_id` INT(32) DEFAULT NULL COMMENT 'batch id of the batch_history table',
  `date` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `status_id` INT(10) NOT NULL DEFAULT '1' COMMENT 'the status of the invoice from invoice_status',
  `type_id` INT(10) NOT NULL DEFAULT '1' COMMENT 'the type of the invoice from invoice_type',
  `notes` VARCHAR(128) NOT NULL COMMENT 'general notes/description',
  `creationdate` DATETIME DEFAULT '0000-00-00 00:00:00',
  `creationby` VARCHAR(128) DEFAULT NULL,
  `updatedate` DATETIME DEFAULT '0000-00-00 00:00:00',
  `updateby` VARCHAR(128) DEFAULT NULL,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
SET character_set_client = @saved_cs_client;

--
-- Dumping data for table `invoice`
--

LOCK TABLES `invoice` WRITE;
/*!40000 ALTER TABLE `invoice` DISABLE KEYS */;
/*!40000 ALTER TABLE `invoice` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `invoice_items`
--

DROP TABLE IF EXISTS `invoice_items`;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8mb4;
CREATE TABLE `invoice_items` (
  `id` INT(32) NOT NULL AUTO_INCREMENT,
  `invoice_id` INT(32) NOT NULL COMMENT 'invoice id of the invoices table',
  `plan_id` INT(32) DEFAULT NULL COMMENT 'the plan_id of the billing_plans table',
  `amount` DECIMAL(10,2) NOT NULL DEFAULT '0.00' COMMENT 'the amount cost of an item',
  `tax_amount` DECIMAL(10,2) NOT NULL DEFAULT '0.00' COMMENT 'the tax amount for an item',
  `total` DECIMAL(10,2) NOT NULL DEFAULT '0.00' COMMENT 'the total amount',
  `notes` VARCHAR(128) NOT NULL COMMENT 'general notes/description',
  `creationdate` DATETIME DEFAULT '0000-00-00 00:00:00',
  `creationby` VARCHAR(128) DEFAULT NULL,
  `updatedate` DATETIME DEFAULT '0000-00-00 00:00:00',
  `updateby` VARCHAR(128) DEFAULT NULL,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
SET character_set_client = @saved_cs_client;

--
-- Dumping data for table `invoice_items`
--

LOCK TABLES `invoice_items` WRITE;
/*!40000 ALTER TABLE `invoice_items` DISABLE KEYS */;
/*!40000 ALTER TABLE `invoice_items` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `invoice_status`
--

DROP TABLE IF EXISTS `invoice_status`;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8mb4;
CREATE TABLE `invoice_status` (
  `id` INT(10) NOT NULL AUTO_INCREMENT,
  `value` VARCHAR(32) NOT NULL DEFAULT '' COMMENT 'status value',
  `notes` VARCHAR(128) NOT NULL COMMENT 'general notes/description',
  `creationdate` DATETIME DEFAULT '0000-00-00 00:00:00',
  `creationby` VARCHAR(128) DEFAULT NULL,
  `updatedate` DATETIME DEFAULT '0000-00-00 00:00:00',
  `updateby` VARCHAR(128) DEFAULT NULL,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8mb4;
SET character_set_client = @saved_cs_client;

--
-- Dumping data for table `invoice_status`
--

LOCK TABLES `invoice_status` WRITE;
/*!40000 ALTER TABLE `invoice_status` DISABLE KEYS */;
INSERT INTO `invoice_status` VALUES (1,'open','','2010-05-27 00:00:00','operator','2010-05-27 00:00:00','operator'),
                                    (2,'disputed','','2010-05-27 00:00:00','operator','2010-05-27 00:00:00','operator'),
                                    (3,'draft','','2010-05-27 00:00:00','operator','2010-05-27 00:00:00','operator'),
                                    (4,'sent','','2010-05-27 00:00:00','operator','2010-05-27 00:00:00','operator'),
                                    (5,'paid','','2010-05-27 00:00:00','operator','2010-05-27 00:00:00','operator'),
                                    (6,'partial','','2010-05-27 00:00:00','operator','2010-05-27 00:00:00','operator');
/*!40000 ALTER TABLE `invoice_status` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `invoice_type`
--

DROP TABLE IF EXISTS `invoice_type`;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8mb4;
CREATE TABLE `invoice_type` (
  `id` INT(10) NOT NULL AUTO_INCREMENT,
  `value` VARCHAR(32) NOT NULL DEFAULT '' COMMENT 'type value',
  `notes` VARCHAR(128) NOT NULL COMMENT 'general notes/description',
  `creationdate` DATETIME DEFAULT '0000-00-00 00:00:00',
  `creationby` VARCHAR(128) DEFAULT NULL,
  `updatedate` DATETIME DEFAULT '0000-00-00 00:00:00',
  `updateby` VARCHAR(128) DEFAULT NULL,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4;
SET character_set_client = @saved_cs_client;

--
-- Dumping data for table `invoice_type`
--

LOCK TABLES `invoice_type` WRITE;
/*!40000 ALTER TABLE `invoice_type` DISABLE KEYS */;
INSERT INTO `invoice_type` VALUES (1,'Plans','','2010-05-27 00:00:00','operator','2010-05-27 00:00:00','operator'),
                                  (2,'Services','','2010-05-27 00:00:00','operator','2010-05-27 00:00:00','operator'),
                                  (3,'Consulting','','2010-05-27 00:00:00','operator','2010-05-27 00:00:00','operator');
/*!40000 ALTER TABLE `invoice_type` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `node`
--

DROP TABLE IF EXISTS `node`;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8mb4;
CREATE TABLE `node` (
  `id` INT(11) NOT NULL AUTO_INCREMENT,
  `time` DATETIME NOT NULL DEFAULT '0000-00-00 00:00:00' COMMENT 'Time of last checkin',
  `netid` INT(11) NOT NULL,
  `name` VARCHAR(100) NOT NULL,
  `description` VARCHAR(100) NOT NULL,
  `latitude` VARCHAR(20) NOT NULL,
  `longitude` VARCHAR(20) NOT NULL,
  `owner_name` VARCHAR(50) NOT NULL COMMENT 'node owner''s name',
  `owner_email` VARCHAR(50) NOT NULL COMMENT 'node owner''s email address',
  `owner_phone` VARCHAR(25) NOT NULL COMMENT 'node owner''s phone number',
  `owner_address` VARCHAR(100) NOT NULL COMMENT 'node owner''s address',
  `approval_status` VARCHAR(1) NOT NULL COMMENT 'approval status: A (accepted), R (rejected), P (pending)',
  `ip` VARCHAR(20) NOT NULL COMMENT 'ROBIN',
  `mac` VARCHAR(20) NOT NULL COMMENT 'ROBIN',
  `uptime` VARCHAR(100) NOT NULL COMMENT 'ROBIN',
  `robin` VARCHAR(20) NOT NULL COMMENT 'ROBIN: robin version',
  `batman` VARCHAR(20) NOT NULL COMMENT 'ROBIN: batman version',
  `memfree` VARCHAR(20) NOT NULL COMMENT 'ROBIN',
  `nbs` MEDIUMTEXT NOT NULL COMMENT 'ROBIN: neighbor list',
  `gateway` VARCHAR(20) NOT NULL COMMENT 'ROBIN: nearest gateway',
  `gw-qual` VARCHAR(20) NOT NULL COMMENT 'ROBIN: quality of nearest gateway',
  `routes` MEDIUMTEXT NOT NULL COMMENT 'ROBIN: route to nearest gateway',
  `users` CHAR(3) NOT NULL COMMENT 'ROBIN: current number of users',
  `kbdown` VARCHAR(20) NOT NULL COMMENT 'ROBIN: downloaded kb',
  `kbup` VARCHAR(20) NOT NULL COMMENT 'ROBIN: uploaded kb',
  `hops` VARCHAR(3) NOT NULL COMMENT 'ROBIN: hops to gateway',
  `rank` VARCHAR(3) NOT NULL COMMENT 'ROBIN: ???, not currently used for anything',
  `ssid` VARCHAR(20) NOT NULL COMMENT 'ROBIN: ssid, not currently used for anything',
  `pssid` VARCHAR(20) NOT NULL COMMENT 'ROBIN: pssid, not currently used for anything',
  `gateway_bit` TINYINT(1) NOT NULL COMMENT 'ROBIN derivation: is this node a gateway?',
  `memlow` VARCHAR(20) NOT NULL COMMENT 'ROBIN derivation: lowest reported memory on the node',
  `usershi` CHAR(3) NOT NULL COMMENT 'ROBIN derivation: highest number of users',
  `cpu` FLOAT NOT NULL DEFAULT '0',
  `wan_iface` VARCHAR(128) DEFAULT NULL,
  `wan_ip` VARCHAR(128) DEFAULT NULL,
  `wan_mac` VARCHAR(128) DEFAULT NULL,
  `wan_gateway` VARCHAR(128) DEFAULT NULL,
  `wifi_iface` VARCHAR(128) DEFAULT NULL,
  `wifi_ip` VARCHAR(128) DEFAULT NULL,
  `wifi_mac` VARCHAR(128) DEFAULT NULL,
  `wifi_ssid` VARCHAR(128) DEFAULT NULL,
  `wifi_key` VARCHAR(128) DEFAULT NULL,
  `wifi_channel` VARCHAR(128) DEFAULT NULL,
  `lan_iface` VARCHAR(128) DEFAULT NULL,
  `lan_mac` VARCHAR(128) DEFAULT NULL,
  `lan_ip` VARCHAR(128) DEFAULT NULL,
  `wan_bup` VARCHAR(128) DEFAULT NULL,
  `wan_bdown` VARCHAR(128) DEFAULT NULL,
  `firmware` VARCHAR(128) DEFAULT NULL,
  `firmware_revision` VARCHAR(128) DEFAULT NULL,
  PRIMARY KEY  (`id`),
  UNIQUE KEY `mac` (`mac`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='node database';
SET character_set_client = @saved_cs_client;

--
-- Dumping data for table `node`
--

LOCK TABLES `node` WRITE;
/*!40000 ALTER TABLE `node` DISABLE KEYS */;
/*!40000 ALTER TABLE `node` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `operators`
--

DROP TABLE IF EXISTS `operators`;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8mb4;
CREATE TABLE `operators` (
  `id` INT(32) NOT NULL AUTO_INCREMENT,
  `username` VARCHAR(32) NOT NULL,
  `password` VARCHAR(32) NOT NULL,
  `firstname` VARCHAR(32) NOT NULL,
  `lastname` VARCHAR(32) NOT NULL,
  `title` VARCHAR(32) NOT NULL,
  `department` VARCHAR(32) NOT NULL,
  `company` VARCHAR(32) NOT NULL,
  `phone1` VARCHAR(32) NOT NULL,
  `phone2` VARCHAR(32) NOT NULL,
  `email1` VARCHAR(32) NOT NULL,
  `email2` VARCHAR(32) NOT NULL,
  `messenger1` VARCHAR(32) NOT NULL,
  `messenger2` VARCHAR(32) NOT NULL,
  `notes` VARCHAR(128) NOT NULL,
  `lastlogin` DATETIME DEFAULT '0000-00-00 00:00:00',
  `creationdate` DATETIME DEFAULT '0000-00-00 00:00:00',
  `creationby` VARCHAR(128) DEFAULT NULL,
  `updatedate` DATETIME DEFAULT '0000-00-00 00:00:00',
  `updateby` VARCHAR(128) DEFAULT NULL,
  PRIMARY KEY  (`id`),
  KEY `username` (`username`)
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8mb4;
SET character_set_client = @saved_cs_client;

--
-- Dumping data for table `operators`
--

LOCK TABLES `operators` WRITE;
/*!40000 ALTER TABLE `operators` DISABLE KEYS */;
INSERT INTO `operators` VALUES (6,'administrator','radius','','','','','','','','','','','','','2009-12-07 20:13:20','2009-12-07 20:12:33','admin','2009-12-07 20:14:01','administrator');
/*!40000 ALTER TABLE `operators` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `operators_acl`
--

DROP TABLE IF EXISTS `operators_acl`;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8mb4;
CREATE TABLE `operators_acl` (
  `id` INT(32) NOT NULL AUTO_INCREMENT,
  `operator_id` INT(32) NOT NULL,
  `file` VARCHAR(128) NOT NULL,
  `access` TINYINT(8) NOT NULL DEFAULT '0',
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=252 DEFAULT CHARSET=utf8mb4;
SET character_set_client = @saved_cs_client;

--
-- Dumping data for table `operators_acl`
--

LOCK TABLES `operators_acl` WRITE;
/*!40000 ALTER TABLE `operators_acl` DISABLE KEYS */;
INSERT INTO `operators_acl` VALUES (114, 6, 'acct_custom_query', 1),
                                   (115, 6, 'acct_active', 1),
                                   (116, 6, 'acct_all', 1),
                                   (117, 6, 'acct_ipaddress', 1),
                                   (118, 6, 'acct_username', 1),
                                   (119, 6, 'acct_date', 1),
                                   (120, 6, 'acct_nasipaddress', 1),
                                   (121, 6, 'acct_hotspot_accounting', 1),
                                   (122, 6, 'acct_hotspot_compare', 1),
                                   (123, 6, 'acct_maintenance_cleanup', 1),
                                   (124, 6, 'acct_maintenance_delete', 1),
                                   (125, 6, 'acct_plans_usage', 1),
                                   (126, 6, 'bill_history_query', 1),
                                   (127, 6, 'bill_merchant_transactions', 1),
                                   (128, 6, 'bill_plans_list', 1),
                                   (129, 6, 'bill_plans_del', 1),
                                   (130, 6, 'bill_plans_edit', 1),
                                   (131, 6, 'bill_plans_new', 1),
                                   (132, 6, 'bill_pos_del', 1),
                                   (133, 6, 'bill_pos_list', 1),
                                   (134, 6, 'bill_pos_new', 1),
                                   (135, 6, 'bill_pos_edit', 1),
                                   (136, 6, 'bill_rates_date', 1),
                                   (137, 6, 'bill_rates_new', 1),
                                   (138, 6, 'bill_rates_list', 1),
                                   (139, 6, 'bill_rates_del', 1),
                                   (140, 6, 'bill_rates_edit', 1),
                                   (141, 6, 'config_backup_managebackups', 1),
                                   (142, 6, 'config_backup_createbackups', 1),
                                   (143, 6, 'config_user', 1),
                                   (144, 6, 'config_db', 1),
                                   (145, 6, 'config_lang', 1),
                                   (146, 6, 'config_interface', 1),
                                   (147, 6, 'config_logging', 1),
                                   (148, 6, 'config_maint_test_user', 1),
                                   (149, 6, 'config_maint_disconnect_user', 1),
                                   (150, 6, 'config_operators_list', 1),
                                   (151, 6, 'config_operators_new', 1),
                                   (152, 6, 'config_operators_del', 1),
                                   (153, 6, 'config_operators_edit', 1),
                                   (154, 6, 'gis_editmap', 1),
                                   (155, 6, 'gis_viewmap', 1),
                                   (156, 6, 'graphs_alltime_logins', 1),
                                   (157, 6, 'graphs_overall_download', 1),
                                   (158, 6, 'graphs_overall_logins', 1),
                                   (159, 6, 'graphs_alltime_traffic_compare', 1),
                                   (160, 6, 'graphs_overall_upload', 1),
                                   (161, 6, 'graphs_logged_users', 1),
                                   (162, 6, 'mng_rad_attributes_import', 1),
                                   (163, 6, 'mng_rad_attributes_list', 1),
                                   (164, 6, 'mng_rad_attributes_edit', 1),
                                   (165, 6, 'mng_rad_attributes_del', 1),
                                   (166, 6, 'mng_rad_attributes_new', 1),
                                   (167, 6, 'mng_rad_attributes_search', 1),
                                   (168, 6, 'mng_rad_groupcheck_new', 1),
                                   (169, 6, 'mng_rad_groupreply_search', 1),
                                   (170, 6, 'mng_rad_groupreply_list', 1),
                                   (171, 6, 'mng_rad_groupreply_edit', 1),
                                   (172, 6, 'mng_rad_groupcheck_search', 1),
                                   (173, 6, 'mng_rad_groupcheck_list', 1),
                                   (174, 6, 'mng_rad_groupcheck_edit', 1),
                                   (175, 6, 'mng_rad_groupreply_del', 1),
                                   (176, 6, 'mng_rad_groupreply_new', 1),
                                   (177, 6, 'mng_rad_groupcheck_del', 1),
                                   (178, 6, 'mng_hs_edit', 1),
                                   (179, 6, 'mng_hs_list', 1),
                                   (180, 6, 'mng_hs_del', 1),
                                   (181, 6, 'mng_hs_new', 1),
                                   (182, 6, 'mng_rad_ippool_new', 1),
                                   (183, 6, 'mng_rad_ippool_del', 1),
                                   (184, 6, 'mng_rad_ippool_list', 1),
                                   (185, 6, 'mng_rad_ippool_edit', 1),
                                   (186, 6, 'mng_rad_nas_edit', 1),
                                   (187, 6, 'mng_rad_nas_list', 1),
                                   (188, 6, 'mng_rad_nas_del', 1),
                                   (189, 6, 'mng_rad_nas_new', 1),
                                   (190, 6, 'mng_rad_profiles_edit', 1),
                                   (191, 6, 'mng_rad_profiles_del', 1),
                                   (192, 6, 'mng_rad_profiles_new', 1),
                                   (193, 6, 'mng_rad_profiles_duplicate', 1),
                                   (194, 6, 'mng_rad_profiles_list', 1),
                                   (195, 6, 'mng_rad_proxys_new', 1),
                                   (196, 6, 'mng_rad_proxys_del', 1),
                                   (197, 6, 'mng_rad_proxys_list', 1),
                                   (198, 6, 'mng_rad_proxys_edit', 1),
                                   (199, 6, 'mng_rad_realms_new', 1),
                                   (200, 6, 'mng_rad_realms_del', 1),
                                   (201, 6, 'mng_rad_realms_list', 1),
                                   (202, 6, 'mng_rad_realms_edit', 1),
                                   (203, 6, 'mng_rad_usergroup_edit', 1),
                                   (204, 6, 'mng_rad_usergroup_list_user', 1),
                                   (205, 6, 'mng_rad_usergroup_del', 1),
                                   (206, 6, 'mng_rad_usergroup_new', 1),
                                   (207, 6, 'mng_rad_usergroup_list', 1),
                                   (208, 6, 'mng_search', 1),
                                   (209, 6, 'mng_del', 1),
                                   (210, 6, 'mng_new', 1),
                                   (211, 6, 'mng_import_users', 1),
                                   (212, 6, 'mng_batch', 1),
                                   (213, 6, 'mng_edit', 1),
                                   (214, 6, 'mng_new_quick', 1),
                                   (215, 6, 'mng_list_all', 1),
                                   (216, 6, 'rep_lastconnect', 1),
                                   (217, 6, 'rep_online', 1),
                                   (218, 6, 'rep_history', 1),
                                   (219, 6, 'rep_topusers', 1),
                                   (220, 6, 'rep_logs_radius', 1),
                                   (221, 6, 'rep_logs_boot', 1),
                                   (222, 6, 'rep_logs_system', 1),
                                   (223, 6, 'rep_logs_daloradius', 1),
                                   (224, 6, 'rep_stat_services', 1),
                                   (225, 6, 'rep_stat_server', 1),
                                   (226, 6, 'mng_rad_hunt_del', 1),
                                   (227, 6, 'mng_rad_hunt_edit', 1),
                                   (228, 6, 'mng_rad_hunt_list', 1),
                                   (229, 6, 'mng_rad_hunt_new', 1),
                                   (231, 6, 'mng_batch_add', 1),
                                   (232, 6, 'mng_batch_list', 1),
                                   (233, 6, 'mng_batch_del', 1),
                                   (234, 6, 'bill_invoice_list', 1),
                                   (235, 6, 'bill_invoice_new', 1),
                                   (236, 6, 'bill_invoice_edit', 1),
                                   (237, 6, 'bill_invoice_del', 1),
                                   (238, 6, 'bill_payment_types_new', 1),
                                   (239, 6, 'bill_payment_types_edit', 1),
                                   (240, 6, 'bill_payment_types_list', 1),
                                   (241, 6, 'bill_payment_types_del', 1),
                                   (242, 6, 'bill_payments_list', 1),
                                   (243, 6, 'bill_payments_edit', 1),
                                   (244, 6, 'bill_payments_new', 1),
                                   (245, 6, 'bill_payments_del', 1),
                                   (246, 6, 'rep_newusers', 1),
                                   (247, 6, 'bill_invoice_report', 1),
                                   (248, 6, 'config_reports_dashboard', 1),
                                   (249, 6, 'rep_stat_ups', 1),
                                   (250, 6, 'rep_stat_raid', 1),
                                   (251, 6, 'config_crontab', 1),
                                   (252, 6, 'config_mail_settings', 1),
                                   (253, 6, 'config_mail_testing', 1);
/*!40000 ALTER TABLE `operators_acl` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `operators_acl_files`
--

DROP TABLE IF EXISTS `operators_acl_files`;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8mb4;
CREATE TABLE `operators_acl_files` (
  `id` INT(32) NOT NULL AUTO_INCREMENT,
  `file` VARCHAR(128) NOT NULL,
  `category` VARCHAR(128) NOT NULL,
  `section` VARCHAR(128) NOT NULL,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=140 DEFAULT CHARSET=utf8mb4;
SET character_set_client = @saved_cs_client;

--
-- Dumping data for table `operators_acl_files`
--

LOCK TABLES `operators_acl_files` WRITE;
/*!40000 ALTER TABLE `operators_acl_files` DISABLE KEYS */;
INSERT INTO `operators_acl_files` VALUES (2,'mng_search','Management','Users'),(3,'mng_batch','Management','Users'),(4,'mng_del','Management','Users'),(5,'mng_edit','Management','Users'),(6,'mng_new','Management','Users'),(7,'mng_new_quick','Management','Users'),(8,'mng_import_users','Management','Users'),(9,'mng_list_all','Management','Users'),(10,'mng_hs_del','Management','Hotspot'),(11,'mng_hs_edit','Management','Hotspot'),(12,'mng_hs_new','Management','Hotspot'),(13,'mng_hs_list','Management','Hotspot'),(14,'mng_rad_nas_del','Management','NAS'),(15,'mng_rad_nas_edit','Management','NAS'),(16,'mng_rad_nas_new','Management','NAS'),(17,'mng_rad_nas_list','Management','NAS'),(18,'mng_rad_usergroup_del','Management','UserGroup'),(19,'mng_rad_usergroup_edit','Management','UserGroup'),(20,'mng_rad_usergroup_new','Management','UserGroup'),(21,'mng_rad_usergroup_list_user','Management','UserGroup'),(22,'mng_rad_usergroup_list','Management','UserGroup'),(23,'mng_rad_groupcheck_search','Management','Groups'),(24,'mng_rad_groupcheck_del','Management','Groups'),(25,'mng_rad_groupcheck_list','Management','Groups'),(26,'mng_rad_groupcheck_new','Management','Groups'),(27,'mng_rad_groupcheck_edit','Management','Groups'),(28,'mng_rad_groupreply_search','Management','Groups'),(29,'mng_rad_groupreply_del','Management','Groups'),(30,'mng_rad_groupreply_list','Management','Groups'),(31,'mng_rad_groupreply_new','Management','Groups'),(32,'mng_rad_groupreply_edit','Management','Groups'),(33,'mng_rad_profiles_new','Management','Profiles'),(34,'mng_rad_profiles_edit','Management','Profiles'),(35,'mng_rad_profiles_duplicate','Management','Profiles'),(36,'mng_rad_profiles_del','Management','Profiles'),(37,'mng_rad_profiles_list','Management','Profiles'),(38,'mng_rad_attributes_list','Management','Attributes'),(39,'mng_rad_attributes_new','Management','Attributes'),(40,'mng_rad_attributes_edit','Management','Attributes'),(41,'mng_rad_attributes_search','Management','Attributes'),(42,'mng_rad_attributes_del','Management','Attributes'),(43,'mng_rad_attributes_import','Management','Attributes'),(44,'mng_rad_realms_list','Management','Realms'),(45,'mng_rad_realms_new','Management','Realms'),(46,'mng_rad_realms_edit','Management','Realms'),(47,'mng_rad_realms_del','Management','Realms'),(48,'mng_rad_proxys_list','Management','Proxys'),(49,'mng_rad_proxys_new','Management','Proxys'),(50,'mng_rad_proxys_edit','Management','Proxys'),(51,'mng_rad_proxys_del','Management','Proxys'),(52,'mng_rad_ippool_list','Management','IPPool'),(53,'mng_rad_ippool_new','Management','IPPool'),(54,'mng_rad_ippool_edit','Management','IPPool'),(55,'mng_rad_ippool_del','Management','IPPool'),(56,'rep_topusers','Reporting','Core'),(57,'rep_online','Reporting','Core'),(58,'rep_lastconnect','Reporting','Core'),(59,'rep_history','Reporting','Core'),(60,'rep_logs_radius','Reporting','Logs'),(61,'rep_logs_system','Reporting','Logs'),(62,'rep_logs_boot','Reporting','Logs'),(63,'rep_logs_daloradius','Reporting','Logs'),(64,'rep_stat_services','Reporting','Status'),(65,'rep_stat_server','Reporting','Status'),(66,'acct_active','Accounting','General'),(67,'acct_username','Accounting','General'),(68,'acct_all','Accounting','General'),(69,'acct_date','Accounting','General'),(70,'acct_ipaddress','Accounting','General'),(71,'acct_nasipaddress','Accounting','General'),(72,'acct_hotspot_accounting','Accounting','Hotspot'),(73,'acct_hotspot_compare','Accounting','Hotspot'),(74,'acct_custom_query','Accounting','Custom'),(75,'acct_maintenance_cleanup','Accounting','Maintenance'),(76,'acct_maintenance_delete','Accounting','Maintenance'),(77,'bill_pos_del','Billing','POS'),(78,'bill_pos_new','Billing','POS'),(79,'bill_pos_list','Billing','POS'),(80,'bill_pos_edit','Billing','POS'),(81,'bill_rates_date','Billing','Rates'),(82,'bill_rates_del','Billing','Rates'),(83,'bill_rates_new','Billing','Rates'),(84,'bill_rates_edit','Billing','Rates'),(85,'bill_rates_list','Billing','Rates'),(86,'bill_merchant_transactions','Billing','Merchant'),(87,'bill_plans_del','Billing','Plans'),(88,'bill_plans_new','Billing','Plans'),(89,'bill_plans_edit','Billing','Plans'),(90,'bill_plans_list','Billing','Plans'),(91,'bill_history_query','Billing','History'),(92,'gis_editmap','GIS','General'),(93,'gis_viewmap','GIS','General'),(94,'graphs_alltime_logins','Graphs','General'),(95,'graphs_alltime_traffic_compare','Graphs','General'),(96,'graphs_overall_download','Graphs','General'),(97,'graphs_overall_upload','Graphs','General'),(98,'graphs_overall_logins','Graphs','General'),(99,'graphs_logged_users','Graphs','General'),(100,'config_db','Configuration','Core'),(101,'config_interface','Configuration','Core'),(102,'config_lang','Configuration','Core'),(103,'config_logging','Configuration','Core'),(104,'config_maint_test_user','Configuration','Maintenance'),(105,'config_maint_disconnect_user','Configuration','Maintenance'),(106,'config_operators_del','Configuration','Operators'),(107,'config_operators_list','Configuration','Operators'),(108,'config_operators_edit','Configuration','Operators'),(109,'config_operators_new','Configuration','Operators'),(110,'config_backup_createbackups','Configuration','Backup'),(111,'config_backup_managebackups','Configuration','Backup'),(112,'acct_plans_usage','Accounting','Plans'),(113,'config_user','Configuration','Core'),(114,'mng_rad_hunt_del','Management','HuntGroups'),(115,'mng_rad_hunt_edit','Management','HuntGroups'),(116,'mng_rad_hunt_list','Management','HuntGroups'),(117,'mng_rad_hunt_new','Management','HuntGroups'),(118,'config_mail','Configuration','Core'),(119,'mng_batch_add','Management','Batch'),(120,'mng_batch_list','Management','Batch'),(121,'mng_batch_del','Management','Batch'),(122,'bill_invoice_list','Billing','Invoice'),(123,'bill_invoice_new','Billing','Invoice'),(124,'bill_invoice_edit','Billing','Invoice'),(125,'bill_invoice_del','Billing','Invoice'),(126,'bill_payment_types_new','Billing','Payment Types'),(127,'bill_payment_types_edit','Billing','Payment Types'),(128,'bill_payment_types_list','Billing','Payment Types'),(129,'bill_payment_types_del','Billing','Payment Types'),(130,'bill_payments_list','Billing','Payments'),(131,'bill_payments_edit','Billing','Payments'),(132,'bill_payments_new','Billing','Payments'),(133,'bill_payments_del','Billing','Payments'),(134,'rep_newusers','Reporting','Core'),(135,'bill_invoice_report','Billing','Invoice'),(136,'config_reports_dashboard','Configuration','Reporting'),(137,'rep_stat_ups','Reporting','Status'),(138,'rep_stat_raid','Reporting','Status'),(139,'rep_stat_cron','Reporting','Status');
/*!40000 ALTER TABLE `operators_acl_files` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `payment`
--

DROP TABLE IF EXISTS `payment`;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8mb4;
CREATE TABLE `payment` (
  `id` INT(32) NOT NULL AUTO_INCREMENT,
  `invoice_id` INT(32) NOT NULL COMMENT 'invoice id of the invoices table',
  `amount` DECIMAL(10,2) NOT NULL COMMENT 'the amount paid',
  `date` DATETIME NOT NULL DEFAULT '0000-00-00 00:00:00',
  `type_id` INT(10) NOT NULL DEFAULT '1' COMMENT 'the type of the payment from payment_type',
  `notes` VARCHAR(128) NOT NULL COMMENT 'general notes/description',
  `creationdate` DATETIME DEFAULT '0000-00-00 00:00:00',
  `creationby` VARCHAR(128) DEFAULT NULL,
  `updatedate` DATETIME DEFAULT '0000-00-00 00:00:00',
  `updateby` VARCHAR(128) DEFAULT NULL,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
SET character_set_client = @saved_cs_client;

--
-- Dumping data for table `payment`
--

LOCK TABLES `payment` WRITE;
/*!40000 ALTER TABLE `payment` DISABLE KEYS */;
/*!40000 ALTER TABLE `payment` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `payment_type`
--

DROP TABLE IF EXISTS `payment_type`;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8mb4;
CREATE TABLE `payment_type` (
  `id` INT(10) NOT NULL AUTO_INCREMENT,
  `value` VARCHAR(32) NOT NULL DEFAULT '' COMMENT 'type value',
  `notes` VARCHAR(128) NOT NULL COMMENT 'general notes/description',
  `creationdate` DATETIME DEFAULT '0000-00-00 00:00:00',
  `creationby` VARCHAR(128) DEFAULT NULL,
  `updatedate` DATETIME DEFAULT '0000-00-00 00:00:00',
  `updateby` VARCHAR(128) DEFAULT NULL,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4;
SET character_set_client = @saved_cs_client;

--
-- Dumping data for table `payment_type`
--

LOCK TABLES `payment_type` WRITE;
/*!40000 ALTER TABLE `payment_type` DISABLE KEYS */;
INSERT INTO `payment_type` VALUES (1,'Cash','','2010-05-27 00:00:00','operator','2010-05-27 00:00:00','operator'),(2,'Check','','2010-05-27 00:00:00','operator','2010-05-27 00:00:00','operator'),(3,'Bank Transfer','','2010-05-27 00:00:00','operator','2010-05-27 00:00:00','operator');
/*!40000 ALTER TABLE `payment_type` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `proxys`
--

DROP TABLE IF EXISTS `proxys`;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8mb4;
CREATE TABLE `proxys` (
  `id` BIGINT(20) NOT NULL AUTO_INCREMENT,
  `proxyname` VARCHAR(128) DEFAULT NULL,
  `retry_delay` INT(8) DEFAULT NULL,
  `retry_count` INT(8) DEFAULT NULL,
  `dead_time` INT(8) DEFAULT NULL,
  `default_fallback` INT(8) DEFAULT NULL,
  `creationdate` DATETIME DEFAULT NULL,
  `creationby` VARCHAR(128) DEFAULT NULL,
  `updatedate` DATETIME DEFAULT NULL,
  `updateby` VARCHAR(128) DEFAULT NULL,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
SET character_set_client = @saved_cs_client;

--
-- Dumping data for table `proxys`
--

LOCK TABLES `proxys` WRITE;
/*!40000 ALTER TABLE `proxys` DISABLE KEYS */;
/*!40000 ALTER TABLE `proxys` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `realms`
--

DROP TABLE IF EXISTS `realms`;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8mb4;
CREATE TABLE `realms` (
  `id` BIGINT(20) NOT NULL AUTO_INCREMENT,
  `realmname` VARCHAR(128) DEFAULT NULL,
  `type` VARCHAR(32) DEFAULT NULL,
  `authhost` VARCHAR(256) DEFAULT NULL,
  `accthost` VARCHAR(256) DEFAULT NULL,
  `secret` VARCHAR(128) DEFAULT NULL,
  `ldflag` VARCHAR(64) DEFAULT NULL,
  `nostrip` INT(8) DEFAULT NULL,
  `hints` INT(8) DEFAULT NULL,
  `notrealm` INT(8) DEFAULT NULL,
  `creationdate` DATETIME DEFAULT NULL,
  `creationby` VARCHAR(128) DEFAULT NULL,
  `updatedate` DATETIME DEFAULT NULL,
  `updateby` VARCHAR(128) DEFAULT NULL,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
SET character_set_client = @saved_cs_client;

--
-- Dumping data for table `realms`
--

LOCK TABLES `realms` WRITE;
/*!40000 ALTER TABLE `realms` DISABLE KEYS */;
/*!40000 ALTER TABLE `realms` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `userbillinfo`
--

DROP TABLE IF EXISTS `userbillinfo`;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8mb4;
CREATE TABLE `userbillinfo` (
  `id` INT(8) UNSIGNED NOT NULL AUTO_INCREMENT,
  `username` VARCHAR(128) DEFAULT NULL,
  `planName` VARCHAR(128) DEFAULT NULL,
  `hotspot_id` INT(32) DEFAULT NULL,
  `hotspotlocation` VARCHAR(32) DEFAULT NULL,
  `contactperson` VARCHAR(200) DEFAULT NULL,
  `company` VARCHAR(200) DEFAULT NULL,
  `email` VARCHAR(200) DEFAULT NULL,
  `phone` VARCHAR(200) DEFAULT NULL,
  `address` VARCHAR(200) DEFAULT NULL,
  `city` VARCHAR(200) DEFAULT NULL,
  `state` VARCHAR(200) DEFAULT NULL,
  `country` VARCHAR(100) DEFAULT NULL,
  `zip` VARCHAR(200) DEFAULT NULL,
  `paymentmethod` VARCHAR(200) DEFAULT NULL,
  `cash` VARCHAR(200) DEFAULT NULL,
  `creditcardname` VARCHAR(200) DEFAULT NULL,
  `creditcardnumber` VARCHAR(200) DEFAULT NULL,
  `creditcardverification` VARCHAR(200) DEFAULT NULL,
  `creditcardtype` VARCHAR(200) DEFAULT NULL,
  `creditcardexp` VARCHAR(200) DEFAULT NULL,
  `notes` VARCHAR(200) DEFAULT NULL,
  `changeuserbillinfo` VARCHAR(128) DEFAULT NULL,
  `lead` VARCHAR(200) DEFAULT NULL,
  `coupon` VARCHAR(200) DEFAULT NULL,
  `ordertaker` VARCHAR(200) DEFAULT NULL,
  `billstatus` VARCHAR(200) DEFAULT NULL,
  `lastbill` DATE NOT NULL DEFAULT '0000-00-00',
  `nextbill` DATE NOT NULL DEFAULT '0000-00-00',
  `nextinvoicedue` INT(32) DEFAULT NULL,
  `billdue` INT(32) DEFAULT NULL,
  `postalinvoice` VARCHAR(8) DEFAULT NULL,
  `faxinvoice` VARCHAR(8) DEFAULT NULL,
  `emailinvoice` VARCHAR(8) DEFAULT NULL,
  `batch_id` INT(32) DEFAULT NULL,
  `creationdate` DATETIME DEFAULT '0000-00-00 00:00:00',
  `creationby` VARCHAR(128) DEFAULT NULL,
  `updatedate` DATETIME DEFAULT '0000-00-00 00:00:00',
  `updateby` VARCHAR(128) DEFAULT NULL,
  PRIMARY KEY  (`id`),
  KEY `username` (`username`),
  KEY `planname` (`planName`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
SET character_set_client = @saved_cs_client;

--
-- Dumping data for table `userbillinfo`
--

LOCK TABLES `userbillinfo` WRITE;
/*!40000 ALTER TABLE `userbillinfo` DISABLE KEYS */;
/*!40000 ALTER TABLE `userbillinfo` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `userinfo`
--

DROP TABLE IF EXISTS `userinfo`;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8mb4;
CREATE TABLE `userinfo` (
  `id` INT(11) UNSIGNED NOT NULL AUTO_INCREMENT,
  `username` VARCHAR(128) DEFAULT NULL,
  `firstname` VARCHAR(200) DEFAULT NULL,
  `lastname` VARCHAR(200) DEFAULT NULL,
  `email` VARCHAR(200) DEFAULT NULL,
  `department` VARCHAR(200) DEFAULT NULL,
  `company` VARCHAR(200) DEFAULT NULL,
  `workphone` VARCHAR(200) DEFAULT NULL,
  `homephone` VARCHAR(200) DEFAULT NULL,
  `mobilephone` VARCHAR(200) DEFAULT NULL,
  `address` VARCHAR(200) DEFAULT NULL,
  `city` VARCHAR(200) DEFAULT NULL,
  `state` VARCHAR(200) DEFAULT NULL,
  `country` VARCHAR(100) DEFAULT NULL,
  `zip` VARCHAR(200) DEFAULT NULL,
  `notes` VARCHAR(200) DEFAULT NULL,
  `changeuserinfo` VARCHAR(128) DEFAULT NULL,
  `portalloginpassword` VARCHAR(128) DEFAULT '',
  `enableportallogin` INT(32) DEFAULT '0',
  `creationdate` DATETIME DEFAULT '0000-00-00 00:00:00',
  `creationby` VARCHAR(128) DEFAULT NULL,
  `updatedate` DATETIME DEFAULT '0000-00-00 00:00:00',
  `updateby` VARCHAR(128) DEFAULT NULL,
  PRIMARY KEY  (`id`),
  KEY `username` (`username`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
SET character_set_client = @saved_cs_client;

--
-- Dumping data for table `userinfo`
--

LOCK TABLES `userinfo` WRITE;
/*!40000 ALTER TABLE `userinfo` DISABLE KEYS */;
/*!40000 ALTER TABLE `userinfo` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

-- Adding new custom daloRADIUS groups
INSERT IGNORE INTO `radgroupcheck` (`groupname`,`attribute`,`op`,`value`)
                            VALUES ('daloRADIUS-Disabled-Users','Auth-Type',':=','Reject');

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

--
-- Table structure for table `messages`
--

DROP TABLE IF EXISTS `messages`;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8mb4;
CREATE TABLE IF NOT EXISTS `messages` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `type` ENUM('login', 'support', 'dashboard') NOT NULL,
  `content` LONGTEXT NOT NULL,
  `created_on` DATETIME NULL,
  `created_by` VARCHAR(32) NULL,
  `modified_on` DATETIME NULL,
  `modified_by` VARCHAR(32) NULL,
  PRIMARY KEY (`id`))
ENGINE = InnoDB DEFAULT CHARSET=utf8mb4;
SET character_set_client = @saved_cs_client;

--
-- Default data for table `messages`
--

LOCK TABLES `messages` WRITE;
/*!40000 ALTER TABLE `messages` DISABLE KEYS */;
INSERT INTO `messages` VALUES (2, 'login', '<p>Dear User,<br>Welcome to the Users Portal. We are glad you joined us!</p><p>By logging in with your account username and password, you will be able to access a wide range of features. For example, you can easily edit your contact settings, update your personal information, and view some history data through visual graphs.</p><p>We take your privacy and security seriously, so please rest assured that all your data is stored securely in our database and is accessible only to you and our authorized staff.</p><p>If you need any assistance or have any questions, please do not hesitate to contact our support team. We are always happy to help!</p><p>Regards,<br/>The daloRADIUS Staff.</p>', NOW(), 'administrator', NULL, NULL);
INSERT INTO `messages` VALUES (3, 'support', '<p>Dear User,<br>We can provide support in different ways: you can email us at <strong>support@daloradius.local</strong> or you can open a new ticket through our help desk: <strong>https://helpdesk.daloradius.local</strong>.</p><p>Thank you for choosing daloRADIUS.</p><p>Best regards,<br>The daloRADIUS Support Team</p>', NOW(), 'administrator', NULL, NULL);
INSERT INTO `messages` VALUES (4, 'dashboard', '<p>Dear User,<br>We can provide support in different ways: you can email us at <strong>support@daloradius.local</strong> or you can open a new ticket through our help desk: <strong>https://helpdesk.daloradius.local</strong>.</p><p>Thank you for choosing daloRADIUS.</p><p>Best regards,<br>The daloRADIUS Support Team</p>', NOW(), 'administrator', NULL, NULL);
/*!40000 ALTER TABLE `messages` ENABLE KEYS */;
UNLOCK TABLES;
