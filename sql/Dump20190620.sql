-- MySQL dump 10.13  Distrib 5.7.24, for Win64 (x86_64)
--
-- Host: localhost    Database: wms_db
-- ------------------------------------------------------
-- Server version	5.7.24-log

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `wms_access_record`
--

DROP TABLE IF EXISTS `wms_access_record`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `wms_access_record` (
  `RECORD_ID` int(11) NOT NULL AUTO_INCREMENT,
  `USER_ID` int(11) NOT NULL,
  `USER_NAME` varchar(50) NOT NULL,
  `ACCESS_TYPE` varchar(30) NOT NULL,
  `ACCESS_TIME` datetime NOT NULL,
  `ACCESS_IP` varchar(45) NOT NULL,
  PRIMARY KEY (`RECORD_ID`)
) ENGINE=InnoDB AUTO_INCREMENT=127 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `wms_access_record`
--

LOCK TABLES `wms_access_record` WRITE;
/*!40000 ALTER TABLE `wms_access_record` DISABLE KEYS */;
/*!40000 ALTER TABLE `wms_access_record` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `wms_action`
--

DROP TABLE IF EXISTS `wms_action`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `wms_action` (
  `ACTION_ID` int(11) NOT NULL AUTO_INCREMENT,
  `ACTION_NAME` varchar(30) NOT NULL,
  `ACTION_DESC` varchar(30) DEFAULT NULL,
  `ACTION_PARAM` varchar(50) NOT NULL,
  PRIMARY KEY (`ACTION_ID`)
) ENGINE=InnoDB AUTO_INCREMENT=49 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `wms_action`
--

LOCK TABLES `wms_action` WRITE;
/*!40000 ALTER TABLE `wms_action` DISABLE KEYS */;
INSERT INTO `wms_action` VALUES (1,'addSupplier',NULL,'/supplierManage/addSupplier'),(2,'deleteSupplier',NULL,'/supplierManage/deleteSupplier'),(3,'updateSupplier',NULL,'/supplierManage/updateSupplier'),(4,'selectSupplier',NULL,'/supplierManage/getSupplierList'),(5,'getSupplierInfo',NULL,'/supplierManage/getSupplierInfo'),(6,'importSupplier',NULL,'/supplierManage/importSupplier'),(7,'exportSupplier',NULL,'/supplierManage/exportSupplier'),(8,'selectCustomer',NULL,'/customerManage/getCustomerList'),(9,'addCustomer',NULL,'/customerManage/addCustomer'),(10,'getCustomerInfo',NULL,'/customerManage/getCustomerInfo'),(11,'updateCustomer',NULL,'/customerManage/updateCustomer'),(12,'deleteCustomer',NULL,'/customerManage/deleteCustomer'),(13,'importCustomer',NULL,'/customerManage/importCustomer'),(14,'exportCustomer',NULL,'/customerManage/exportCustomer'),(15,'selectGoods',NULL,'/goodsManage/getGoodsList'),(16,'addGoods',NULL,'/goodsManage/addGoods'),(17,'getGoodsInfo',NULL,'/goodsManage/getGoodsInfo'),(18,'updateGoods',NULL,'/goodsManage/updateGoods'),(19,'deleteGoods',NULL,'/goodsManage/deleteGoods'),(20,'importGoods',NULL,'/goodsManage/importGoods'),(21,'exportGoods',NULL,'/goodsManage/exportGoods'),(22,'selectRepository',NULL,'/repositoryManage/getRepositoryList'),(23,'addRepository',NULL,'/repositoryManage/addRepository'),(24,'getRepositoryInfo',NULL,'/repositoryManage/getRepository'),(25,'updateRepository',NULL,'/repositoryManage/updateRepository'),(26,'deleteRepository',NULL,'/repositoryManage/deleteRepository'),(27,'importRepository',NULL,'/repositoryManage/importRepository'),(28,'exportRepository',NULL,'/repositoryManage/exportRepository'),(29,'selectRepositoryAdmin',NULL,'/repositoryAdminManage/getRepositoryAdminList'),(30,'addRepositoryAdmin',NULL,'/repositoryAdminManage/addRepositoryAdmin'),(31,'getRepositoryAdminInfo',NULL,'/repositoryAdminManage/getRepositoryAdminInfo'),(32,'updateRepositoryAdmin',NULL,'/repositoryAdminManage/updateRepositoryAdmin'),(33,'deleteRepositoryAdmin',NULL,'/repositoryAdminManage/deleteRepositoryAdmin'),(34,'importRepositoryAd,om',NULL,'/repositoryAdminManage/importRepositoryAdmin'),(35,'exportRepository',NULL,'/repositoryAdminManage/exportRepositoryAdmin'),(36,'getUnassignRepository',NULL,'/repositoryManage/getUnassignRepository'),(37,'getStorageListWithRepository',NULL,'/storageManage/getStorageListWithRepository'),(38,'getStorageList',NULL,'/storageManage/getStorageList'),(39,'addStorageRecord',NULL,'/storageManage/addStorageRecord'),(40,'updateStorageRecord',NULL,'/storageManage/updateStorageRecord'),(41,'deleteStorageRecord',NULL,'/storageManage/deleteStorageRecord'),(42,'importStorageRecord',NULL,'/storageManage/importStorageRecord'),(43,'exportStorageRecord',NULL,'/storageManage/exportStorageRecord'),(44,' stockIn',NULL,'/stockRecordManage/stockIn'),(45,'stockOut',NULL,'/stockRecordManage/stockOut'),(46,'searchStockRecord',NULL,'/stockRecordManage/searchStockRecord'),(47,'getAccessRecords',NULL,'/systemLog/getAccessRecords'),(48,'selectUserOperationRecords',NULL,'/systemLog/selectUserOperationRecords');
/*!40000 ALTER TABLE `wms_action` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `wms_customer`
--

DROP TABLE IF EXISTS `wms_customer`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `wms_customer` (
  `CUSTOMER_ID` int(11) NOT NULL AUTO_INCREMENT,
  `CUSTOMER_NAME` varchar(30) NOT NULL,
  `CUSTOMER_PERSON` varchar(10) NOT NULL,
  `CUSTOMER_TEL` varchar(20) NOT NULL,
  `CUSTOMER_EMAIL` varchar(20) NOT NULL,
  `CUSTOMER_ADDRESS` varchar(30) NOT NULL,
  PRIMARY KEY (`CUSTOMER_ID`)
) ENGINE=InnoDB AUTO_INCREMENT=1217 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `wms_customer`
--

LOCK TABLES `wms_customer` WRITE;
/*!40000 ALTER TABLE `wms_customer` DISABLE KEYS */;
INSERT INTO `wms_customer` VALUES (1214,'John','Admin','2020327','2020372@gmail.com','Minsk, Esenina 3-33'),(1215,'Simon','Anastasya','2752489','2752489@mail.com','MSQ'),(1216,'Anna','Ivan','+375257138505','andreev@gmail.com','SPB');
/*!40000 ALTER TABLE `wms_customer` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `wms_goods`
--

DROP TABLE IF EXISTS `wms_goods`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `wms_goods` (
  `GOOD_ID` int(11) NOT NULL AUTO_INCREMENT,
  `GOOD_NAME` varchar(30) NOT NULL,
  `GOOD_RYPE` varchar(20) DEFAULT NULL,
  `GOOD_SIZE` varchar(20) DEFAULT NULL,
  `GOOD_VALUE` double NOT NULL,
  PRIMARY KEY (`GOOD_ID`)
) ENGINE=InnoDB AUTO_INCREMENT=106 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `wms_goods`
--

LOCK TABLES `wms_goods` WRITE;
/*!40000 ALTER TABLE `wms_goods` DISABLE KEYS */;
INSERT INTO `wms_goods` VALUES (103,'Коробка','Упаковка','86*86',1.85),(104,'Кружка','Посуда','9*9*11',3.5),(105,'Coca-cola','Напитки','312ml',300);
/*!40000 ALTER TABLE `wms_goods` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `wms_operation_record`
--

DROP TABLE IF EXISTS `wms_operation_record`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `wms_operation_record` (
  `RECORD_ID` int(11) NOT NULL AUTO_INCREMENT,
  `USER_ID` int(11) NOT NULL,
  `USER_NAME` varchar(50) NOT NULL,
  `OPERATION_NAME` varchar(30) NOT NULL,
  `OPERATION_TIME` datetime NOT NULL,
  `OPERATION_RESULT` varchar(15) NOT NULL,
  PRIMARY KEY (`RECORD_ID`)
) ENGINE=InnoDB AUTO_INCREMENT=54 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `wms_operation_record`
--

LOCK TABLES `wms_operation_record` WRITE;
/*!40000 ALTER TABLE `wms_operation_record` DISABLE KEYS */;
/*!40000 ALTER TABLE `wms_operation_record` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `wms_record_in`
--

DROP TABLE IF EXISTS `wms_record_in`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `wms_record_in` (
  `RECORD_ID` int(11) NOT NULL AUTO_INCREMENT,
  `RECORD_SUPPLIERID` int(11) NOT NULL,
  `RECORD_GOODID` int(11) NOT NULL,
  `RECORD_NUMBER` int(11) NOT NULL,
  `RECORD_TIME` datetime NOT NULL,
  `RECORD_PERSON` varchar(10) NOT NULL,
  `RECORD_REPOSITORYID` int(11) NOT NULL,
  PRIMARY KEY (`RECORD_ID`),
  KEY `RECORD_SUPPLIERID` (`RECORD_SUPPLIERID`),
  KEY `RECORD_GOODID` (`RECORD_GOODID`),
  KEY `RECORD_REPOSITORYID` (`RECORD_REPOSITORYID`),
  CONSTRAINT `wms_record_in_ibfk_1` FOREIGN KEY (`RECORD_SUPPLIERID`) REFERENCES `wms_supplier` (`SUPPLIER_ID`),
  CONSTRAINT `wms_record_in_ibfk_2` FOREIGN KEY (`RECORD_GOODID`) REFERENCES `wms_goods` (`GOOD_ID`),
  CONSTRAINT `wms_record_in_ibfk_3` FOREIGN KEY (`RECORD_REPOSITORYID`) REFERENCES `wms_respository` (`REPO_ID`)
) ENGINE=InnoDB AUTO_INCREMENT=18 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `wms_record_in`
--

LOCK TABLES `wms_record_in` WRITE;
/*!40000 ALTER TABLE `wms_record_in` DISABLE KEYS */;
INSERT INTO `wms_record_in` VALUES (15,1015,105,1000,'2016-12-31 00:00:00','admin',1004),(16,1015,105,200,'2017-01-02 00:00:00','admin',1004),(17,1013,104,1,'2019-06-20 00:40:31','admin',1006);
/*!40000 ALTER TABLE `wms_record_in` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `wms_record_out`
--

DROP TABLE IF EXISTS `wms_record_out`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `wms_record_out` (
  `RECORD_ID` int(11) NOT NULL AUTO_INCREMENT,
  `RECORD_CUSTOMERID` int(11) NOT NULL,
  `RECORD_GOODID` int(11) NOT NULL,
  `RECORD_NUMBER` int(11) NOT NULL,
  `RECORD_TIME` datetime NOT NULL,
  `RECORD_PERSON` varchar(10) NOT NULL,
  `RECORD_REPOSITORYID` int(11) NOT NULL,
  PRIMARY KEY (`RECORD_ID`),
  KEY `RECORD_CUSTOMERID` (`RECORD_CUSTOMERID`),
  KEY `RECORD_GOODID` (`RECORD_GOODID`),
  KEY `RECORD_REPOSITORYID` (`RECORD_REPOSITORYID`),
  CONSTRAINT `wms_record_out_ibfk_1` FOREIGN KEY (`RECORD_CUSTOMERID`) REFERENCES `wms_customer` (`CUSTOMER_ID`),
  CONSTRAINT `wms_record_out_ibfk_2` FOREIGN KEY (`RECORD_GOODID`) REFERENCES `wms_goods` (`GOOD_ID`),
  CONSTRAINT `wms_record_out_ibfk_3` FOREIGN KEY (`RECORD_REPOSITORYID`) REFERENCES `wms_respository` (`REPO_ID`)
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `wms_record_out`
--

LOCK TABLES `wms_record_out` WRITE;
/*!40000 ALTER TABLE `wms_record_out` DISABLE KEYS */;
INSERT INTO `wms_record_out` VALUES (7,1214,104,750,'2016-12-31 00:00:00','admin',1003);
/*!40000 ALTER TABLE `wms_record_out` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `wms_record_storage`
--

DROP TABLE IF EXISTS `wms_record_storage`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `wms_record_storage` (
  `RECORD_GOODID` int(11) NOT NULL AUTO_INCREMENT,
  `RECORD_REPOSITORY` int(11) NOT NULL,
  `RECORD_NUMBER` int(11) NOT NULL,
  PRIMARY KEY (`RECORD_GOODID`),
  KEY `RECORD_REPOSITORY` (`RECORD_REPOSITORY`),
  CONSTRAINT `wms_record_storage_ibfk_1` FOREIGN KEY (`RECORD_GOODID`) REFERENCES `wms_goods` (`GOOD_ID`),
  CONSTRAINT `wms_record_storage_ibfk_2` FOREIGN KEY (`RECORD_REPOSITORY`) REFERENCES `wms_respository` (`REPO_ID`)
) ENGINE=InnoDB AUTO_INCREMENT=106 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `wms_record_storage`
--

LOCK TABLES `wms_record_storage` WRITE;
/*!40000 ALTER TABLE `wms_record_storage` DISABLE KEYS */;
INSERT INTO `wms_record_storage` VALUES (103,1005,10000),(104,1006,1),(105,1004,2000);
/*!40000 ALTER TABLE `wms_record_storage` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `wms_repo_admin`
--

DROP TABLE IF EXISTS `wms_repo_admin`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `wms_repo_admin` (
  `REPO_ADMIN_ID` int(11) NOT NULL AUTO_INCREMENT,
  `REPO_ADMIN_NAME` varchar(10) NOT NULL,
  `REPO_ADMIN_SEX` varchar(10) NOT NULL,
  `REPO_ADMIN_TEL` varchar(20) NOT NULL,
  `REPO_ADMIN_ADDRESS` varchar(30) NOT NULL,
  `REPO_ADMIN_BIRTH` datetime NOT NULL,
  `REPO_ADMIN_REPOID` int(11) DEFAULT NULL,
  PRIMARY KEY (`REPO_ADMIN_ID`),
  KEY `REPO_ADMIN_REPOID` (`REPO_ADMIN_REPOID`),
  CONSTRAINT `wms_repo_admin_ibfk_1` FOREIGN KEY (`REPO_ADMIN_REPOID`) REFERENCES `wms_respository` (`REPO_ID`)
) ENGINE=InnoDB AUTO_INCREMENT=1021 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `wms_repo_admin`
--

LOCK TABLES `wms_repo_admin` WRITE;
/*!40000 ALTER TABLE `wms_repo_admin` DISABLE KEYS */;
INSERT INTO `wms_repo_admin` VALUES (1018,'Ivan','???????','12345874526','SPB','2019-06-01 00:00:00',1004),(1019,'Anna','женский','1234','Minsk','2018-12-12 00:00:00',1003);
/*!40000 ALTER TABLE `wms_repo_admin` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `wms_respository`
--

DROP TABLE IF EXISTS `wms_respository`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `wms_respository` (
  `REPO_ID` int(11) NOT NULL AUTO_INCREMENT,
  `REPO_ADDRESS` varchar(30) NOT NULL,
  `REPO_STATUS` varchar(20) NOT NULL,
  `REPO_AREA` varchar(20) NOT NULL,
  `REPO_DESC` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`REPO_ID`)
) ENGINE=InnoDB AUTO_INCREMENT=1007 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `wms_respository`
--

LOCK TABLES `wms_respository` WRITE;
/*!40000 ALTER TABLE `wms_respository` DISABLE KEYS */;
INSERT INTO `wms_respository` VALUES (1003,'Питер','+5','11000?','хороший склад'),(1004,'Минск','4','1000?','нормальный склад'),(1005,'Москва','2','5000.00?','плохой склад'),(1006,'1006','5+','5000','5+');
/*!40000 ALTER TABLE `wms_respository` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `wms_role_action`
--

DROP TABLE IF EXISTS `wms_role_action`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `wms_role_action` (
  `ACTION_ID` int(11) NOT NULL,
  `ROLE_ID` int(11) NOT NULL,
  PRIMARY KEY (`ACTION_ID`,`ROLE_ID`),
  KEY `ROLE_ID` (`ROLE_ID`),
  CONSTRAINT `wms_role_action_ibfk_1` FOREIGN KEY (`ROLE_ID`) REFERENCES `wms_roles` (`ROLE_ID`),
  CONSTRAINT `wms_role_action_ibfk_2` FOREIGN KEY (`ACTION_ID`) REFERENCES `wms_action` (`ACTION_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `wms_role_action`
--

LOCK TABLES `wms_role_action` WRITE;
/*!40000 ALTER TABLE `wms_role_action` DISABLE KEYS */;
INSERT INTO `wms_role_action` VALUES (1,1),(2,1),(3,1),(4,1),(5,1),(6,1),(7,1),(8,1),(9,1),(10,1),(11,1),(12,1),(13,1),(14,1),(15,1),(16,1),(17,1),(18,1),(19,1),(20,1),(21,1),(22,1),(23,1),(24,1),(25,1),(26,1),(27,1),(28,1),(29,1),(30,1),(31,1),(32,1),(33,1),(34,1),(35,1),(36,1),(37,1),(39,1),(40,1),(41,1),(42,1),(43,1),(44,1),(45,1),(46,1),(47,1),(48,1),(4,2),(38,2),(43,2);
/*!40000 ALTER TABLE `wms_role_action` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `wms_roles`
--

DROP TABLE IF EXISTS `wms_roles`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `wms_roles` (
  `ROLE_ID` int(11) NOT NULL AUTO_INCREMENT,
  `ROLE_NAME` varchar(20) NOT NULL,
  `ROLE_DESC` varchar(30) DEFAULT NULL,
  `ROLE_URL_PREFIX` varchar(20) NOT NULL,
  PRIMARY KEY (`ROLE_ID`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `wms_roles`
--

LOCK TABLES `wms_roles` WRITE;
/*!40000 ALTER TABLE `wms_roles` DISABLE KEYS */;
INSERT INTO `wms_roles` VALUES (1,'systemAdmin',NULL,'systemAdmin'),(2,'commonsAdmin',NULL,'commonsAdmin');
/*!40000 ALTER TABLE `wms_roles` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `wms_supplier`
--

DROP TABLE IF EXISTS `wms_supplier`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `wms_supplier` (
  `SUPPLIER_ID` int(11) NOT NULL AUTO_INCREMENT,
  `SUPPLIER_NAME` varchar(30) NOT NULL,
  `SUPPLIER_PERSON` varchar(10) NOT NULL,
  `SUPPLIER_TEL` varchar(20) NOT NULL,
  `SUPPLIER_EMAIL` varchar(20) NOT NULL,
  `SUPPLIER_ADDRESS` varchar(30) NOT NULL,
  PRIMARY KEY (`SUPPLIER_ID`)
) ENGINE=InnoDB AUTO_INCREMENT=1016 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `wms_supplier`
--

LOCK TABLES `wms_supplier` WRITE;
/*!40000 ALTER TABLE `wms_supplier` DISABLE KEYS */;
INSERT INTO `wms_supplier` VALUES (1013,'TeachMeSkills','Simon','13777771126','86827868@126.com','timiryazeva 67'),(1014,'BTSD','JohnCEEENA','13974167256','23267999@126.com','tytyty-ty'),(1015,'Komunarka','john wick','26391678','22390898@qq.com','MSQ');
/*!40000 ALTER TABLE `wms_supplier` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `wms_user`
--

DROP TABLE IF EXISTS `wms_user`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `wms_user` (
  `USER_ID` int(11) NOT NULL AUTO_INCREMENT,
  `USER_USERNAME` varchar(30) NOT NULL,
  `USER_PASSWORD` varchar(40) NOT NULL,
  PRIMARY KEY (`USER_ID`)
) ENGINE=InnoDB AUTO_INCREMENT=1021 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `wms_user`
--

LOCK TABLES `wms_user` WRITE;
/*!40000 ALTER TABLE `wms_user` DISABLE KEYS */;
INSERT INTO `wms_user` VALUES (1001,'admin','6f5379e73c1a9eac6163ab8eaec7e41c'),(1018,'Ivan','23e666bfe078751035b77e62d45b1b5b'),(1019,'John','c4b3af5a5ab3e3d5aac4c5a5436201b8');
/*!40000 ALTER TABLE `wms_user` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `wms_user_role`
--

DROP TABLE IF EXISTS `wms_user_role`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `wms_user_role` (
  `ROLE_ID` int(11) NOT NULL,
  `USER_ID` int(11) NOT NULL,
  PRIMARY KEY (`ROLE_ID`,`USER_ID`),
  KEY `USER_ID` (`USER_ID`),
  CONSTRAINT `wms_user_role_ibfk_1` FOREIGN KEY (`ROLE_ID`) REFERENCES `wms_roles` (`ROLE_ID`),
  CONSTRAINT `wms_user_role_ibfk_2` FOREIGN KEY (`USER_ID`) REFERENCES `wms_user` (`USER_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `wms_user_role`
--

LOCK TABLES `wms_user_role` WRITE;
/*!40000 ALTER TABLE `wms_user_role` DISABLE KEYS */;
INSERT INTO `wms_user_role` VALUES (1,1001),(2,1018),(2,1019);
/*!40000 ALTER TABLE `wms_user_role` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2019-06-20  0:59:01
