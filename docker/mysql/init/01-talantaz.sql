-- MySQL dump 10.13  Distrib 8.4.13, for Linux (x86_64)
--
-- Host: localhost    Database: talents
-- ------------------------------------------------------
-- Server version	8.4.13

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Current Database: `talents`
--

CREATE DATABASE /*!32312 IF NOT EXISTS*/ `talents` /*!40100 DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci */ /*!80016 DEFAULT ENCRYPTION='N' */;

USE `talents`;

--
-- Table structure for table `auth_group`
--

DROP TABLE IF EXISTS `auth_group`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `auth_group` (
  `id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(150) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `name` (`name`)
) ENGINE=InnoDB AUTO_INCREMENT=52 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `auth_group`
--

LOCK TABLES `auth_group` WRITE;
/*!40000 ALTER TABLE `auth_group` DISABLE KEYS */;
INSERT INTO `auth_group` VALUES (1,'sport teacher');
/*!40000 ALTER TABLE `auth_group` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `auth_group_permissions`
--

DROP TABLE IF EXISTS `auth_group_permissions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `auth_group_permissions` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `group_id` int NOT NULL,
  `permission_id` int NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `auth_group_permissions_group_id_permission_id_0cd325b0_uniq` (`group_id`,`permission_id`),
  KEY `auth_group_permissio_permission_id_84c5c92e_fk_auth_perm` (`permission_id`),
  CONSTRAINT `auth_group_permissio_permission_id_84c5c92e_fk_auth_perm` FOREIGN KEY (`permission_id`) REFERENCES `auth_permission` (`id`),
  CONSTRAINT `auth_group_permissions_group_id_b120cbf9_fk_auth_group_id` FOREIGN KEY (`group_id`) REFERENCES `auth_group` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=154 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `auth_group_permissions`
--

LOCK TABLES `auth_group_permissions` WRITE;
/*!40000 ALTER TABLE `auth_group_permissions` DISABLE KEYS */;
INSERT INTO `auth_group_permissions` VALUES (1,1,1),(2,1,2),(3,1,3),(4,1,4),(5,1,5),(6,1,6),(7,1,7),(8,1,8),(9,1,9),(10,1,10),(11,1,11),(12,1,12),(13,1,13),(14,1,14),(15,1,15),(16,1,16),(17,1,17),(18,1,18),(19,1,19),(20,1,20),(21,1,21),(22,1,22),(23,1,23),(24,1,24),(25,1,25),(26,1,26),(27,1,27),(28,1,28),(29,1,29),(30,1,30),(31,1,31),(32,1,32),(33,1,33),(34,1,34),(35,1,35),(36,1,36),(37,1,37),(38,1,38),(39,1,39),(40,1,40),(41,1,41),(42,1,42),(43,1,43),(44,1,44),(45,1,45),(46,1,46),(47,1,47),(48,1,48),(49,1,49),(50,1,50),(51,1,51),(52,1,52),(53,1,53),(54,1,54),(55,1,55),(56,1,56),(57,1,57),(58,1,58),(59,1,59),(60,1,60),(61,1,61),(62,1,62),(63,1,63),(64,1,64),(65,1,65),(66,1,66),(67,1,67),(68,1,68),(69,1,69),(70,1,70),(71,1,71),(72,1,72),(73,1,73),(74,1,74),(75,1,75),(76,1,76),(77,1,77),(78,1,78),(79,1,79),(80,1,80),(81,1,81),(82,1,82),(83,1,83),(84,1,84),(85,1,85),(86,1,86),(87,1,87),(88,1,88),(89,1,89),(90,1,90),(91,1,91),(92,1,92),(93,1,93),(94,1,94),(95,1,95),(96,1,96),(97,1,97),(98,1,98),(99,1,99),(100,1,100),(101,1,101),(102,1,102),(103,1,103),(104,1,104),(105,1,105),(106,1,106),(107,1,107),(108,1,108),(109,1,109),(110,1,110),(111,1,111),(112,1,112),(113,1,113),(114,1,114),(115,1,115),(116,1,116),(117,1,117),(118,1,118),(119,1,119),(120,1,120),(121,1,121),(122,1,122),(123,1,123),(124,1,124),(125,1,154),(126,1,155),(127,1,156),(128,1,157),(129,1,158),(130,1,159),(131,1,160),(132,1,161),(133,1,162),(134,1,163),(135,1,164),(136,1,165),(137,1,166),(138,1,167),(139,1,168),(140,1,169);
/*!40000 ALTER TABLE `auth_group_permissions` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `auth_permission`
--

DROP TABLE IF EXISTS `auth_permission`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `auth_permission` (
  `id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL,
  `content_type_id` int NOT NULL,
  `codename` varchar(100) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `auth_permission_content_type_id_codename_01ab375a_uniq` (`content_type_id`,`codename`),
  CONSTRAINT `auth_permission_content_type_id_2f476e4b_fk_django_co` FOREIGN KEY (`content_type_id`) REFERENCES `django_content_type` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=307 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `auth_permission`
--

LOCK TABLES `auth_permission` WRITE;
/*!40000 ALTER TABLE `auth_permission` DISABLE KEYS */;
INSERT INTO `auth_permission` VALUES (1,'Can add log entry',1,'add_logentry'),(2,'Can change log entry',1,'change_logentry'),(3,'Can delete log entry',1,'delete_logentry'),(4,'Can view log entry',1,'view_logentry'),(5,'Can add permission',3,'add_permission'),(6,'Can change permission',3,'change_permission'),(7,'Can delete permission',3,'delete_permission'),(8,'Can view permission',3,'view_permission'),(9,'Can add group',2,'add_group'),(10,'Can change group',2,'change_group'),(11,'Can delete group',2,'delete_group'),(12,'Can view group',2,'view_group'),(13,'Can add content type',4,'add_contenttype'),(14,'Can change content type',4,'change_contenttype'),(15,'Can delete content type',4,'delete_contenttype'),(16,'Can view content type',4,'view_contenttype'),(17,'Can add country',10,'add_country'),(18,'Can change country',10,'change_country'),(19,'Can delete country',10,'delete_country'),(20,'Can view country',10,'view_country'),(21,'Can add parent',16,'add_parent'),(22,'Can change parent',16,'change_parent'),(23,'Can delete parent',16,'delete_parent'),(24,'Can view parent',16,'view_parent'),(25,'Can add region',17,'add_region'),(26,'Can change region',17,'change_region'),(27,'Can delete region',17,'delete_region'),(28,'Can view region',17,'view_region'),(29,'Can add district',11,'add_district'),(30,'Can change district',11,'change_district'),(31,'Can delete district',11,'delete_district'),(32,'Can view district',11,'view_district'),(33,'Can add school',18,'add_school'),(34,'Can change school',18,'change_school'),(35,'Can delete school',18,'delete_school'),(36,'Can view school',18,'view_school'),(37,'Can add user',25,'add_user'),(38,'Can change user',25,'change_user'),(39,'Can delete user',25,'delete_user'),(40,'Can view user',25,'view_user'),(41,'Can add ward',26,'add_ward'),(42,'Can change ward',26,'change_ward'),(43,'Can delete ward',26,'delete_ward'),(44,'Can view ward',26,'view_ward'),(45,'Can add zone',27,'add_zone'),(46,'Can change zone',27,'change_zone'),(47,'Can delete zone',27,'delete_zone'),(48,'Can view zone',27,'view_zone'),(49,'Can add talent',22,'add_talent'),(50,'Can change talent',22,'change_talent'),(51,'Can delete talent',22,'delete_talent'),(52,'Can view talent',22,'view_talent'),(53,'Can add announcement',5,'add_announcement'),(54,'Can change announcement',5,'change_announcement'),(55,'Can delete announcement',5,'delete_announcement'),(56,'Can view announcement',5,'view_announcement'),(57,'Can add student talent',20,'add_studenttalent'),(58,'Can change student talent',20,'change_studenttalent'),(59,'Can delete student talent',20,'delete_studenttalent'),(60,'Can view student talent',20,'view_studenttalent'),(61,'Can add audit log',6,'add_auditlog'),(62,'Can change audit log',6,'change_auditlog'),(63,'Can delete audit log',6,'delete_auditlog'),(64,'Can view audit log',6,'view_auditlog'),(65,'Can add club',7,'add_club'),(66,'Can change club',7,'change_club'),(67,'Can delete club',7,'delete_club'),(68,'Can view club',7,'view_club'),(69,'Can add club talent',8,'add_clubtalent'),(70,'Can change club talent',8,'change_clubtalent'),(71,'Can delete club talent',8,'delete_clubtalent'),(72,'Can view club talent',8,'view_clubtalent'),(73,'Can add club teacher',9,'add_clubteacher'),(74,'Can change club teacher',9,'change_clubteacher'),(75,'Can delete club teacher',9,'delete_clubteacher'),(76,'Can view club teacher',9,'view_clubteacher'),(77,'Can add evaluation criterion',12,'add_evaluationcriterion'),(78,'Can change evaluation criterion',12,'change_evaluationcriterion'),(79,'Can delete evaluation criterion',12,'delete_evaluationcriterion'),(80,'Can view evaluation criterion',12,'view_evaluationcriterion'),(81,'Can add message',14,'add_message'),(82,'Can change message',14,'change_message'),(83,'Can delete message',14,'delete_message'),(84,'Can view message',14,'view_message'),(85,'Can add notification',15,'add_notification'),(86,'Can change notification',15,'change_notification'),(87,'Can delete notification',15,'delete_notification'),(88,'Can view notification',15,'view_notification'),(89,'Can add student club membership',19,'add_studentclubmembership'),(90,'Can change student club membership',19,'change_studentclubmembership'),(91,'Can delete student club membership',19,'delete_studentclubmembership'),(92,'Can view student club membership',19,'view_studentclubmembership'),(93,'Can add talent evaluation',23,'add_talentevaluation'),(94,'Can change talent evaluation',23,'change_talentevaluation'),(95,'Can delete talent evaluation',23,'delete_talentevaluation'),(96,'Can view talent evaluation',23,'view_talentevaluation'),(97,'Can add evaluation score',13,'add_evaluationscore'),(98,'Can change evaluation score',13,'change_evaluationscore'),(99,'Can delete evaluation score',13,'delete_evaluationscore'),(100,'Can view evaluation score',13,'view_evaluationscore'),(101,'Can add talent submission',24,'add_talentsubmission'),(102,'Can change talent submission',24,'change_talentsubmission'),(103,'Can delete talent submission',24,'delete_talentsubmission'),(104,'Can view talent submission',24,'view_talentsubmission'),(105,'Can add submission feedback',21,'add_submissionfeedback'),(106,'Can change submission feedback',21,'change_submissionfeedback'),(107,'Can delete submission feedback',21,'delete_submissionfeedback'),(108,'Can view submission feedback',21,'view_submissionfeedback'),(109,'Can add student',28,'add_student'),(110,'Can change student',28,'change_student'),(111,'Can delete student',28,'delete_student'),(112,'Can view student',28,'view_student'),(113,'Can add competition',29,'add_competition'),(114,'Can change competition',29,'change_competition'),(115,'Can delete competition',29,'delete_competition'),(116,'Can view competition',29,'view_competition'),(117,'Can add competition participation',31,'add_competitionparticipation'),(118,'Can change competition participation',31,'change_competitionparticipation'),(119,'Can delete competition participation',31,'delete_competitionparticipation'),(120,'Can view competition participation',31,'view_competitionparticipation'),(121,'Can add competition judge',30,'add_competitionjudge'),(122,'Can change competition judge',30,'change_competitionjudge'),(123,'Can delete competition judge',30,'delete_competitionjudge'),(124,'Can view competition judge',30,'view_competitionjudge'),(154,'Can add session',52,'add_session'),(155,'Can change session',52,'change_session'),(156,'Can delete session',52,'delete_session'),(157,'Can view session',52,'view_session'),(158,'Can add result',53,'add_result'),(159,'Can change result',53,'change_result'),(160,'Can delete result',53,'delete_result'),(161,'Can view result',53,'view_result'),(162,'Can add result detail',54,'add_resultdetail'),(163,'Can change result detail',54,'change_resultdetail'),(164,'Can delete result detail',54,'delete_resultdetail'),(165,'Can view result detail',54,'view_resultdetail'),(166,'Can add result promotion',55,'add_resultpromotion'),(167,'Can change result promotion',55,'change_resultpromotion'),(168,'Can delete result promotion',55,'delete_resultpromotion'),(169,'Can view result promotion',55,'view_resultpromotion'),(205,'Can add school ownership type',105,'add_schoolownershiptype'),(206,'Can change school ownership type',105,'change_schoolownershiptype'),(207,'Can delete school ownership type',105,'delete_schoolownershiptype'),(208,'Can view school ownership type',105,'view_schoolownershiptype'),(209,'Can add country club',103,'add_countryclub'),(210,'Can change country club',103,'change_countryclub'),(211,'Can delete country club',103,'delete_countryclub'),(212,'Can view country club',103,'view_countryclub'),(213,'Can add school club',104,'add_schoolclub'),(214,'Can change school club',104,'change_schoolclub'),(215,'Can delete school club',104,'delete_schoolclub'),(216,'Can view school club',104,'view_schoolclub'),(217,'Can add talent category',106,'add_talentcategory'),(218,'Can change talent category',106,'change_talentcategory'),(219,'Can delete talent category',106,'delete_talentcategory'),(220,'Can view talent category',106,'view_talentcategory'),(221,'Can add education level',107,'add_educationlevel'),(222,'Can change education level',107,'change_educationlevel'),(223,'Can delete education level',107,'delete_educationlevel'),(224,'Can view education level',107,'view_educationlevel'),(225,'Can add school competition submission',108,'add_schoolcompetitionsubmission'),(226,'Can change school competition submission',108,'change_schoolcompetitionsubmission'),(227,'Can delete school competition submission',108,'delete_schoolcompetitionsubmission'),(228,'Can view school competition submission',108,'view_schoolcompetitionsubmission'),(256,'Can add district competition submission',154,'add_districtcompetitionsubmission'),(257,'Can change district competition submission',154,'change_districtcompetitionsubmission'),(258,'Can delete district competition submission',154,'delete_districtcompetitionsubmission'),(259,'Can view district competition submission',154,'view_districtcompetitionsubmission'),(260,'Can add zone competition submission',155,'add_zonecompetitionsubmission'),(261,'Can change zone competition submission',155,'change_zonecompetitionsubmission'),(262,'Can delete zone competition submission',155,'delete_zonecompetitionsubmission'),(263,'Can view zone competition submission',155,'view_zonecompetitionsubmission');
/*!40000 ALTER TABLE `auth_permission` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `competitions_competition`
--

DROP TABLE IF EXISTS `competitions_competition`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `competitions_competition` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `name` varchar(150) NOT NULL,
  `description` longtext NOT NULL,
  `level` varchar(20) NOT NULL,
  `start_date` date NOT NULL,
  `end_date` date DEFAULT NULL,
  `object_id` int unsigned DEFAULT NULL,
  `content_type_id` int DEFAULT NULL,
  `approved_at` datetime(6) DEFAULT NULL,
  `approved_by_id` bigint DEFAULT NULL,
  `organizer_id` bigint DEFAULT NULL,
  `status` varchar(20) NOT NULL,
  `venue` varchar(255) NOT NULL,
  `talent_id` bigint DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `competitions_competi_content_type_id_916d630e_fk_django_co` (`content_type_id`),
  KEY `competitions_competition_approved_by_id_1d961749_fk` (`approved_by_id`),
  KEY `competitions_competition_organizer_id_addf481c_fk` (`organizer_id`),
  KEY `competitions_competition_talent_id_61d2af20_fk_core_talent_id` (`talent_id`),
  CONSTRAINT `competitions_competi_content_type_id_916d630e_fk_django_co` FOREIGN KEY (`content_type_id`) REFERENCES `django_content_type` (`id`),
  CONSTRAINT `competitions_competition_talent_id_61d2af20_fk_core_talent_id` FOREIGN KEY (`talent_id`) REFERENCES `core_talent` (`id`),
  CONSTRAINT `competitions_competition_chk_1` CHECK ((`object_id` >= 0))
) ENGINE=InnoDB AUTO_INCREMENT=870 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `competitions_competition`
--

LOCK TABLES `competitions_competition` WRITE;
/*!40000 ALTER TABLE `competitions_competition` DISABLE KEYS */;
INSERT INTO `competitions_competition` VALUES (768,'ndagara competition','compete hard','school','2026-10-21','2026-10-23',770,18,NULL,NULL,1080,'draft','ISINGIRO STATION',17),(770,'Kahawa & Dhahabu Zone Competition','Auto-created for district result submission.','zone','2026-10-21',NULL,1,27,NULL,NULL,1077,'approved','',NULL),(771,'nyaishozi moto','show  your best','school','2026-10-20','2026-10-23',769,18,NULL,NULL,1078,'draft','nyaishozi station',18),(772,'mambwe competition','fighting sprits','school','2026-10-20','2026-10-22',771,18,NULL,NULL,1079,'draft','ULUMI CENTER',18),(773,'best competition','compete for future','school','2026-10-20','2026-10-22',770,18,NULL,NULL,1080,'draft','nyabishenge',18),(774,'mabingwa','onyesheni ujuzi','district','2026-10-20','2026-10-23',36,11,'2026-10-21 06:46:58.457654',1077,1077,'approved','kayanga',18),(819,'test','try','school','2026-10-23','2026-10-24',771,18,NULL,NULL,1079,'draft','kalambo',18),(820,'test','try','district','2026-10-22','2026-10-24',36,11,'2026-10-23 11:13:59.067792',1077,1077,'approved','swax',18);
/*!40000 ALTER TABLE `competitions_competition` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `competitions_competition_schools`
--

DROP TABLE IF EXISTS `competitions_competition_schools`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `competitions_competition_schools` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `competition_id` bigint NOT NULL,
  `school_id` bigint NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `competitions_competition_competition_id_school_id_4d56cfdd_uniq` (`competition_id`,`school_id`),
  KEY `competitions_competition_schools_school_id_9e838947_fk` (`school_id`),
  CONSTRAINT `competitions_competition_schools_competition_id_a4c9be05_fk` FOREIGN KEY (`competition_id`) REFERENCES `competitions_competition` (`id`),
  CONSTRAINT `competitions_competition_schools_school_id_9e838947_fk` FOREIGN KEY (`school_id`) REFERENCES `core_school` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=921 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `competitions_competition_schools`
--

LOCK TABLES `competitions_competition_schools` WRITE;
/*!40000 ALTER TABLE `competitions_competition_schools` DISABLE KEYS */;
INSERT INTO `competitions_competition_schools` VALUES (819,768,770),(822,770,769),(823,770,770),(824,771,769),(825,772,771),(826,773,770),(827,774,769),(828,774,770),(829,774,771),(870,819,771),(871,820,769),(872,820,770),(873,820,771);
/*!40000 ALTER TABLE `competitions_competition_schools` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `competitions_competitionjudge`
--

DROP TABLE IF EXISTS `competitions_competitionjudge`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `competitions_competitionjudge` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `assigned_at` datetime(6) NOT NULL,
  `competition_id` bigint NOT NULL,
  `judge_id` bigint NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `unique_judge_per_competition` (`competition_id`,`judge_id`),
  KEY `competitions_competitionjudge_judge_id_b14fbf07_fk` (`judge_id`),
  CONSTRAINT `competitions_competi_competition_id_b1308424_fk_competiti` FOREIGN KEY (`competition_id`) REFERENCES `competitions_competition` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `competitions_competitionjudge`
--

LOCK TABLES `competitions_competitionjudge` WRITE;
/*!40000 ALTER TABLE `competitions_competitionjudge` DISABLE KEYS */;
/*!40000 ALTER TABLE `competitions_competitionjudge` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `competitions_competitionparticipation`
--

DROP TABLE IF EXISTS `competitions_competitionparticipation`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `competitions_competitionparticipation` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `joined_at` datetime(6) NOT NULL,
  `score` decimal(5,2) DEFAULT NULL,
  `status` varchar(20) NOT NULL,
  `competition_id` bigint NOT NULL,
  `student_id` bigint NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `competitions_competition_competition_id_student_i_97abf728_uniq` (`competition_id`,`student_id`),
  KEY `competitions_competitionparticipation_student_id_44ab6fe9_fk` (`student_id`),
  CONSTRAINT `competitions_competitionparticipation_competition_id_3f61a1c1_fk` FOREIGN KEY (`competition_id`) REFERENCES `competitions_competition` (`id`),
  CONSTRAINT `competitions_competitionparticipation_student_id_44ab6fe9_fk` FOREIGN KEY (`student_id`) REFERENCES `students_student` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=1025 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `competitions_competitionparticipation`
--

LOCK TABLES `competitions_competitionparticipation` WRITE;
/*!40000 ALTER TABLE `competitions_competitionparticipation` DISABLE KEYS */;
INSERT INTO `competitions_competitionparticipation` VALUES (923,'2026-10-21 05:58:24.720761',76.00,'finished',768,667),(924,'2026-10-21 05:58:24.720793',43.00,'finished',768,668),(925,'2026-10-21 05:58:24.720805',98.00,'finished',768,670),(927,'2026-10-21 06:22:21.663236',65.00,'finished',771,673),(928,'2026-10-21 06:22:21.663267',98.00,'finished',771,674),(929,'2026-10-21 06:22:21.663277',82.00,'finished',771,675),(930,'2026-10-21 06:22:21.663286',45.00,'finished',771,676),(931,'2026-10-21 06:39:29.776919',45.00,'finished',772,677),(932,'2026-10-21 06:39:29.776950',89.00,'finished',772,678),(933,'2026-10-21 06:39:29.776962',65.00,'finished',772,679),(934,'2026-10-21 06:39:29.776971',98.00,'finished',772,680),(935,'2026-10-21 06:39:29.776980',76.00,'finished',772,681),(936,'2026-10-21 06:39:29.776988',70.00,'finished',772,682),(937,'2026-10-21 06:43:10.847884',87.00,'finished',773,672),(938,'2026-10-21 06:43:10.847917',56.00,'finished',773,669),(939,'2026-10-21 06:43:10.847929',77.00,'finished',773,671),(940,'2026-10-21 06:52:40.666006',NULL,'finished',774,674),(941,'2026-10-21 06:52:40.697412',NULL,'finished',774,673),(942,'2026-10-21 06:52:40.723952',NULL,'finished',774,675),(943,'2026-10-21 06:52:40.763421',NULL,'finished',774,678),(944,'2026-10-21 06:52:40.796248',NULL,'finished',774,680),(945,'2026-10-21 06:52:40.824743',NULL,'finished',774,671),(946,'2026-10-21 06:52:40.897125',NULL,'finished',774,669),(947,'2026-10-21 06:52:41.137310',NULL,'finished',774,672),(974,'2026-10-23 11:12:17.526179',99.00,'finished',819,680),(975,'2026-10-23 11:12:17.526259',78.00,'finished',819,677),(976,'2026-10-23 11:12:17.526299',89.00,'finished',819,678),(977,'2026-10-23 11:12:17.526358',45.00,'finished',819,679),(978,'2026-10-23 11:14:23.268898',NULL,'finished',820,678),(979,'2026-10-23 11:14:23.631461',NULL,'finished',820,680);
/*!40000 ALTER TABLE `competitions_competitionparticipation` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `core_announcement`
--

DROP TABLE IF EXISTS `core_announcement`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `core_announcement` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `title` varchar(200) NOT NULL,
  `content` longtext NOT NULL,
  `scope` varchar(20) NOT NULL,
  `created_at` datetime(6) NOT NULL,
  `updated_at` datetime(6) NOT NULL,
  `published_at` datetime(6) DEFAULT NULL,
  `expires_at` datetime(6) DEFAULT NULL,
  `is_active` tinyint(1) NOT NULL,
  `country_id` bigint DEFAULT NULL,
  `district_id` bigint DEFAULT NULL,
  `region_id` bigint DEFAULT NULL,
  `school_id` bigint DEFAULT NULL,
  `zone_id` int DEFAULT NULL,
  `audience` varchar(20) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `core_announcement_zone_id_3e5ef6e4_fk` (`zone_id`),
  KEY `core_announcement_country_id_4b66c343_fk` (`country_id`),
  KEY `core_announcement_district_id_1b5bc065_fk` (`district_id`),
  KEY `core_announcement_region_id_01e89984_fk` (`region_id`),
  KEY `core_announcement_school_id_03fae4e4_fk` (`school_id`),
  CONSTRAINT `core_announcement_country_id_4b66c343_fk` FOREIGN KEY (`country_id`) REFERENCES `core_country` (`id`),
  CONSTRAINT `core_announcement_district_id_1b5bc065_fk` FOREIGN KEY (`district_id`) REFERENCES `core_district` (`id`),
  CONSTRAINT `core_announcement_region_id_01e89984_fk` FOREIGN KEY (`region_id`) REFERENCES `core_region` (`id`),
  CONSTRAINT `core_announcement_school_id_03fae4e4_fk` FOREIGN KEY (`school_id`) REFERENCES `core_school` (`id`),
  CONSTRAINT `core_announcement_zone_id_3e5ef6e4_fk` FOREIGN KEY (`zone_id`) REFERENCES `core_zone` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=718 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `core_announcement`
--

LOCK TABLES `core_announcement` WRITE;
/*!40000 ALTER TABLE `core_announcement` DISABLE KEYS */;
INSERT INTO `core_announcement` VALUES (358,'matokeo tayari','aliefeli ajiandae na miboko','school','2026-10-11 21:53:02.322282','2026-10-11 21:53:02.322308',NULL,'2026-10-22 00:00:00.000000',1,NULL,NULL,NULL,NULL,NULL,'both'),(669,'kazeni wazee','we need best','district','2026-10-21 06:08:28.219421','2026-10-21 06:08:28.219451','2026-10-20 09:08:00.000000','2026-10-23 09:08:00.000000',1,NULL,36,NULL,NULL,NULL,'both');
/*!40000 ALTER TABLE `core_announcement` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `core_auditlog`
--

DROP TABLE IF EXISTS `core_auditlog`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `core_auditlog` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `action` varchar(50) NOT NULL,
  `model_name` varchar(100) NOT NULL,
  `object_id` varchar(64) NOT NULL,
  `changes` json NOT NULL,
  `created_at` datetime(6) NOT NULL,
  `actor_id` bigint DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `core_auditlog_actor_id_ab091f3c_fk_core_user_id` (`actor_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `core_auditlog`
--

LOCK TABLES `core_auditlog` WRITE;
/*!40000 ALTER TABLE `core_auditlog` DISABLE KEYS */;
/*!40000 ALTER TABLE `core_auditlog` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `core_clubteacher`
--

DROP TABLE IF EXISTS `core_clubteacher`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `core_clubteacher` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `assigned_at` datetime(6) NOT NULL,
  `club_id` bigint NOT NULL,
  `teacher_id` bigint NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `unique_teacher_per_club` (`club_id`,`teacher_id`),
  KEY `core_clubteacher_teacher_id_42140a14_fk_core_user_id` (`teacher_id`),
  CONSTRAINT `core_clubteacher_club_id_6ca7cfed_fk_core_schoolclub_id` FOREIGN KEY (`club_id`) REFERENCES `core_schoolclub` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `core_clubteacher`
--

LOCK TABLES `core_clubteacher` WRITE;
/*!40000 ALTER TABLE `core_clubteacher` DISABLE KEYS */;
/*!40000 ALTER TABLE `core_clubteacher` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `core_country`
--

DROP TABLE IF EXISTS `core_country`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `core_country` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `name` varchar(100) NOT NULL,
  `code` varchar(3) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `name` (`name`),
  UNIQUE KEY `code` (`code`)
) ENGINE=InnoDB AUTO_INCREMENT=154 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `core_country`
--

LOCK TABLES `core_country` WRITE;
/*!40000 ALTER TABLE `core_country` DISABLE KEYS */;
INSERT INTO `core_country` VALUES (1,'Tanzania','TZ'),(52,'Algeria','DZA'),(53,'Angola','AGO'),(54,'Benin','BEN'),(55,'Botswana','BWA'),(56,'Burkina Faso','BFA'),(57,'Burundi','BDI'),(58,'Cabo Verde','CPV'),(59,'Cameroon','CMR'),(60,'Central African Republic','CAF'),(61,'Chad','TCD'),(62,'Comoros','COM'),(63,'Democratic Republic of the Congo','COD'),(64,'Republic of the Congo','COG'),(65,'Cote d\'Ivoire','CIV'),(66,'Djibouti','DJI'),(67,'Egypt','EGY'),(68,'Equatorial Guinea','GNQ'),(69,'Eritrea','ERI'),(70,'Eswatini','SWZ'),(71,'Ethiopia','ETH'),(72,'Gabon','GAB'),(73,'Gambia','GMB'),(74,'Ghana','GHA'),(75,'Guinea','GIN'),(76,'Guinea-Bissau','GNB'),(77,'Kenya','KEN'),(78,'Lesotho','LSO'),(79,'Liberia','LBR'),(80,'Libya','LBY'),(81,'Madagascar','MDG'),(82,'Malawi','MWI'),(83,'Mali','MLI'),(84,'Mauritania','MRT'),(85,'Mauritius','MUS'),(86,'Morocco','MAR'),(87,'Mozambique','MOZ'),(88,'Namibia','NAM'),(89,'Niger','NER'),(90,'Nigeria','NGA'),(91,'Rwanda','RWA'),(92,'Sao Tome and Principe','STP'),(93,'Senegal','SEN'),(94,'Seychelles','SYC'),(95,'Sierra Leone','SLE'),(96,'Somalia','SOM'),(97,'South Africa','ZAF'),(98,'South Sudan','SSD'),(99,'Sudan','SDN'),(100,'Togo','TGO'),(101,'Tunisia','TUN'),(102,'Uganda','UGA'),(103,'Zambia','ZMB'),(104,'Zimbabwe','ZWE');
/*!40000 ALTER TABLE `core_country` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `core_countryclub`
--

DROP TABLE IF EXISTS `core_countryclub`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `core_countryclub` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `name` varchar(150) NOT NULL,
  `focus` varchar(200) NOT NULL,
  `description` longtext NOT NULL,
  `is_active` tinyint(1) NOT NULL,
  `created_at` datetime(6) NOT NULL,
  `updated_at` datetime(6) NOT NULL,
  `country_id` bigint NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `unique_country_club_name` (`country_id`,`name`),
  CONSTRAINT `core_countryclub_country_id_18ffe671_fk_core_country_id` FOREIGN KEY (`country_id`) REFERENCES `core_country` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=205 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `core_countryclub`
--

LOCK TABLES `core_countryclub` WRITE;
/*!40000 ALTER TABLE `core_countryclub` DISABLE KEYS */;
INSERT INTO `core_countryclub` VALUES (1,'Rumanyika Club','Singing, instrumental music, band, choir','',1,'2026-09-22 21:11:15.615645','2026-09-22 21:11:15.615706',1),(2,'Ibanda Club','traditional dance','',1,'2026-09-22 21:11:16.036579','2026-10-02 06:57:46.654269',1),(3,'Serengeti Club','Acting, directing, playwriting, stagecraft','',1,'2026-09-22 21:11:16.209805','2026-09-22 21:11:16.209835',1),(4,'Burigi Club','Football, basketball, track and field, gymnastics','',1,'2026-09-22 21:11:16.260642','2026-09-22 21:11:16.260685',1),(5,'Mikumi Club','Drawing, painting, digital art, sculpture','',1,'2026-09-22 21:11:16.465582','2026-09-22 21:11:16.465651',1),(6,'Mtagata Club','Cooking, baking, food decoration','',1,'2026-09-22 21:11:16.656164','2026-09-22 21:11:16.656232',1),(7,'Ngorongoro Club','Writing, public speaking, debate','',1,'2026-09-22 21:11:16.732948','2026-09-22 21:11:16.733020',1),(8,'Saanane Club','Robotics, coding, environmental science, innovation','',1,'2026-09-22 21:11:17.247257','2026-09-22 21:11:17.247328',1),(9,'Rubondo Club','Photography, videography, media production','',1,'2026-09-22 21:11:17.345689','2026-09-22 21:11:17.345759',1),(10,'Gombe Club','Community service, charity, and volunteering','',1,'2026-09-22 21:11:17.413418','2026-09-22 21:11:17.413532',1);
/*!40000 ALTER TABLE `core_countryclub` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `core_district`
--

DROP TABLE IF EXISTS `core_district`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `core_district` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `name` varchar(100) NOT NULL,
  `region_id` bigint NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `core_district_region_id_name_9cae94d1_uniq` (`region_id`,`name`),
  CONSTRAINT `core_district_region_id_c05a2f4a_fk` FOREIGN KEY (`region_id`) REFERENCES `core_region` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=205 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `core_district`
--

LOCK TABLES `core_district` WRITE;
/*!40000 ALTER TABLE `core_district` DISABLE KEYS */;
INSERT INTO `core_district` VALUES (35,'Biharamulo',1),(31,'Bukoba Rural',1),(30,'Bukoba Urban',1),(32,'Missenyi',1),(33,'Muleba',1),(34,'Ngara',1),(50,'Buhigwe',2),(53,'Kakonko',2),(51,'Kasulu',2),(52,'Kibondo',2),(49,'Kigoma Rural',2),(48,'Kigoma Urban',2),(55,'Tanganyika',2),(54,'Uvinza',2),(21,'Bukombe',3),(22,'Chato',3),(20,'Geita District',3),(23,'Mbogwe',3),(24,'Nyang\'hwale',3),(40,'Bugene',4),(42,'Bushangaro',4),(41,'Kituntu (Rwambaizi)',4),(37,'Kyerwa',4),(38,'Mabira',4),(43,'Murongo',4),(36,'Nkwenda',4),(39,'Nyaishozi',4),(110,'Buchosa',5),(104,'Ilemela',5),(108,'Kwimba',5),(107,'Magu',5),(106,'Misungwi',5),(103,'Nyamagana',5),(105,'Sengerema',5),(109,'Ukerewe',5),(80,'Bunda',6),(79,'Butiama',6),(76,'Musoma Rural',6),(75,'Musoma Urban',6),(77,'Rorya',6),(78,'Serengeti',6),(81,'Tarime',6),(140,'Bariadi',7),(141,'Busega',7),(142,'Itilima',7),(143,'Maswa',7),(144,'Meatu',7),(137,'Kahama',8),(138,'Kishapu',8),(136,'Shinyanga Rural',8),(135,'Shinyanga Urban',8),(139,'Ushetu',8),(158,'Igunga',9),(159,'Kaliua',9),(160,'Nzega',9),(161,'Sikonge',9),(157,'Tabora Rural',9),(156,'Tabora Urban',9),(162,'Urambo',9),(14,'Bahi',10),(15,'Chamwino',10),(16,'Chemba',10),(13,'Dodoma City',10),(17,'Kondoa',10),(18,'Kondoa Town Council',10),(19,'Mpwapwa',10),(147,'Ikungi',11),(149,'Iramba',11),(148,'Manyoni',11),(150,'Mkalama',11),(146,'Singida Rural',11),(145,'Singida Urban',11),(70,'Babati Rural',12),(69,'Babati Urban',12),(71,'Hanang',12),(72,'Kiteto',12),(73,'Mbulu',12),(74,'Simanjiro',12),(1,'Arusha City',13),(2,'Arusha District',13),(3,'Karatu',13),(4,'Longido',13),(5,'Meru',13),(6,'Monduli',13),(7,'Ngorongoro',13),(58,'Hai',14),(57,'Moshi Rural',14),(56,'Moshi Urban',14),(60,'Mwanga',14),(61,'Rombo',14),(62,'Same',14),(59,'Siha',14),(170,'Bumbuli',15),(167,'Handeni',15),(171,'Handeni Town',15),(168,'Kilindi',15),(165,'Korogwe',15),(172,'Korogwe Town',15),(166,'Lushoto',15),(169,'Mkinga',15),(164,'Muheza',15),(163,'Tanga City',15),(8,'Ilala',16),(12,'Kigamboni',16),(9,'Kinondoni',16),(10,'Temeke',16),(11,'Ubungo',16),(119,'Bagamoyo',17),(120,'Chalinze',17),(118,'Kibaha District',17),(117,'Kibaha Town',17),(121,'Kisarawe',17),(122,'Mafia',17),(123,'Mkuranga',17),(124,'Rufiji',17),(92,'Gairo',18),(91,'Kilombero',18),(93,'Kilosa',18),(94,'Malinyi',18),(90,'Morogoro Rural',18),(89,'Morogoro Urban',18),(95,'Ulanga',18),(114,'Ludewa',19),(113,'Makambako',19),(115,'Makete',19),(112,'Njombe Rural',19),(111,'Njombe Urban',19),(116,'Wanging\'ombe',19),(26,'Iringa Rural',20),(25,'Iringa Urban',20),(29,'Kilolo',20),(27,'Mafinga',20),(28,'Mufindi',20),(88,'Busokelo',21),(84,'Chunya',21),(85,'Kyela',21),(86,'Mbarali',21),(82,'Mbeya City',21),(83,'Mbeya District',21),(87,'Rungwe',21),(63,'Kilwa',22),(66,'Lindi Municipal',22),(68,'Liwale',22),(67,'Mtama',22),(64,'Nachingwea',22),(65,'Ruangwa',22),(98,'Masasi',23),(101,'Mtwara Mikindani',23),(97,'Mtwara Rural',23),(96,'Mtwara Urban',23),(99,'Nanyumbu',23),(100,'Newala',23),(102,'Tandahimba',23),(131,'Mbinga',24),(132,'Namtumbo',24),(133,'Nyasa',24),(130,'Songea Rural',24),(129,'Songea Urban',24),(134,'Tunduru',24),(152,'Ileje',25),(153,'Mbozi',25),(154,'Momba',25),(151,'Songwe',25),(155,'Tunduma',25),(128,'Kalambo',26),(127,'Nkasi',26),(126,'Sumbawanga Rural',26),(125,'Sumbawanga Urban',26),(46,'Mlele',27),(45,'Mpanda Rural',27),(44,'Mpanda Urban',27),(47,'Nsimbo',27),(173,'Magharibi',28),(174,'Mjini',28),(175,'Micheweni',29),(176,'Wete',29),(177,'Chake Chake',30),(178,'Mkoani',30),(179,'Kaskazini A',31),(180,'Kaskazini B',31),(181,'Kati',32),(182,'Kusini',32);
/*!40000 ALTER TABLE `core_district` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `core_evaluationcriterion`
--

DROP TABLE IF EXISTS `core_evaluationcriterion`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `core_evaluationcriterion` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `name` varchar(100) NOT NULL,
  `description` longtext NOT NULL,
  `weight` decimal(5,2) NOT NULL,
  `is_active` tinyint(1) NOT NULL,
  `talent_id` bigint NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `unique_criterion_per_talent` (`talent_id`,`name`),
  CONSTRAINT `core_evaluationcriterion_talent_id_792863fb_fk` FOREIGN KEY (`talent_id`) REFERENCES `core_talent` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=154 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `core_evaluationcriterion`
--

LOCK TABLES `core_evaluationcriterion` WRITE;
/*!40000 ALTER TABLE `core_evaluationcriterion` DISABLE KEYS */;
INSERT INTO `core_evaluationcriterion` VALUES (1,'Creativity','Originality and creative expression',30.00,1,1),(2,'Technical Skill','Control and technical ability',30.00,1,1),(3,'Presentation','Clarity, confidence, and presentation',25.00,1,1),(4,'Effort','Preparation and commitment',15.00,1,1),(5,'Creativity','Originality and creative expression',30.00,1,2),(6,'Technical Skill','Control and technical ability',30.00,1,2),(7,'Presentation','Clarity, confidence, and presentation',25.00,1,2),(8,'Effort','Preparation and commitment',15.00,1,2),(9,'Creativity','Originality and creative expression',30.00,1,3),(10,'Technical Skill','Control and technical ability',30.00,1,3),(11,'Presentation','Clarity, confidence, and presentation',25.00,1,3),(12,'Effort','Preparation and commitment',15.00,1,3),(13,'Creativity','Originality and creative expression',30.00,1,4),(14,'Technical Skill','Control and technical ability',30.00,1,4),(15,'Presentation','Clarity, confidence, and presentation',25.00,1,4),(16,'Effort','Preparation and commitment',15.00,1,4),(17,'Creativity','Originality and creative expression',30.00,1,5),(18,'Technical Skill','Control and technical ability',30.00,1,5),(19,'Presentation','Clarity, confidence, and presentation',25.00,1,5),(20,'Effort','Preparation and commitment',15.00,1,5),(21,'Creativity','Originality and creative expression',30.00,1,6),(22,'Technical Skill','Control and technical ability',30.00,1,6),(23,'Presentation','Clarity, confidence, and presentation',25.00,1,6),(24,'Effort','Preparation and commitment',15.00,1,6),(25,'Creativity','Originality and creative expression',30.00,1,7),(26,'Technical Skill','Control and technical ability',30.00,1,7),(27,'Presentation','Clarity, confidence, and presentation',25.00,1,7),(28,'Effort','Preparation and commitment',15.00,1,7),(29,'Creativity','Originality and creative expression',30.00,1,8),(30,'Technical Skill','Control and technical ability',30.00,1,8),(31,'Presentation','Clarity, confidence, and presentation',25.00,1,8),(32,'Effort','Preparation and commitment',15.00,1,8),(33,'Creativity','Originality and creative expression',30.00,1,9),(34,'Technical Skill','Control and technical ability',30.00,1,9),(35,'Presentation','Clarity, confidence, and presentation',25.00,1,9),(36,'Effort','Preparation and commitment',15.00,1,9),(37,'Creativity','Originality and creative expression',30.00,1,10),(38,'Technical Skill','Control and technical ability',30.00,1,10),(39,'Presentation','Clarity, confidence, and presentation',25.00,1,10),(40,'Effort','Preparation and commitment',15.00,1,10),(41,'Creativity','Originality and creative expression',30.00,1,11),(42,'Technical Skill','Control and technical ability',30.00,1,11),(43,'Presentation','Clarity, confidence, and presentation',25.00,1,11),(44,'Effort','Preparation and commitment',15.00,1,11),(45,'Creativity','Originality and creative expression',30.00,1,12),(46,'Technical Skill','Control and technical ability',30.00,1,12),(47,'Presentation','Clarity, confidence, and presentation',25.00,1,12),(48,'Effort','Preparation and commitment',15.00,1,12),(49,'Creativity','Originality and creative expression',30.00,1,13),(50,'Technical Skill','Control and technical ability',30.00,1,13),(51,'Presentation','Clarity, confidence, and presentation',25.00,1,13),(52,'Effort','Preparation and commitment',15.00,1,13),(53,'Creativity','Originality and creative expression',30.00,1,14),(54,'Technical Skill','Control and technical ability',30.00,1,14),(55,'Presentation','Clarity, confidence, and presentation',25.00,1,14),(56,'Effort','Preparation and commitment',15.00,1,14),(57,'Creativity','Originality and creative expression',30.00,1,15),(58,'Technical Skill','Control and technical ability',30.00,1,15),(59,'Presentation','Clarity, confidence, and presentation',25.00,1,15),(60,'Effort','Preparation and commitment',15.00,1,15),(61,'Creativity','Originality and creative expression',30.00,1,16),(62,'Technical Skill','Control and technical ability',30.00,1,16),(63,'Presentation','Clarity, confidence, and presentation',25.00,1,16),(64,'Effort','Preparation and commitment',15.00,1,16),(65,'Creativity','Originality and creative expression',30.00,1,17),(66,'Technical Skill','Control and technical ability',30.00,1,17),(67,'Presentation','Clarity, confidence, and presentation',25.00,1,17),(68,'Effort','Preparation and commitment',15.00,1,17),(69,'Creativity','Originality and creative expression',30.00,1,18),(70,'Technical Skill','Control and technical ability',30.00,1,18),(71,'Presentation','Clarity, confidence, and presentation',25.00,1,18),(72,'Effort','Preparation and commitment',15.00,1,18),(73,'Creativity','Originality and creative expression',30.00,1,19),(74,'Technical Skill','Control and technical ability',30.00,1,19),(75,'Presentation','Clarity, confidence, and presentation',25.00,1,19),(76,'Effort','Preparation and commitment',15.00,1,19),(81,'Creativity','Originality and creative expression',30.00,1,21),(82,'Technical Skill','Control and technical ability',30.00,1,21),(83,'Presentation','Clarity, confidence, and presentation',25.00,1,21),(84,'Effort','Preparation and commitment',15.00,1,21),(85,'Creativity','Originality and creative expression',30.00,1,22),(86,'Technical Skill','Control and technical ability',30.00,1,22),(87,'Presentation','Clarity, confidence, and presentation',25.00,1,22),(88,'Effort','Preparation and commitment',15.00,1,22),(89,'Creativity','Originality and creative expression',30.00,1,23),(90,'Technical Skill','Control and technical ability',30.00,1,23),(91,'Presentation','Clarity, confidence, and presentation',25.00,1,23),(92,'Effort','Preparation and commitment',15.00,1,23),(93,'Creativity','Originality and creative expression',30.00,1,24),(94,'Technical Skill','Control and technical ability',30.00,1,24),(95,'Presentation','Clarity, confidence, and presentation',25.00,1,24),(96,'Effort','Preparation and commitment',15.00,1,24),(97,'Creativity','Originality and creative expression',30.00,1,25),(98,'Technical Skill','Control and technical ability',30.00,1,25),(99,'Presentation','Clarity, confidence, and presentation',25.00,1,25),(100,'Effort','Preparation and commitment',15.00,1,25),(101,'Creativity','Originality and creative expression',30.00,1,26),(102,'Technical Skill','Control and technical ability',30.00,1,26),(103,'Presentation','Clarity, confidence, and presentation',25.00,1,26),(104,'Effort','Preparation and commitment',15.00,1,26),(105,'Creativity','Originality and creative expression',30.00,1,27),(106,'Technical Skill','Control and technical ability',30.00,1,27),(107,'Presentation','Clarity, confidence, and presentation',25.00,1,27),(108,'Effort','Preparation and commitment',15.00,1,27),(109,'Creativity','Originality and creative expression',30.00,1,28),(110,'Technical Skill','Control and technical ability',30.00,1,28),(111,'Presentation','Clarity, confidence, and presentation',25.00,1,28),(112,'Effort','Preparation and commitment',15.00,1,28),(113,'Creativity','Originality and creative expression',30.00,1,29),(114,'Technical Skill','Control and technical ability',30.00,1,29),(115,'Presentation','Clarity, confidence, and presentation',25.00,1,29),(116,'Effort','Preparation and commitment',15.00,1,29),(117,'Creativity','Originality and creative expression',30.00,1,30),(118,'Technical Skill','Control and technical ability',30.00,1,30),(119,'Presentation','Clarity, confidence, and presentation',25.00,1,30),(120,'Effort','Preparation and commitment',15.00,1,30),(121,'Creativity','Originality and creative expression',30.00,1,31),(122,'Technical Skill','Control and technical ability',30.00,1,31),(123,'Presentation','Clarity, confidence, and presentation',25.00,1,31),(124,'Effort','Preparation and commitment',15.00,1,31),(125,'Creativity','Originality and creative expression',30.00,1,32),(126,'Technical Skill','Control and technical ability',30.00,1,32),(127,'Presentation','Clarity, confidence, and presentation',25.00,1,32),(128,'Effort','Preparation and commitment',15.00,1,32);
/*!40000 ALTER TABLE `core_evaluationcriterion` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `core_evaluationscore`
--

DROP TABLE IF EXISTS `core_evaluationscore`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `core_evaluationscore` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `score` decimal(5,2) NOT NULL,
  `comment` longtext NOT NULL,
  `criterion_id` bigint NOT NULL,
  `evaluation_id` bigint NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `unique_score_per_criterion` (`evaluation_id`,`criterion_id`),
  KEY `core_evaluationscore_criterion_id_be7cb78a_fk` (`criterion_id`),
  CONSTRAINT `core_evaluationscore_criterion_id_be7cb78a_fk` FOREIGN KEY (`criterion_id`) REFERENCES `core_evaluationcriterion` (`id`),
  CONSTRAINT `core_evaluationscore_evaluation_id_61c9414d_fk` FOREIGN KEY (`evaluation_id`) REFERENCES `core_talentevaluation` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `core_evaluationscore`
--

LOCK TABLES `core_evaluationscore` WRITE;
/*!40000 ALTER TABLE `core_evaluationscore` DISABLE KEYS */;
/*!40000 ALTER TABLE `core_evaluationscore` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `core_message`
--

DROP TABLE IF EXISTS `core_message`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `core_message` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `subject` varchar(200) NOT NULL,
  `body` longtext NOT NULL,
  `created_at` datetime(6) NOT NULL,
  `read_at` datetime(6) DEFAULT NULL,
  `recipient_id` bigint NOT NULL,
  `sender_id` int NOT NULL,
  PRIMARY KEY (`id`),
  KEY `core_message_recipient_id_f6c91824_fk_core_user_id` (`recipient_id`),
  KEY `core_message_sender_id_0ecf4560_fk_core_user_id` (`sender_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `core_message`
--

LOCK TABLES `core_message` WRITE;
/*!40000 ALTER TABLE `core_message` DISABLE KEYS */;
/*!40000 ALTER TABLE `core_message` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `core_notification`
--

DROP TABLE IF EXISTS `core_notification`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `core_notification` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `title` varchar(200) NOT NULL,
  `body` longtext NOT NULL,
  `link` varchar(255) NOT NULL,
  `read_at` datetime(6) DEFAULT NULL,
  `created_at` datetime(6) NOT NULL,
  `recipient_id` bigint NOT NULL,
  PRIMARY KEY (`id`),
  KEY `core_notification_recipient_id_24a3d95c_fk_core_user_id` (`recipient_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `core_notification`
--

LOCK TABLES `core_notification` WRITE;
/*!40000 ALTER TABLE `core_notification` DISABLE KEYS */;
/*!40000 ALTER TABLE `core_notification` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `core_parent`
--

DROP TABLE IF EXISTS `core_parent`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `core_parent` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `username` varchar(50) NOT NULL,
  `password` varchar(255) NOT NULL,
  `full_name` varchar(100) NOT NULL,
  `phone` varchar(20) NOT NULL,
  `email` varchar(254) DEFAULT NULL,
  `created_at` datetime(6) NOT NULL,
  `user_id` bigint DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `username` (`username`),
  UNIQUE KEY `user_id` (`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `core_parent`
--

LOCK TABLES `core_parent` WRITE;
/*!40000 ALTER TABLE `core_parent` DISABLE KEYS */;
/*!40000 ALTER TABLE `core_parent` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `core_region`
--

DROP TABLE IF EXISTS `core_region`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `core_region` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `name` varchar(100) NOT NULL,
  `zone_id` int NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `core_region_zone_id_name_afec0111_uniq` (`zone_id`,`name`),
  CONSTRAINT `core_region_zone_id_72bf00fa_fk` FOREIGN KEY (`zone_id`) REFERENCES `core_zone` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=103 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `core_region`
--

LOCK TABLES `core_region` WRITE;
/*!40000 ALTER TABLE `core_region` DISABLE KEYS */;
INSERT INTO `core_region` VALUES (3,'Geita',1),(1,'Kagera',1),(4,'Karagwe',1),(2,'Kigoma',1),(6,'Mara',2),(5,'Mwanza',2),(7,'Simiyu',2),(8,'Shinyanga',3),(9,'Tabora',3),(52,'dds',4),(10,'Dodoma',4),(11,'Singida',4),(13,'Arusha',5),(14,'Kilimanjaro',5),(12,'Manyara',5),(15,'Tanga',5),(16,'Dar es Salaam',6),(18,'Morogoro',6),(17,'Pwani',6),(20,'Iringa',7),(21,'Mbeya',7),(19,'Njombe',7),(22,'Lindi',8),(23,'Mtwara',8),(24,'Ruvuma',8),(27,'Katavi',9),(26,'Rukwa',9),(25,'Songwe',9),(28,'Mjini Magharibi',10),(29,'Pemba North',10),(30,'Pemba South',10),(31,'Unguja North',10),(32,'Unguja South',10);
/*!40000 ALTER TABLE `core_region` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `core_school`
--

DROP TABLE IF EXISTS `core_school`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `core_school` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `registry_number` varchar(50) NOT NULL,
  `name` varchar(150) NOT NULL,
  `ownership_type` varchar(100) NOT NULL,
  `phone` varchar(20) DEFAULT NULL,
  `email` varchar(254) DEFAULT NULL,
  `created_at` datetime(6) NOT NULL,
  `country_id` bigint NOT NULL,
  `district_id` bigint DEFAULT NULL,
  `region_id` bigint DEFAULT NULL,
  `ward_id` int DEFAULT NULL,
  `zone_id` int DEFAULT NULL,
  `student_count` int unsigned NOT NULL,
  `is_approved` tinyint(1) NOT NULL,
  `physical_address` varchar(255) NOT NULL,
  `city_council` varchar(150) NOT NULL,
  `street_village` varchar(150) NOT NULL,
  `is_active` tinyint(1) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `registry_number` (`registry_number`),
  KEY `core_school_country_id_89f537c9_fk` (`country_id`),
  KEY `core_school_district_id_4a91fd2e_fk_core_district_id` (`district_id`),
  KEY `core_school_region_id_0749cc2d_fk_core_region_id` (`region_id`),
  KEY `repair_school_ward_id_fk` (`ward_id`),
  KEY `repair_school_zone_id_fk` (`zone_id`),
  CONSTRAINT `core_school_country_id_89f537c9_fk` FOREIGN KEY (`country_id`) REFERENCES `core_country` (`id`),
  CONSTRAINT `core_school_district_id_4a91fd2e_fk_core_district_id` FOREIGN KEY (`district_id`) REFERENCES `core_district` (`id`),
  CONSTRAINT `core_school_region_id_0749cc2d_fk_core_region_id` FOREIGN KEY (`region_id`) REFERENCES `core_region` (`id`),
  CONSTRAINT `repair_school_ward_id_fk` FOREIGN KEY (`ward_id`) REFERENCES `core_ward` (`id`),
  CONSTRAINT `repair_school_zone_id_fk` FOREIGN KEY (`zone_id`) REFERENCES `core_zone` (`id`),
  CONSTRAINT `core_school_chk_1` CHECK ((`student_count` >= 0))
) ENGINE=InnoDB AUTO_INCREMENT=871 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `core_school`
--

LOCK TABLES `core_school` WRITE;
/*!40000 ALTER TABLE `core_school` DISABLE KEYS */;
INSERT INTO `core_school` VALUES (769,'S0667','Nyaishozi Secondary School','Private','+255746089654',NULL,'2026-10-21 05:21:14.815722',1,36,4,797,1,0,1,'KAKANJA','','',1),(770,'S.0778','Ndagara Sec School','Private','+255745698765',NULL,'2026-10-21 05:23:53.112586',1,36,4,795,1,0,1,'ITERA','','',1),(771,'S.342','Mambwe High School','Government','+255765432897',NULL,'2026-10-21 05:25:25.633245',1,36,4,798,1,0,1,'KIMULI','','',1);
/*!40000 ALTER TABLE `core_school` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `core_schoolclub`
--

DROP TABLE IF EXISTS `core_schoolclub`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `core_schoolclub` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `is_active` tinyint(1) NOT NULL,
  `selected_at` datetime(6) NOT NULL,
  `country_club_id` bigint NOT NULL,
  `school_id` bigint NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `unique_school_club_selection` (`school_id`,`country_club_id`),
  KEY `core_schoolclub_country_club_id_22721bcc_fk_core_countryclub_id` (`country_club_id`),
  CONSTRAINT `core_schoolclub_country_club_id_22721bcc_fk_core_countryclub_id` FOREIGN KEY (`country_club_id`) REFERENCES `core_countryclub` (`id`),
  CONSTRAINT `core_schoolclub_school_id_8c9bab69_fk_core_school_id` FOREIGN KEY (`school_id`) REFERENCES `core_school` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=574 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `core_schoolclub`
--

LOCK TABLES `core_schoolclub` WRITE;
/*!40000 ALTER TABLE `core_schoolclub` DISABLE KEYS */;
INSERT INTO `core_schoolclub` VALUES (523,1,'2026-10-21 05:47:51.395199',2,770),(524,1,'2026-10-21 05:47:51.395236',6,770),(525,1,'2026-10-21 05:47:51.395251',1,770),(526,1,'2026-10-21 06:15:41.559479',2,769),(527,1,'2026-10-21 06:15:41.559518',6,769),(528,1,'2026-10-21 06:15:41.559532',1,769),(529,1,'2026-10-21 06:32:18.065968',2,771),(530,1,'2026-10-21 06:32:18.065997',6,771),(531,1,'2026-10-21 06:32:18.066009',1,771);
/*!40000 ALTER TABLE `core_schoolclub` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `core_schoolownershiptype`
--

DROP TABLE IF EXISTS `core_schoolownershiptype`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `core_schoolownershiptype` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `name` varchar(100) NOT NULL,
  `is_active` tinyint(1) NOT NULL,
  `created_at` datetime(6) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `name` (`name`)
) ENGINE=InnoDB AUTO_INCREMENT=52 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `core_schoolownershiptype`
--

LOCK TABLES `core_schoolownershiptype` WRITE;
/*!40000 ALTER TABLE `core_schoolownershiptype` DISABLE KEYS */;
INSERT INTO `core_schoolownershiptype` VALUES (1,'Government',1,'2026-09-23 05:41:17.681660'),(2,'Private',1,'2026-09-23 05:41:18.420925'),(3,'Organization',1,'2026-09-23 05:41:18.591011'),(4,'Lutheran',1,'2026-09-23 05:41:18.737920'),(5,'Roman Catholic',1,'2026-09-23 05:41:18.892216'),(6,'SDA',1,'2026-09-23 05:41:19.069456'),(7,'Company',1,'2026-09-23 05:41:19.439558'),(8,'Sunni',1,'2026-09-23 05:41:19.623781'),(9,'Pentecoste',1,'2026-09-23 05:41:19.947647'),(10,'Shia',1,'2026-09-23 05:41:20.068966'),(11,'Aglican',1,'2026-09-23 05:41:20.238579'),(12,'Moravian',1,'2026-09-23 05:41:20.454026'),(13,'Hindu',1,'2026-09-23 05:41:20.561179'),(14,'Ahmadiyya',1,'2026-09-23 05:41:20.761462'),(15,'Other',1,'2026-09-23 05:41:20.880240');
/*!40000 ALTER TABLE `core_schoolownershiptype` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `core_studentclubmembership`
--

DROP TABLE IF EXISTS `core_studentclubmembership`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `core_studentclubmembership` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `joined_at` datetime(6) NOT NULL,
  `left_at` datetime(6) DEFAULT NULL,
  `is_active` tinyint(1) NOT NULL,
  `transfer_reason` longtext NOT NULL,
  `club_id` bigint NOT NULL,
  `student_id` bigint NOT NULL,
  `active_student_id` bigint GENERATED ALWAYS AS ((case when (`is_active` = 1) then `student_id` else NULL end)) STORED,
  PRIMARY KEY (`id`),
  UNIQUE KEY `unique_student_club_membership` (`student_id`,`club_id`),
  UNIQUE KEY `one_active_club_per_student` (`active_student_id`),
  KEY `core_studentclubmemb_club_id_68125181_fk_core_scho` (`club_id`),
  CONSTRAINT `core_studentclubmemb_club_id_68125181_fk_core_scho` FOREIGN KEY (`club_id`) REFERENCES `core_schoolclub` (`id`),
  CONSTRAINT `core_studentclubmembership_student_id_c6b3f3c1_fk` FOREIGN KEY (`student_id`) REFERENCES `students_student` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=669 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `core_studentclubmembership`
--

LOCK TABLES `core_studentclubmembership` WRITE;
/*!40000 ALTER TABLE `core_studentclubmembership` DISABLE KEYS */;
INSERT INTO `core_studentclubmembership` (`id`, `joined_at`, `left_at`, `is_active`, `transfer_reason`, `club_id`, `student_id`) VALUES (618,'2026-10-21 05:49:08.720596',NULL,1,'',523,667),(619,'2026-10-21 05:50:15.564271',NULL,1,'',523,668),(620,'2026-10-21 05:51:12.526583',NULL,1,'',523,669),(621,'2026-10-21 05:52:04.222191',NULL,1,'',523,670),(622,'2026-10-21 05:55:39.332834',NULL,1,'',525,671),(623,'2026-10-21 05:56:42.708008',NULL,1,'',523,672),(624,'2026-10-21 06:17:17.985810',NULL,1,'',527,673),(625,'2026-10-21 06:18:14.812485',NULL,1,'',527,674),(626,'2026-10-21 06:19:06.874561',NULL,1,'',527,675),(627,'2026-10-21 06:21:06.110711',NULL,1,'',527,676),(628,'2026-10-21 06:33:39.437492',NULL,1,'',531,677),(629,'2026-10-21 06:34:47.214457',NULL,1,'',531,678),(630,'2026-10-21 06:35:38.498649',NULL,1,'',531,679),(631,'2026-10-21 06:36:36.041403',NULL,1,'',531,680),(632,'2026-10-21 06:37:19.936302',NULL,1,'',531,681),(633,'2026-10-21 06:38:12.679364',NULL,1,'',531,682);
/*!40000 ALTER TABLE `core_studentclubmembership` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `core_studenttalent`
--

DROP TABLE IF EXISTS `core_studenttalent`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `core_studenttalent` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `proficiency_level` int NOT NULL,
  `notes` longtext NOT NULL,
  `added_at` datetime(6) NOT NULL,
  `student_id` bigint NOT NULL,
  `talent_id` bigint NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `core_studenttalent_student_id_talent_id_6cdca006_uniq` (`student_id`,`talent_id`),
  KEY `core_studenttalent_talent_id_91c19197_fk` (`talent_id`),
  CONSTRAINT `core_studenttalent_student_id_554f99d2_fk` FOREIGN KEY (`student_id`) REFERENCES `students_student` (`id`),
  CONSTRAINT `core_studenttalent_talent_id_91c19197_fk` FOREIGN KEY (`talent_id`) REFERENCES `core_talent` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=718 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `core_studenttalent`
--

LOCK TABLES `core_studenttalent` WRITE;
/*!40000 ALTER TABLE `core_studenttalent` DISABLE KEYS */;
INSERT INTO `core_studenttalent` VALUES (667,1,'','2026-10-21 05:49:08.722818',667,17),(668,1,'','2026-10-21 05:50:15.565567',668,17),(669,1,'','2026-10-21 05:51:12.528686',669,18),(670,1,'','2026-10-21 05:52:04.224262',670,17),(671,1,'','2026-10-21 05:55:39.334442',671,18),(672,1,'','2026-10-21 05:56:42.709941',672,18),(673,1,'','2026-10-21 06:17:17.986935',673,18),(674,1,'','2026-10-21 06:18:14.813684',674,18),(675,1,'','2026-10-21 06:19:06.875827',675,18),(676,1,'','2026-10-21 06:21:06.111897',676,18),(677,1,'','2026-10-21 06:33:39.438927',677,18),(678,1,'','2026-10-21 06:34:22.682820',678,18),(679,1,'','2026-10-21 06:35:38.499850',679,18),(680,1,'','2026-10-21 06:36:36.042864',680,18),(681,1,'','2026-10-21 06:37:19.937679',681,18),(682,1,'','2026-10-21 06:38:12.680399',682,18);
/*!40000 ALTER TABLE `core_studenttalent` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `core_submissionfeedback`
--

DROP TABLE IF EXISTS `core_submissionfeedback`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `core_submissionfeedback` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `content` longtext NOT NULL,
  `created_at` datetime(6) NOT NULL,
  `author_id` int NOT NULL,
  `submission_id` bigint NOT NULL,
  PRIMARY KEY (`id`),
  KEY `core_submissionfeedback_author_id_abb99aab_fk_core_user_id` (`author_id`),
  KEY `core_submissionfeedback_submission_id_601a36a4_fk` (`submission_id`),
  CONSTRAINT `core_submissionfeedback_submission_id_601a36a4_fk` FOREIGN KEY (`submission_id`) REFERENCES `core_talentsubmission` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `core_submissionfeedback`
--

LOCK TABLES `core_submissionfeedback` WRITE;
/*!40000 ALTER TABLE `core_submissionfeedback` DISABLE KEYS */;
/*!40000 ALTER TABLE `core_submissionfeedback` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `core_talent`
--

DROP TABLE IF EXISTS `core_talent`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `core_talent` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `name` varchar(100) NOT NULL,
  `description` longtext NOT NULL,
  `created_at` datetime(6) NOT NULL,
  `category_id` bigint NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `name` (`name`),
  KEY `core_talent_category_id_8b853260_fk_core_talentcategory_id` (`category_id`),
  CONSTRAINT `core_talent_category_id_8b853260_fk_core_talentcategory_id` FOREIGN KEY (`category_id`) REFERENCES `core_talentcategory` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=103 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `core_talent`
--

LOCK TABLES `core_talent` WRITE;
/*!40000 ALTER TABLE `core_talent` DISABLE KEYS */;
INSERT INTO `core_talent` VALUES (1,'Classical Music','Music talent','2026-08-25 19:21:14.947513',3),(2,'Contemporary Music','Music talent','2026-08-25 19:21:16.168566',3),(3,'Choir Singing','Music talent','2026-08-25 19:21:16.193479',3),(4,'Composition','Music talent','2026-08-25 19:21:16.218839',3),(5,'Ballet','Dance talent','2026-08-25 19:21:16.243026',2),(6,'Hip-Hop Dance','Dance talent','2026-08-25 19:21:16.269320',2),(7,'Contemporary Dance','Dance talent','2026-08-25 19:21:16.295764',2),(8,'Traditional Cultural Dance','Dance talent','2026-08-25 19:21:16.321375',2),(9,'Acting','Theater/Drama talent','2026-08-25 19:21:16.542897',2),(10,'Dramatic Monologue','Theater/Drama talent','2026-08-25 19:21:16.830539',2),(11,'Improvisation','Theater/Drama talent','2026-08-25 19:21:17.329791',2),(12,'Stage Design','Theater/Drama talent','2026-08-25 19:21:17.349073',2),(13,'Painting','Visual Arts talent','2026-08-25 19:21:17.374524',2),(14,'Sculpting','Visual Arts talent','2026-08-25 19:21:17.394837',2),(15,'Photography','Visual Arts talent','2026-08-25 19:21:17.415372',2),(16,'Graphic Design','Visual Arts talent','2026-08-25 19:21:17.437089',2),(17,'Poetry','Literary Arts talent','2026-08-25 19:21:17.456847',1),(18,'Story Writing','Literary Arts talent','2026-08-25 19:21:17.476052',1),(19,'Public Speaking','Literary Arts talent','2026-08-25 19:21:17.496868',1),(21,'Basketball','Sports Talent talent','2026-08-25 19:21:17.540869',4),(22,'Soccer','Sports Talent talent','2026-08-25 19:21:17.562080',4),(23,'Swimming','Sports Talent talent','2026-08-25 19:21:17.582880',4),(24,'Track and Field','Sports Talent talent','2026-08-25 19:21:17.603706',4),(25,'Gymnastics','Sports Talent talent','2026-08-25 19:21:17.623716',4),(26,'Cooking','Culinary Arts talent','2026-08-25 19:21:17.977076',2),(27,'Baking','Culinary Arts talent','2026-08-25 19:21:18.001582',2),(28,'Food Photography','Culinary Arts talent','2026-08-25 19:21:18.027614',2),(29,'Robotics','Technology talent','2026-08-25 19:21:18.053559',5),(30,'Game Development','Technology talent','2026-08-25 19:21:18.398762',5),(31,'Web Development','Technology talent','2026-08-25 19:21:18.424743',5),(32,'3D Printing','Technology talent','2026-08-25 19:21:18.451333',5),(52,'kiswahili','best','2026-09-23 22:51:40.778972',1);
/*!40000 ALTER TABLE `core_talent` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `core_talentcategory`
--

DROP TABLE IF EXISTS `core_talentcategory`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `core_talentcategory` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `name` varchar(100) NOT NULL,
  `description` longtext NOT NULL,
  `is_active` tinyint(1) NOT NULL,
  `created_at` datetime(6) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `name` (`name`)
) ENGINE=InnoDB AUTO_INCREMENT=103 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `core_talentcategory`
--

LOCK TABLES `core_talentcategory` WRITE;
/*!40000 ALTER TABLE `core_talentcategory` DISABLE KEYS */;
INSERT INTO `core_talentcategory` VALUES (1,'Academics','Category for Academics',1,'2026-09-09 14:57:23.438488'),(2,'Arts','Category for Arts',1,'2026-09-09 14:57:23.489831'),(3,'Music','Category for Music',1,'2026-09-09 14:57:23.525164'),(4,'Sports','Category for Sports',1,'2026-09-09 14:57:23.537479'),(5,'Technology','Category for Technology',1,'2026-09-09 14:57:23.549770'),(52,'Other','Category for Other',1,'2026-09-30 20:19:49.051548');
/*!40000 ALTER TABLE `core_talentcategory` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `core_talentevaluation`
--

DROP TABLE IF EXISTS `core_talentevaluation`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `core_talentevaluation` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `total_score` decimal(5,2) NOT NULL,
  `passed` tinyint(1) NOT NULL,
  `feedback` longtext NOT NULL,
  `evaluated_at` datetime(6) NOT NULL,
  `updated_at` datetime(6) NOT NULL,
  `evaluator_id` int NOT NULL,
  `student_talent_id` bigint NOT NULL,
  `grade` varchar(2) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `core_talentevaluation_evaluator_id_d0dcd9d1_fk_core_user_id` (`evaluator_id`),
  KEY `core_talentevaluation_student_talent_id_9ed74bab_fk` (`student_talent_id`),
  CONSTRAINT `core_talentevaluation_student_talent_id_9ed74bab_fk` FOREIGN KEY (`student_talent_id`) REFERENCES `core_studenttalent` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `core_talentevaluation`
--

LOCK TABLES `core_talentevaluation` WRITE;
/*!40000 ALTER TABLE `core_talentevaluation` DISABLE KEYS */;
/*!40000 ALTER TABLE `core_talentevaluation` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `core_talentsubmission`
--

DROP TABLE IF EXISTS `core_talentsubmission`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `core_talentsubmission` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `title` varchar(200) NOT NULL,
  `description` longtext NOT NULL,
  `media` varchar(100) NOT NULL,
  `status` varchar(20) NOT NULL,
  `submitted_at` datetime(6) NOT NULL,
  `reviewed_at` datetime(6) DEFAULT NULL,
  `club_id` bigint DEFAULT NULL,
  `reviewed_by_id` bigint DEFAULT NULL,
  `student_id` bigint NOT NULL,
  `talent_id` bigint NOT NULL,
  PRIMARY KEY (`id`),
  KEY `core_talentsubmission_reviewed_by_id_764c92b1_fk_core_user_id` (`reviewed_by_id`),
  KEY `core_talentsubmission_talent_id_7f9b25e0_fk` (`talent_id`),
  KEY `core_talentsubmission_student_id_28b60b91_fk` (`student_id`),
  KEY `core_talentsubmission_club_id_897ac678_fk_core_schoolclub_id` (`club_id`),
  CONSTRAINT `core_talentsubmission_club_id_897ac678_fk_core_schoolclub_id` FOREIGN KEY (`club_id`) REFERENCES `core_schoolclub` (`id`),
  CONSTRAINT `core_talentsubmission_student_id_28b60b91_fk` FOREIGN KEY (`student_id`) REFERENCES `students_student` (`id`),
  CONSTRAINT `core_talentsubmission_talent_id_7f9b25e0_fk` FOREIGN KEY (`talent_id`) REFERENCES `core_talent` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `core_talentsubmission`
--

LOCK TABLES `core_talentsubmission` WRITE;
/*!40000 ALTER TABLE `core_talentsubmission` DISABLE KEYS */;
/*!40000 ALTER TABLE `core_talentsubmission` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `core_user`
--

DROP TABLE IF EXISTS `core_user`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `core_user` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `password` varchar(128) NOT NULL,
  `last_login` datetime(6) DEFAULT NULL,
  `is_superuser` tinyint(1) NOT NULL,
  `username` varchar(150) NOT NULL,
  `first_name` varchar(150) NOT NULL,
  `last_name` varchar(150) NOT NULL,
  `email` varchar(254) NOT NULL,
  `is_staff` tinyint(1) NOT NULL,
  `is_active` tinyint(1) NOT NULL,
  `date_joined` datetime(6) NOT NULL,
  `role` varchar(30) NOT NULL,
  `school_id` bigint DEFAULT NULL,
  `student_id` bigint DEFAULT NULL,
  `country_id` bigint DEFAULT NULL,
  `district_id` bigint DEFAULT NULL,
  `region_id` bigint DEFAULT NULL,
  `ward_id` int DEFAULT NULL,
  `zone_id` int DEFAULT NULL,
  `phone` varchar(20) DEFAULT NULL,
  `created_by_id` bigint DEFAULT NULL,
  `city_council` varchar(150) NOT NULL,
  `street_village` varchar(150) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `username` (`username`),
  UNIQUE KEY `student_id` (`student_id`),
  KEY `core_user_ward_id_e3c060da_fk_core_ward_id` (`ward_id`),
  KEY `core_user_zone_id_fe4884ce_fk_core_zone_id` (`zone_id`),
  KEY `core_user_country_id_b54aea38_fk` (`country_id`),
  KEY `core_user_district_id_b653f1e0_fk` (`district_id`),
  KEY `core_user_region_id_00844595_fk` (`region_id`),
  KEY `core_user_school_id_b425ccf9_fk` (`school_id`),
  KEY `core_user_created_by_id_5ffcd207_fk_core_user_id` (`created_by_id`),
  CONSTRAINT `core_user_country_id_b54aea38_fk` FOREIGN KEY (`country_id`) REFERENCES `core_country` (`id`),
  CONSTRAINT `core_user_created_by_id_5ffcd207_fk_core_user_id` FOREIGN KEY (`created_by_id`) REFERENCES `core_user` (`id`),
  CONSTRAINT `core_user_district_id_b653f1e0_fk` FOREIGN KEY (`district_id`) REFERENCES `core_district` (`id`),
  CONSTRAINT `core_user_region_id_00844595_fk` FOREIGN KEY (`region_id`) REFERENCES `core_region` (`id`),
  CONSTRAINT `core_user_school_id_b425ccf9_fk` FOREIGN KEY (`school_id`) REFERENCES `core_school` (`id`),
  CONSTRAINT `core_user_student_id_dd0d948b_fk` FOREIGN KEY (`student_id`) REFERENCES `students_student` (`id`),
  CONSTRAINT `core_user_ward_id_e3c060da_fk_core_ward_id` FOREIGN KEY (`ward_id`) REFERENCES `core_ward` (`id`),
  CONSTRAINT `core_user_zone_id_fe4884ce_fk_core_zone_id` FOREIGN KEY (`zone_id`) REFERENCES `core_zone` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=1128 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `core_user`
--

LOCK TABLES `core_user` WRITE;
/*!40000 ALTER TABLE `core_user` DISABLE KEYS */;
INSERT INTO `core_user` VALUES (1,'pbkdf2_sha256$1500000$EZsUUYbQlWzD9cp7ibDmd0$ZSBpzGEfItP795QzTWpo+yXtBgcFh7rJdfHdFO8BjIo=','2026-10-15 09:58:20.009208',1,'talents','','','sebastianisack@gmail.com',1,1,'2026-08-25 19:04:37.832180','',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'',''),(1077,'pbkdf2_sha256$1500000$6hLiujQjWghH5T5aeidWbA$+tLJJvl/rouPmP4ns+evIHbWEZNv50YJ8EjZTmI3NaY=',NULL,0,'mchseba@gmail.com','seba','bishanga','mch@gmail.com',0,1,'2026-10-21 05:28:01.640507','district_manager',NULL,NULL,1,36,4,NULL,1,'+255765453432',1,'',''),(1078,'pbkdf2_sha256$1500000$ks6ggl2tkLda6gFOQDXaqx$Es/SjwFmIgwFYGxSZZxHavRam1Cc4bF646X1wMMV6Zc=',NULL,0,'kapampabo@gmail.com','rumisha','james','kapa@gmail.com',0,1,'2026-10-21 05:30:18.961044','sport_teacher',769,NULL,1,36,4,797,1,'+255987654786',1,'',''),(1079,'pbkdf2_sha256$1500000$MUrB1T5UTGeAU1o4y1eORp$tTEOUo5Mq1XdJlKrhK30sTq3AooAiBcMtjXj7vjxFGo=',NULL,0,'matumingi@gmail.com','faston','raymond','matu@gmail.com',0,1,'2026-10-21 05:32:39.787097','sport_teacher',771,NULL,1,36,4,798,1,'+255746098765',1,'',''),(1080,'pbkdf2_sha256$1500000$xAnr4zpOW1c0kBB7poKOL0$k4xp2j7L7h8jb6KPYBHiYNfDWDDdG4d9M/1/zbSRq34=',NULL,0,'raymond@gmail.com','raymo','shantu','ray@gmail.com',0,1,'2026-10-21 05:39:08.715208','sport_teacher',770,NULL,1,36,4,795,1,'+255756564354',1,'',''),(1081,'pbkdf2_sha256$1500000$ZBmQrsZIjutdgXoDm0g8PR$yMezJ4QOUfLnuJ9d1nvT95laG1FXon4V6oXkIPh47jY=',NULL,0,'hgyt@gmail.com','mkju','juhk','kjuhy@gmail.com',0,1,'2026-10-21 05:45:56.560315','sport_teacher',NULL,NULL,1,36,4,794,1,'+255765438999',1,'',''),(1082,'pbkdf2_sha256$1500000$HCmJYOpC0Fy8rfbLjdmuFV$Z9j4IqogCML5sqnzBStadXsXsbOL/rPumS7Yvcap9xg=',NULL,0,'S.0778/0001/2026','Anod','Abel','',0,1,'2026-10-21 05:49:07.664509','student',770,667,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'',''),(1083,'pbkdf2_sha256$1500000$5CY0R7kNGg57sYDSWvARNV$gEisOSosWzg2paJjzdVmlWCaUcNO2seEYpToatng6Co=',NULL,0,'S.0778/0002/2026','Daniel','Yohana','',0,1,'2026-10-21 05:50:14.479381','student',770,668,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'',''),(1084,'pbkdf2_sha256$1500000$cpPMHgWLAgjlKU4OfvrVJR$evxCBwJ/M4g63dMKDO3zvqA2ZusFCvoUSpzqO1orWxY=',NULL,0,'S.0778/0003/2026','Joshua','Joseph','',0,1,'2026-10-21 05:51:11.442872','student',770,669,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'',''),(1085,'pbkdf2_sha256$1500000$245yuM3gBFobA3O0CYERW3$op3mub4BmIRSBAojH4EIVQ9Q3GQ6NcE+1Rsz7cYWoRY=',NULL,0,'S.0778/0004/2026','Isack','Seba','',0,1,'2026-10-21 05:52:03.163913','student',770,670,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'',''),(1086,'pbkdf2_sha256$1500000$FsMxDj91epads720R3DxmP$osOz4cX5pFnZwsEhw5krJtYf5l55vdyxS7Rw+qWEZ74=',NULL,0,'S.0778/0005/2026','Raina','Abela','',0,1,'2026-10-21 05:55:38.266343','student',770,671,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'',''),(1087,'pbkdf2_sha256$1500000$SY38VqAEf3VTE6MbHOAWsl$eEQFAOpcq/ZXcf4hC3DKEZyiZbZv0o+2NeT77pO61vM=',NULL,0,'S.0778/0006/2026','salome','salvatory','',0,1,'2026-10-21 05:56:41.620657','student',770,672,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'',''),(1088,'pbkdf2_sha256$1500000$ZqwKD9CwqoWkNAYlm1C0br$ZNQjocu13c9BVV6W4sa6q+cX1iFiQI+pIwK1ZNSqLBg=',NULL,0,'S0667/0001/2026','kamuhabwa','james','',0,1,'2026-10-21 06:17:16.906358','student',769,673,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'',''),(1089,'pbkdf2_sha256$1500000$9eB8JrmMfLrMCJyXfyA0F9$7IhGK3dynxHJA4JC3ycOSEmrMJu9U1x7W+5dRCsJtCA=',NULL,0,'S0667/0002/2026','philipo','Bilimbasa','',0,1,'2026-10-21 06:18:13.717869','student',769,674,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'',''),(1090,'pbkdf2_sha256$1500000$OTdErBcZk8E60E2nMqulEo$C9qfpiqgVOksW96nxjRAfiQuAiWRiSgD4BUIlDZyH0M=',NULL,0,'S0667/0003/2026','venitha','theobard','',0,1,'2026-10-21 06:19:05.759272','student',769,675,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'',''),(1091,'pbkdf2_sha256$1500000$gd3GtwPWWEBoIfHnSHZSxZ$MOBqVZhNWOobMR6VLrliJKcHhyLmyS1Au/oWrT7ah5o=',NULL,0,'S0667/0004/2026','delisia','fortunatus','',0,1,'2026-10-21 06:21:05.015371','student',769,676,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'',''),(1092,'pbkdf2_sha256$1500000$0H8laZVhR3UyqUzkmioJHv$hRguMwjE+jErGz9ScqRD4UhX6p9ZwIYeltG+M/MFX5o=',NULL,0,'S.342/0001/2026','joshua','kanoni','',0,1,'2026-10-21 06:33:38.332658','student',771,677,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'',''),(1093,'pbkdf2_sha256$1500000$sF55YFEx0Wc4eJAZ6uHnPD$HW7WdyQRM+gEcVIeCGmT+AIFUjFlGxL52j2rUB5BXMs=',NULL,0,'S.342/0002/2026','elinazi','pesa','',0,1,'2026-10-21 06:34:21.587927','student',771,678,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'',''),(1094,'pbkdf2_sha256$1500000$a6q1giSiJ64uyqE6uxCaar$AOAUR7iBBkT2sTXoBPLJ3lURr7at/VDK6oAQWTLo4eo=',NULL,0,'S.342/0003/2026','erick','said','',0,1,'2026-10-21 06:35:37.403553','student',771,679,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'',''),(1095,'pbkdf2_sha256$1500000$0UBIDjLHa0EiGZbLVkKoEP$0//AFypu4g0ruTAl2N1H0l5qI+3q1X8A8F5m8WVWCck=',NULL,0,'S.342/0004/2026','Isack','seba','',0,1,'2026-10-21 06:36:34.976285','student',771,680,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'',''),(1096,'pbkdf2_sha256$1500000$QetT8xYcBFBweptZ7sprlB$8xeKU1t4PskunatpL0ysyb+ozicRUoqQv5a6RrCGaSs=',NULL,0,'S.342/0005/2026','yusuph','finias','',0,1,'2026-10-21 06:37:18.860388','student',771,681,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'',''),(1097,'pbkdf2_sha256$1500000$8nmOI5tVooBq6aOzsEf7Q6$lJp2jkZ5vnvwsthAj8PIMTMIllesLziJTbAn54qgwKM=',NULL,0,'S.342/0006/2026','makoye','evarist','',0,1,'2026-10-21 06:38:11.594749','student',771,682,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'','');
/*!40000 ALTER TABLE `core_user` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `core_user_groups`
--

DROP TABLE IF EXISTS `core_user_groups`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `core_user_groups` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `user_id` bigint NOT NULL,
  `group_id` int NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `core_user_groups_user_id_group_id_c82fcad1_uniq` (`user_id`,`group_id`),
  KEY `core_user_groups_group_id_fe8c697f_fk_auth_group_id` (`group_id`),
  CONSTRAINT `core_user_groups_group_id_fe8c697f_fk_auth_group_id` FOREIGN KEY (`group_id`) REFERENCES `auth_group` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `core_user_groups`
--

LOCK TABLES `core_user_groups` WRITE;
/*!40000 ALTER TABLE `core_user_groups` DISABLE KEYS */;
/*!40000 ALTER TABLE `core_user_groups` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `core_user_user_permissions`
--

DROP TABLE IF EXISTS `core_user_user_permissions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `core_user_user_permissions` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `user_id` bigint NOT NULL,
  `permission_id` int NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `core_user_user_permissions_user_id_permission_id_73ea0daa_uniq` (`user_id`,`permission_id`),
  KEY `core_user_user_permi_permission_id_35ccf601_fk_auth_perm` (`permission_id`),
  CONSTRAINT `core_user_user_permi_permission_id_35ccf601_fk_auth_perm` FOREIGN KEY (`permission_id`) REFERENCES `auth_permission` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `core_user_user_permissions`
--

LOCK TABLES `core_user_user_permissions` WRITE;
/*!40000 ALTER TABLE `core_user_user_permissions` DISABLE KEYS */;
/*!40000 ALTER TABLE `core_user_user_permissions` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `core_ward`
--

DROP TABLE IF EXISTS `core_ward`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `core_ward` (
  `id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(100) NOT NULL,
  `district_id` bigint NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `core_ward_district_id_name_903c1c28_uniq` (`district_id`,`name`),
  CONSTRAINT `core_ward_district_id_e159a279_fk` FOREIGN KEY (`district_id`) REFERENCES `core_district` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2347 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `core_ward`
--

LOCK TABLES `core_ward` WRITE;
/*!40000 ALTER TABLE `core_ward` DISABLE KEYS */;
INSERT INTO `core_ward` VALUES (1,'Baraa',1),(2,'Daraja Mbili',1),(3,'Elerai',1),(4,'Engutoto',1),(6,'Kaloleni',1),(5,'Kati',1),(7,'Kimandolu',1),(8,'Lemara',1),(9,'Levolosi',1),(10,'Moshono',1),(11,'Ngarenaro',1),(12,'Olasiti',1),(13,'Oloirien',1),(14,'Sekei',1),(15,'Sokon II',1),(16,'Sombetini',1),(17,'Terrat',1),(18,'Themi',1),(19,'Unga Limited',1),(20,'Bwawani',2),(21,'Duka Bovu',2),(22,'Ilboru',2),(23,'Karamati',2),(24,'Kimnyaki',2),(25,'Kiserian',2),(26,'Lagari',2),(27,'Lemanyata',2),(28,'Mlangarini',2),(29,'Moivo',2),(30,'Moshono',2),(31,'Mukulat',2),(32,'Ngaramtoni',2),(33,'Oldonyosambu',2),(34,'Olkung\'wado',2),(37,'Olorien',2),(35,'Oltoroto',2),(36,'Oltrumet',2),(38,'Pilikilyani',2),(39,'Sambasha',2),(40,'Shisongoro',2),(41,'Sokon I',2),(43,'Tengeru',2),(42,'Terat',2),(44,'USA River',2),(45,'Uwiro',2),(46,'Yusufi',2),(47,'Baray',3),(48,'Buger',3),(49,'Daa',3),(50,'Endabash',3),(51,'Endamaghang',3),(52,'Endamarariek',3),(53,'Ganako',3),(54,'Kansay',3),(55,'Karatu',3),(56,'Mang\'ola',3),(57,'Mbulumbulu',3),(58,'Oldean',3),(59,'Qurus',3),(60,'Rhotia',3),(61,'Elang\'ata Dapash',4),(62,'Engarenaibor',4),(63,'Engikaret',4),(64,'Gelai Lumbwa',4),(65,'Gelai Meirugoi',4),(66,'Iloirienito',4),(67,'Kamwanga',4),(68,'Kitumbeine',4),(69,'Longido',4),(70,'Matale',4),(71,'Mundarara',4),(72,'Namanga',4),(73,'Ngeriani',4),(74,'Olmolog',4),(75,'Orbomba',4),(76,'Sinoki',4),(77,'Tingatinga',4),(78,'Akheri',5),(79,'Kikatiti',5),(80,'Kikwe',5),(81,'King\'ori',5),(82,'Leguruki',5),(83,'Maji ya Chai',5),(84,'Makiba',5),(85,'Maroroni',5),(86,'Mbuguni',5),(87,'Ngarenanyuki',5),(88,'Nkoanrua',5),(89,'Nkoaranga',5),(90,'Nkoarisambu',5),(91,'Poli',5),(92,'Seela Sing\'isi',5),(93,'Songoro',5),(94,'Usa River',5),(95,'Engaruka',6),(96,'Engutoto',6),(97,'Esilalei',6),(98,'Lashaine',6),(99,'Lemooti',6),(100,'Lepurko',6),(101,'Lolkisale',6),(102,'Majengo',6),(103,'Makuyuni',6),(104,'Meserani',6),(105,'Mfereji',6),(106,'Migungani',6),(107,'Moita',6),(108,'Monduli Juu',6),(109,'Monduli Mjini',6),(110,'Mswakini',6),(111,'Mto wa Mbu',6),(112,'Naalarami',6),(113,'Selela',6),(114,'Sepeko',6),(115,'Alailelai',7),(116,'Arash',7),(117,'Digodigo',7),(118,'Enduleni',7),(119,'Enguserosambu',7),(137,'Engutoto',7),(138,'Eyasi',7),(139,'Gelai Lumbwa',7),(140,'Gelai Meirugoi',7),(120,'Kakesio',7),(141,'Kimokouwa',7),(121,'Maalon',7),(142,'Magaiduru',7),(122,'Malambo',7),(123,'Misigiyo',7),(124,'Nainokanoka',7),(125,'Naiyobi',7),(126,'Ngorongoro',7),(128,'Olbalbal',7),(127,'Oldonyo-Sambu',7),(129,'Oloipiri',7),(130,'Oloirien',7),(131,'Ololosokwan',7),(132,'Orgosorok',7),(133,'Pinyinyi',7),(134,'Sale',7),(135,'Samunge',7),(136,'Soit Sambu',7),(143,'Bonyokwa',8),(144,'Buguruni',8),(145,'Buyuni',8),(146,'Chanika',8),(147,'Gerezani',8),(148,'Gongolamboto',8),(149,'Ilala',8),(150,'Jangwani',8),(151,'Kariakoo',8),(152,'Kimanga',8),(153,'Kinyerezi',8),(154,'Kipawa',8),(155,'Kipunguni',8),(156,'Kisukuru',8),(157,'Kisutu',8),(158,'Kitunda',8),(159,'Kivukoni',8),(160,'Kivule',8),(161,'Kiwalani',8),(162,'Liwiti',8),(163,'Majohe',8),(164,'Mchafukoge',8),(165,'Mchikichini',8),(166,'Minazi Mirefu',8),(167,'Mnyamani',8),(168,'Msongola',8),(169,'Mzinga',8),(170,'Pugu',8),(171,'Pugu Station',8),(172,'Segerea',8),(173,'Tabata',8),(174,'Ukonga',8),(175,'Upanga East',8),(176,'Upanga West',8),(177,'Vingunguti',8),(178,'Bunju',9),(179,'Hananasif',9),(180,'Kawe',9),(181,'Kigogo',9),(182,'Kijitonyama',9),(183,'Kinondoni',9),(184,'Kunduchi',9),(185,'Mabwepande',9),(186,'Magomeni',9),(187,'Makongo',9),(188,'Makumbusho',9),(189,'Mbezi Juu',9),(190,'Mbweni',9),(191,'Mikocheni',9),(192,'Msasani',9),(193,'Mwananyamala',9),(194,'Mzimuni',9),(195,'Ndugumbi',9),(196,'Tandale',9),(197,'Wazo',9),(198,'Azimio',10),(199,'Buza',10),(200,'Chamazi',10),(201,'Chang\'ombe',10),(202,'Charambe',10),(203,'Keko',10),(204,'Kiburugwa',10),(205,'Kijichi',10),(206,'Kilakala',10),(207,'Kurasini',10),(208,'Makangarawe',10),(209,'Mbagala',10),(210,'Mbagala Kuu',10),(211,'Mianzini',10),(212,'Miburani',10),(213,'Mtoni',10),(214,'Sandali',10),(215,'Tandika',10),(216,'Temeke',10),(217,'Toangoma',10),(218,'Goba',11),(219,'Kibamba',11),(220,'Kimara',11),(221,'Kwembe',11),(222,'Mabibo',11),(223,'Makuburi',11),(224,'Makurumla',11),(225,'Manzese',11),(226,'Mbezi',11),(227,'Mburahati',11),(228,'Msigani',11),(229,'Saranga',11),(230,'Sinza',11),(231,'Ubungo',11),(232,'Kibada',12),(233,'Kigamboni',12),(234,'Kimbiji',12),(235,'Kisarawe II',12),(236,'Mjimwema',12),(237,'Somangila',12),(238,'Tungi',12),(239,'Vijibweni',12),(240,'Chahwa',13),(241,'Chamwino',13),(242,'Chang\'ombe',13),(243,'Chigongwe',13),(244,'Chitemo',13),(245,'Chiwondo',13),(246,'Dodoma Makulu',13),(247,'Hazina',13),(248,'Hombolo Bwawani',13),(249,'Hombolo Makulu',13),(250,'Ihumwa',13),(251,'Ipagala',13),(252,'Ipala',13),(253,'Iyumbu',13),(254,'Kikombol',13),(255,'Kikuyu Kaskazini',13),(256,'Kikuyu Kusini',13),(257,'Kilimani',13),(258,'Kiwanja cha Ndege',13),(259,'Kizota',13),(260,'Madukani',13),(261,'Majengo',13),(262,'Makole',13),(263,'Makutupora',13),(264,'Mbabala',13),(265,'Mbalawala',13),(266,'Mkonze',13),(267,'Mnadani',13),(268,'Mpunguzi',13),(269,'Msalato',13),(270,'Mtumba',13),(271,'Nala',13),(272,'Ng\'ambwa',13),(273,'Nkuhungu',13),(274,'Nkurumah',13),(275,'Nzuguni',13),(276,'Tambukareli',13),(277,'Uhuru',13),(278,'Viwandani',13),(279,'Zuzu',13),(281,'Babayu',14),(280,'Bahi',14),(282,'Chali',14),(283,'Chikola',14),(284,'Chipanga',14),(285,'Chitemo',14),(286,'Ibihwa',14),(287,'Ibugule',14),(288,'Idibiitanyo',14),(289,'Ighee',14),(290,'Ilindi',14),(291,'Kigwe',14),(292,'Lamaiti',14),(293,'Makanda',14),(294,'Mpalanga',14),(295,'Mpamantwa',14),(296,'Msisi',14),(297,'Mtitaa',14),(298,'Mundemu',14),(299,'Mwitikira',14),(300,'Nondwa',14),(301,'Zanka',14),(302,'Buigiri',15),(303,'Chalinze',15),(304,'Chamwino',15),(305,'Chiboli',15),(306,'Dabalo',15),(307,'Fufu',15),(308,'Handali',15),(309,'Haneti',15),(310,'Huzi',15),(311,'Idifu',15),(312,'Igandu',15),(313,'Ikowa',15),(314,'Iringa Mvumi',15),(315,'Itiso',15),(316,'Loje',15),(317,'Majeleko',15),(318,'Makang\'wa',15),(319,'Manchali',15),(320,'Manda',15),(321,'Manzase',15),(322,'Membe',15),(323,'Mlowa Bwawani',15),(327,'Mpwayungu',15),(328,'Msamalo',15),(329,'Msanga',15),(330,'Mtitaa',15),(326,'Muungano',15),(324,'Mvumi Makulu',15),(325,'Mvumi Mission',15),(331,'Nghambaku',15),(332,'Nhigindi',15),(333,'Nunduma',15),(335,'Rudi',15),(334,'Segala',15),(336,'Zajilwa',15),(337,'Zanka',15),(338,'Babayu',16),(339,'Chandama',16),(340,'Chemba',16),(341,'Churuku',16),(342,'Dalai',16),(343,'Farkwa',16),(344,'Goima',16),(345,'Gwandi',16),(346,'Jangalo',16),(347,'Kidoka',16),(348,'Kimaha',16),(349,'Kinyamsindo',16),(350,'Kwamtoro',16),(351,'Lahoda',16),(352,'Lalta',16),(353,'Makorongo',16),(354,'Mondo',16),(355,'Mpendo',16),(356,'Mrijo',16),(357,'Msaada',16),(358,'Ovada',16),(359,'Paranga',16),(360,'Sanzawa',16),(361,'Songoro',16),(362,'Soya',16),(363,'Tumbakose',16),(364,'Bereko',17),(365,'Bolisa',17),(366,'Bumbuta',17),(367,'Busi',17),(368,'Changaa',17),(369,'Chemchem',17),(370,'Haubi',17),(371,'Hondomairo',17),(372,'Itaswi',17),(373,'Itololo',17),(374,'Kalamba',17),(375,'Keikei',17),(376,'Kikilo',17),(377,'Kikore',17),(378,'Kilimani',17),(379,'Kingale',17),(380,'Kinyasi',17),(381,'Kisese',17),(382,'Kolo',17),(383,'Kondoa Mjini',17),(384,'Kwadelo',17),(385,'Masange',17),(386,'Mnenia',17),(387,'Pahi',17),(388,'Salanka',17),(389,'Serya',17),(390,'Soera',17),(391,'Thawi',17),(392,'Bolisa',18),(393,'Chemchem',18),(394,'Kilimani',18),(395,'Kingale',18),(396,'Kolo',18),(397,'Kondoa Mjini',18),(398,'Serya',18),(399,'Suruke',18),(400,'Berege',19),(401,'Chipogoro',19),(402,'Chitemo',19),(403,'Chunyu',19),(404,'Galigali',19),(405,'Godegode',19),(406,'Gulwe',19),(407,'Ipera',19),(408,'Iwondo',19),(409,'Kibakwe',19),(410,'Kimagai',19),(411,'Kingiti',19),(412,'Lufu',19),(413,'Luhundwa',19),(414,'Lumuma',19),(415,'Lupeta',19),(416,'Malolo',19),(417,'Mang\'aliza',19),(418,'Massa',19),(419,'Matomondo',19),(420,'Mazae',19),(421,'Mbuga',19),(422,'Mima',19),(423,'Mlembule',19),(424,'Mlunduzi',19),(425,'Mpwapwa Mjini',19),(426,'Mtera',19),(427,'Nghambi',19),(428,'Pwaga',19),(429,'Rudi',19),(430,'Vingh\'awe',19),(431,'Wotta',19),(432,'Bugalama',20),(433,'Bugulula',20),(434,'Bujula',20),(435,'Bukoli',20),(436,'Bukondo',20),(437,'Busanda',20),(438,'Butobela',20),(439,'Butundwe',20),(440,'Chigunga',20),(441,'Ihanamilo',20),(442,'Isulwabutundwe',20),(443,'Izumacheli',20),(444,'Kagu',20),(445,'Kakubilo',20),(446,'Kamena',20),(447,'Kamhanga',20),(448,'Kaseme',20),(449,'Katoma',20),(450,'Katoro',20),(451,'Lubanga',20),(452,'Ludete',20),(453,'Lwamgasa',20),(454,'Lwezera',20),(455,'Magenge',20),(456,'Nkome',20),(457,'Nyachiluluma',20),(458,'Nyakagomba',20),(459,'Nyakamwaga',20),(460,'Nyalwanzaja',20),(461,'Nyamalimbe',20),(462,'Nyamboge',20),(463,'Nyamigota',20),(464,'Nyamwilolelwa',20),(465,'Nyarugusu',20),(466,'Nyaruyeye',20),(467,'Nyawilimilwa',20),(468,'Nzera',20),(469,'Senga',20),(470,'Bugelenga',21),(471,'Bukombe',21),(472,'Bulangwa',21),(473,'Bulega',21),(474,'Busonzo',21),(475,'Butinzya',21),(476,'Igulwa',21),(477,'Iyogelo',21),(478,'Katente',21),(479,'Katome',21),(480,'Lyambamgongo',21),(481,'Namonge',21),(482,'Ng\'anzo',21),(483,'Runzewe Magharibi',21),(484,'Runzewe Mashariki',21),(485,'Ushirombo',21),(486,'Uyovu',21),(487,'Bukome',22),(488,'Buseresere',22),(489,'Butengorumasa',22),(490,'Buziku',22),(491,'Bwanga',22),(492,'Bwera',22),(493,'Bwina',22),(494,'Bwongera',22),(495,'Chato',22),(496,'Ichwankima',22),(498,'Ilemchele',22),(497,'Ilemela',22),(499,'Iparamasa',22),(500,'Kachwamba',22),(501,'Kasenga',22),(502,'Katende',22),(503,'Kigongo',22),(504,'Makurugusi',22),(505,'Minkoto',22),(506,'Muganza',22),(507,'Muungano',22),(508,'Nyamirembe',22),(509,'Nyarutembo',22),(510,'Bukandwe',23),(511,'Bunigonzi',23),(512,'Ikobe',23),(513,'Ikunguigazi',23),(514,'Ilolangulu',23),(515,'Iponya',23),(516,'Isebya',23),(517,'Lugunga',23),(518,'Lulembela',23),(519,'Masumbwe',23),(520,'Mbogwe',23),(521,'Nanda',23),(522,'Ngemo',23),(523,'Nhomolwa',23),(524,'Nyakafulu',23),(525,'Nyasato',23),(526,'Ushirika',23),(528,'Bukwimba',24),(527,'Busolwa',24),(529,'Izunya',24),(530,'Kaboha',24),(531,'Kafita',24),(532,'Kakora',24),(533,'Kharumwa',24),(534,'Mwingiro',24),(535,'Nundu',24),(536,'Nyabulanda',24),(537,'Nyamtukuza',24),(538,'Nyang\'hwale',24),(539,'Nyijundu',24),(540,'Nyugwa',24),(541,'Shabaka',24),(542,'Gangilonga',25),(543,'Igumbilo',25),(544,'Ilala',25),(545,'Ipogolo',25),(546,'Isakalilo',25),(547,'Kihesa',25),(548,'Kitanzini',25),(549,'Kitwiru',25),(550,'Kwakilosa',25),(551,'Makorongoni',25),(552,'Mivinjeni',25),(553,'Mkimbizi',25),(554,'Mkwawa',25),(555,'Mlandege',25),(556,'Mshindo',25),(557,'Mtwivila',25),(558,'Mwangata',25),(559,'Nduli',25),(560,'Idodi',26),(561,'Ifunda',26),(562,'Ilolo Mpya',26),(563,'Itunundu',26),(564,'Izazi',26),(565,'Kalenga',26),(566,'Kihanga',26),(567,'Kihorogota',26),(568,'Kising\'a',26),(569,'Kiwere',26),(570,'Luhota',26),(571,'Lumuli',26),(572,'Lyamgungwe',26),(573,'Maboga',26),(574,'Magulilwa',26),(575,'Mahuninga',26),(576,'Malengamakali',26),(577,'Masaka',26),(578,'Mboliboli',26),(579,'Mgama',26),(580,'Migoli',26),(581,'Mlenge',26),(582,'Mlowa',26),(583,'Mseke',26),(584,'Nyang\'oro',26),(585,'Nzihi',26),(586,'Ulanda',26),(587,'Wasa',26),(588,'Boma',27),(589,'Bumilayinga',27),(590,'Changarawe',27),(591,'Isalavanu',27),(592,'Kinyanambo',27),(593,'Rungemba',27),(594,'Sao Hill',27),(595,'Upendo',27),(596,'Wambi',27),(597,'Idete',28),(598,'Idunda',28),(599,'Ifwagi',28),(600,'Igombavanu',28),(601,'Igowole',28),(602,'Ihalimba',28),(603,'Ihimbo',28),(604,'Ikiyowela',28),(605,'Ikweha',28),(606,'Itandula',28),(607,'Kasanga',28),(608,'Kibengu',28),(609,'Kiyowela',28),(610,'Luhunga',28),(611,'Maduma',28),(612,'Makungu',28),(613,'Mapanda',28),(614,'Mbalamaziwa',28),(615,'Mdabulo',28),(616,'Mninga',28),(617,'Mtambula',28),(618,'Mtwango',28),(619,'Nyololo',28),(620,'Sadani',28),(621,'Unyanyembe',28),(622,'Usokami',28),(623,'Viwanda',28),(624,'Boma la Ng\'ombe',29),(625,'Dabaga',29),(626,'Idete',29),(627,'Ihimbo',29),(628,'Ilula',29),(629,'Image',29),(630,'Irole',29),(631,'Kimala',29),(632,'Kising\'a',29),(633,'Lugalo',29),(634,'Mahenge',29),(635,'Masisiwe',29),(636,'Mlafu',29),(637,'Mtitu',29),(638,'Ng\'ang\'ange',29),(639,'Ng\'uruhe',29),(640,'Nyalumbu',29),(641,'Nyanzwa',29),(642,'Ruaha Mbuyuni',29),(643,'Udekwa',29),(644,'Uhambingeto',29),(645,'Ukumbi',29),(646,'Ukwega',29),(647,'Bakoba',30),(648,'Bilele',30),(649,'Buhembe',30),(650,'Hamugembe',30),(651,'Ijuganyondo',30),(652,'Kagondo',30),(653,'Kahororo',30),(654,'Kashai',30),(655,'Kibeta',30),(656,'Kitendaguro',30),(657,'Miembeni',30),(658,'Nshambya',30),(659,'Nyanga',30),(660,'Rwamishenye',30),(661,'Buhendangabo',31),(662,'Bujugo',31),(663,'Butelankuzi',31),(664,'Butulage',31),(665,'Ibwera',31),(666,'Izimbya',31),(667,'Kaagya',31),(668,'Kaibanja',31),(669,'Kanyangereko',31),(670,'Karabagaine',31),(671,'Kasharu',31),(672,'Katerero',31),(673,'Katoma',31),(674,'Katoro',31),(675,'Kemondo',31),(676,'Kibirizi',31),(677,'Kikomero',31),(678,'Kishanje',31),(679,'Kishogo',31),(680,'Kyaitoke',31),(681,'Kyamulaile',31),(682,'Maruku',31),(683,'Mikoni',31),(684,'Mugajwale',31),(685,'Nyakato',31),(686,'Nyakibimbili',31),(687,'Rubafu',31),(688,'Rubale',31),(689,'Ruhunga',31),(690,'Rukoma',31),(691,'Bugandika',32),(692,'Bugorora',32),(693,'Buyango',32),(694,'Bwanjai',32),(695,'Gera',32),(696,'Ishozi',32),(697,'Ishunju',32),(698,'Kakunyu',32),(699,'Kanyigo',32),(700,'Kashenye',32),(701,'Kassambya',32),(702,'Kilimilile',32),(703,'Kitobo',32),(704,'Kyaka',32),(705,'Mabale',32),(706,'Minziro',32),(707,'Mushasha',32),(708,'Mutukula',32),(709,'Nsunga',32),(710,'Ruzinga',32),(711,'Biirabo',33),(712,'Bisheke',33),(713,'Buganguzi',33),(714,'Buhangaza',33),(715,'Bulyakashaju',33),(716,'Bumbire',33),(717,'Bureza',33),(718,'Burungura',33),(719,'Goziba',33),(720,'Gwanseli',33),(721,'Ibuga',33),(722,'Ijumbi',33),(723,'Ikondo',33),(724,'Ikuza',33),(725,'Izigo',33),(726,'Kabirizi',33),(727,'Kagoma',33),(728,'Kamachumu',33),(729,'Karambi',33),(730,'Kasharunga',33),(731,'Kashasha',33),(732,'Katoke',33),(733,'Kerebe',33),(734,'Kibanga',33),(735,'Kikuku',33),(736,'Kimwani',33),(737,'Kishanda',33),(738,'Kyebitembe',33),(739,'Mafumbo',33),(740,'Magata Karutanga',33),(741,'Mayondwe',33),(742,'Mazinga',33),(743,'Mubunda',33),(744,'Muhutwe',33),(745,'Muleba',33),(746,'Mushabago',33),(747,'Ngenge',33),(748,'Nshamba',33),(749,'Nyakabango',33),(750,'Nyakatanga',33),(751,'Ruhanga',33),(752,'Rulanda',33),(753,'Rutoro',33),(754,'Bugarama',34),(755,'Bukiriro',34),(756,'Kabanga',34),(757,'Kanazi',34),(758,'Kasulo',34),(759,'Keza',34),(760,'Kibimba',34),(761,'Kibogora',34),(762,'Kirushya',34),(763,'Mabawe',34),(764,'Mbuba',34),(765,'Muganza',34),(766,'Mugoma',34),(767,'Murukulazo',34),(768,'Murusagamba',34),(769,'Ngara Mjini',34),(770,'Ntobeye',34),(771,'Nyakisasa',34),(772,'Nyamagoma',34),(773,'Nyamiyaga',34),(774,'Rulenge',34),(775,'Rusumo',34),(776,'Biharamulo Mjini',35),(777,'Bisibo',35),(778,'Kabindi',35),(779,'Kalenge',35),(780,'Kaniha',35),(781,'Lusahunga',35),(782,'Mavota',35),(783,'Nemba',35),(784,'Nyabusozi',35),(785,'Nyakahura',35),(786,'Nyamahanga',35),(787,'Nyamigogo',35),(788,'Nyantakara',35),(789,'Nyarubungo',35),(790,'Nyarusimba',35),(791,'Runazi',35),(792,'Ruziba',35),(795,'Itera',36),(797,'Kakanja',36),(798,'Kimuli',36),(794,'Nkwenda',36),(796,'Rwabwere',36),(793,'Songambele',36),(803,'Isingiro',37),(804,'Kikukuru',37),(800,'Kitwechenkura',37),(801,'Kyerwa',37),(802,'Nyaruzumbura',37),(799,'Rukuraijo',37),(810,'Bugara',38),(805,'Businde',38),(809,'Kamuli',38),(807,'Kikuru',38),(808,'Kitwe',38),(806,'Mabira',38),(811,'Ihembe',39),(812,'Nyaishozi',39),(814,'Nyakasimbi',39),(813,'Rugu',39),(816,'Bugene',40),(818,'Chonyonyo',40),(817,'Ihanda',40),(819,'Kayanga',40),(820,'Ndama',40),(815,'Songambele',40),(821,'Chanika',41),(826,'Igurwa',41),(823,'Kanoni',41),(825,'Kihanga',41),(822,'Kituntu',41),(824,'Rugera',41),(833,'Bweranyange',42),(832,'Kamagambo',42),(829,'Kibondo',42),(831,'Kiruruma',42),(830,'Nyabiyonza',42),(827,'Nyakabanga',42),(828,'Nyakakika',42),(839,'Bugomora',43),(838,'Kaisho',43),(837,'Kibare',43),(835,'Kibingo',43),(834,'Nyakahanga',43),(836,'Rutunguru',43),(840,'Ilembo',44),(841,'Kakese',44),(842,'Kashaulili',44),(843,'Kasokola',44),(844,'Kawajense',44),(845,'Kazima',44),(846,'Magamba',44),(847,'Majengo',44),(848,'Makanyagio',44),(849,'Misunkumilo',44),(850,'Mpanda Hotel',44),(851,'Mwamkulu',44),(852,'Nsemulwa',44),(853,'Shanwe',44),(854,'Uwanja wa Ndege',44),(855,'Bulamata',45),(856,'Igalula',45),(857,'Ikola',45),(858,'Ilangu',45),(859,'Isiku',45),(860,'Kabwe',45),(861,'Kapalamsenga',45),(862,'Karema',45),(863,'Katuma',45),(864,'Kbsa',45),(865,'Mishamo',45),(866,'Mnyagala',45),(867,'Mpandandogo',45),(868,'Mwese',45),(869,'Sibwesa',45),(870,'Tongwe',45),(871,'Ilela',46),(872,'Ilunde',46),(873,'Inyonga',46),(874,'Kamsisi',46),(875,'Nsenkwa',46),(876,'Utende',46),(877,'Ibindi',47),(878,'Itenka',47),(879,'Kanoge',47),(880,'Kapalala',47),(881,'Katumba',47),(882,'Litapunga',47),(883,'Machimboni',47),(884,'Mtapenda',47),(885,'Nsimbo',47),(886,'Sitalike',47),(887,'Ugala',47),(888,'Urwila',47),(889,'Bangwe',48),(890,'Buhanda',48),(891,'Businde',48),(892,'Gungu',48),(893,'Kagera',48),(895,'Kasingirima',48),(894,'Kasulu',48),(896,'Katubuka',48),(897,'Kibirizi',48),(898,'Kigoma',48),(899,'Kipampa',48),(900,'Kitanza',48),(901,'Machaze',48),(902,'Majengo',48),(903,'Mwanga Kaskazini',48),(904,'Mwanga Kusini',48),(905,'Nyamanoro',48),(906,'Rusimbi',48),(907,'Ujiji',48),(908,'Bitale',49),(909,'Kagunga',49),(910,'Kalinzi',49),(911,'Kandabwe',49),(912,'Kidahwe',49),(913,'Mahembe',49),(914,'Matendo',49),(915,'Mkabogo',49),(916,'Mkongoro',49),(917,'Mwamgongo',49),(918,'Mwandiga',49),(919,'Bitale',50),(920,'Kagunga',50),(921,'Kalinzi',50),(922,'Kandabwe',50),(923,'Kidahwe',50),(924,'Mahembe',50),(925,'Matendo',50),(926,'Mkabogo',50),(927,'Mkongoro',50),(928,'Mwamgongo',50),(929,'Mwandiga',50),(930,'Asante Nyerere',51),(931,'Bogwe',51),(932,'Bugaga',51),(933,'Buhoro',51),(934,'Buigiri',51),(935,'Heru Juu',51),(936,'Kagerankanda',51),(937,'Kananzi',51),(938,'Kanyani',51),(946,'Kasulu Mjini',51),(939,'Kibondo',51),(940,'Kigondo',51),(941,'Kitanga',51),(942,'Kizazi',51),(943,'Kumsenga',51),(944,'Kurugongo',51),(945,'Kwaga',51),(947,'Makere',51),(953,'Msambara',51),(948,'Muganza',51),(949,'Muhunga',51),(951,'Murufiti',51),(950,'Muungano',51),(952,'Mvugwe',51),(954,'Nyakitonto',51),(955,'Nyamidaho',51),(956,'Nyansha',51),(957,'Nyumbigwa',51),(958,'Ruchugi',51),(959,'Ruhita',51),(960,'Rungwe Mpya',51),(961,'Titye',51),(962,'Tumbili',51),(963,'Busagara',52),(964,'Busunzu',52),(965,'Itaba',52),(966,'Kagezi',52),(967,'Kasanda',52),(968,'Kasandiko',52),(969,'Kibondo Mjini',52),(970,'Kitahana',52),(971,'Kizazi',52),(972,'Kumwambu',52),(973,'Mabamba',52),(974,'Mishamo',52),(975,'Murungu',52),(976,'Gwarama',53),(977,'Kakonko',53),(978,'Kasuga',53),(979,'Katindiuka',53),(980,'Kiziguzigu',53),(981,'Mugunzu',53),(982,'Muhange',53),(983,'Muzenze',53),(984,'Nyabibuye',53),(986,'Nyaishozi',53),(985,'Nyamtukuza',53),(987,'Rugenge',53),(988,'Rumashi',53),(989,'Basanza',54),(990,'Buhingu',54),(991,'Igalula',54),(992,'Ilagala',54),(993,'Itebula',54),(994,'Kalya',54),(995,'Kandaga',54),(996,'Kazuramimba',54),(997,'Mganza',54),(998,'Mtego wa Noti',54),(999,'Nguruka',54),(1000,'Nyakitonto',54),(1001,'Sigunga',54),(1002,'Sunuka',54),(1004,'Ushindi',54),(1003,'Uvinza',54),(1005,'Bulamata',55),(1006,'Igalula',55),(1007,'Ikola',55),(1008,'Ilangu',55),(1009,'Isiku',55),(1010,'Kabwe',55),(1011,'Kapalamsenga',55),(1012,'Karema',55),(1013,'Katuma',55),(1014,'Kibasila',55),(1015,'Mishamo',55),(1016,'Mnyagala',55),(1017,'Mpandandogo',55),(1018,'Mwese',55),(1019,'Sibwesa',55),(1020,'Tongwe',55),(1022,'Boma la Ng\'ombe',56),(1021,'Bondeni',56),(1023,'Kaloleni',56),(1024,'Karanga',56),(1026,'Kiboriloni',56),(1025,'Kiusa',56),(1027,'Korongoni',56),(1028,'Longuo B',56),(1029,'Majengo',56),(1030,'Mawenzi',56),(1031,'Mfumuni',56),(1032,'Miembeni',56),(1033,'Mjini Kati',56),(1034,'Msaranga',56),(1035,'Ng\'ambo',56),(1036,'Njoro',56),(1037,'Pasua',56),(1038,'Rau',56),(1039,'Shirimatunda',56),(1040,'Soweto',56),(1041,'Arusha Chini',57),(1042,'Chania',57),(1043,'Kanyamanyara',57),(1044,'Kibosho Kati',57),(1045,'Kibosho Magharibi',57),(1046,'Kibosho Mashariki',57),(1047,'Kilema Kaskazini',57),(1048,'Kilema Kati',57),(1049,'Kilema Kusini',57),(1050,'Kimochi',57),(1051,'Kindi',57),(1052,'Kirua Vunjo Kusini',57),(1053,'Kirua Vunjo Magharibi',57),(1054,'Kirua Vunjo Mashariki',57),(1055,'Mabogini',57),(1056,'Makuyuni',57),(1057,'Mamba Kaskazini',57),(1058,'Mamba Kusini',57),(1059,'Marangu Magharibi',57),(1060,'Marangu Mashariki',57),(1061,'Mbokomu',57),(1062,'Mwika Kaskazini',57),(1063,'Mwika Kusini',57),(1064,'Njiapanda',57),(1065,'Okaoni',57),(1066,'Old Moshi Magharibi',57),(1067,'Old Moshi Mashariki',57),(1068,'Uru Kaskazini',57),(1069,'Uru Kusini',57),(1071,'Uru Magharibi',57),(1070,'Uru Mashariki',57),(1072,'Uru Shimbwe',57),(1073,'Bomang\'ombe',58),(1074,'Bondeni',58),(1075,'Kia',58),(1076,'Machame Kaskazini',58),(1077,'Machame Kusini',58),(1079,'Machame Magharibi',58),(1078,'Machame Mashariki',58),(1080,'Machame Uroki',58),(1081,'Masama Kaskazini',58),(1082,'Masama Kusini',58),(1084,'Masama Magharibi',58),(1083,'Masama Mashariki',58),(1085,'Masama Rundugai',58),(1086,'Muungano',58),(1087,'Biriri',59),(1088,'Kashashi',59),(1089,'Kilingi',59),(1090,'Kirua Vunjo',59),(1091,'Kirua Vunjo Kusini',59),(1092,'Livishi',59),(1093,'Machame Kaskazini',59),(1094,'Machame Mashariki',59),(1095,'Machame Uroki',59),(1096,'Nasai',59),(1097,'Sanya Juu',59),(1098,'Chomvu',60),(1099,'Jipe',60),(1100,'Kifula',60),(1101,'Kigome',60),(1102,'Kileo',60),(1103,'Kilomeni',60),(1105,'Kirya',60),(1104,'Kivisini',60),(1106,'Kwakoa',60),(1107,'Lang\'ata',60),(1108,'Lembeni',60),(1109,'Mgagao',60),(1110,'Msangeni',60),(1111,'Mwanga Mjini',60),(1112,'Mwaniko',60),(1113,'Nganyeni',60),(1114,'Ojoro',60),(1115,'Shighatini',60),(1116,'Toloha',60),(1117,'Usangi',60),(1118,'Aleni',61),(1119,'Chala',61),(1120,'Holili',61),(1121,'Katangara Mrere',61),(1122,'Kelamfua Mokala',61),(1123,'Keni Aleni',61),(1124,'Kingachi',61),(1125,'Kirongo Samanga',61),(1126,'Kirwa Keni',61),(1127,'Kisale Msaranga',61),(1128,'Kitirima King\'ori',61),(1129,'Kiwanda',61),(1130,'Makiidi',61),(1131,'Mamsera',61),(1132,'Manda',61),(1133,'Mengi',61),(1144,'Mkuu Mjini',61),(1134,'Motamburu Kitendeni',61),(1135,'Mrao Keryo',61),(1136,'Nanjara Reha',61),(1137,'Ngoyoni',61),(1138,'Olele',61),(1139,'Reha',61),(1140,'Shimbi',61),(1141,'Tarakea Motamburu',61),(1142,'Ubetu Kahe',61),(1143,'Ushiri Ikuini',61),(1145,'Bangalala',62),(1147,'Bendera',62),(1146,'Bombo',62),(1148,'Bwambo',62),(1149,'Chome',62),(1150,'Giseni',62),(1151,'Hedaru',62),(1152,'Kalemawe',62),(1153,'Kihurio',62),(1154,'Kirangare',62),(1155,'Kisiwani',62),(1156,'Kwa-Mkono',62),(1157,'Kyjo',62),(1158,'Lindi',62),(1159,'Lugulu',62),(1160,'Mabilioni',62),(1161,'Makanya',62),(1162,'Maore',62),(1163,'Mhezi',62),(1164,'Minkanyeni',62),(1165,'Mpinji',62),(1166,'Msuya',62),(1167,'Mtii',62),(1168,'Mvuje',62),(1169,'Myamba',62),(1170,'Ndungu',62),(1171,'Ninkanyeni',62),(1172,'Nndewe',62),(1173,'Nujia',62),(1174,'Ruvu',62),(1175,'Same Mjini',62),(1176,'Stesheni',62),(1177,'Vudee',62),(1178,'Vumari',62),(1179,'Vunta',62),(1180,'Chumo',63),(1181,'Kandawale',63),(1182,'Kibata',63),(1183,'Kikole',63),(1184,'Kinjumbi',63),(1185,'Kipatimu',63),(1186,'Kiranjeranje',63),(1187,'Kivinjesingino',63),(1188,'Lihimalyao',63),(1189,'Likawage',63),(1190,'Mandawa',63),(1191,'Masoko',63),(1192,'Miguruwe',63),(1193,'Mingumbi',63),(1194,'Miteja',63),(1195,'Mitole',63),(1196,'Namayuni',63),(1197,'Nanjirinji',63),(1198,'Njinjo',63),(1199,'Pande Mikoma',63),(1200,'Somanga',63),(1201,'Songosongo',63),(1202,'Tingi',63),(1203,'Boma',64),(1204,'Chiwola',64),(1205,'Kiegei',64),(1206,'Kihare',64),(1207,'Kilimanihewa',64),(1208,'Kilimarondo',64),(1209,'Kipara Mtwero',64),(1210,'Lionja',64),(1211,'Lituhi',64),(1212,'Ludewa',64),(1213,'Mabula',64),(1214,'Marambo',64),(1215,'Matekwe',64),(1216,'Mbwinji',64),(1217,'Mchonda',64),(1218,'Mikonjowale',64),(1219,'Mkoka',64),(1220,'Mkotokuyana',64),(1221,'Mlowoka',64),(1222,'Mnaida',64),(1223,'Mnero',64),(1224,'Mnero Ngongo',64),(1225,'Mtua',64),(1226,'Nachingwea Mjini',64),(1227,'Naipanga',64),(1228,'Naipingo',64),(1229,'Namanyere',64),(1230,'Namatula',64),(1231,'Nampungu',64),(1232,'Namumbulu',64),(1233,'Nang\'ondo',64),(1234,'Nangowe',64),(1235,'Nditi',64),(1236,'Ngunichile',64),(1237,'Stesheni',64),(1238,'Ugawaji',64),(1239,'Chibula',65),(1240,'Chienjele',65),(1241,'Chinongwe',65),(1242,'Chunyu',65),(1243,'Likunja',65),(1244,'Linani',65),(1245,'Lipande',65),(1246,'Luchenene',65),(1247,'Makanjiro',65),(1248,'Malolo',65),(1249,'Mandawa',65),(1250,'Mbekenyera',65),(1251,'Mnacho',65),(1252,'Nachingwea',65),(1253,'Nandagala',65),(1254,'Nangulungulu',65),(1255,'Nanyani',65),(1256,'Narungombe',65),(1257,'Ngunguru',65),(1258,'Nkowe',65),(1259,'Ruangwa Mjini',65),(1260,'Simbila',65),(1261,'Chikonji',66),(1262,'Jamhuri',66),(1263,'Kilangala',66),(1264,'Kilolambwani',66),(1265,'Kitomanga',66),(1266,'Kitumbikwela',66),(1267,'Kiwawa',66),(1268,'Makonde',66),(1269,'Matimba',66),(1270,'Matopeni',66),(1271,'Mbanja',66),(1272,'Mchinga',66),(1273,'Mikumbi',66),(1274,'Milola',66),(1275,'Mingoyo',66),(1276,'Mipingo',66),(1277,'Mitandi',66),(1278,'Mnazimmoja',66),(1279,'Msinjahili',66),(1280,'Mtanda',66),(1281,'Mvuleni',66),(1282,'Mwenge',66),(1283,'Nachingwea',66),(1284,'Nangaru',66),(1285,'Ndoro',66),(1286,'Ng\'apa',66),(1287,'Rahaleo',66),(1288,'Rasbura',66),(1289,'Rutamba',66),(1290,'Tandangongoro',66),(1291,'Wailes',66),(1292,'Chiponda',67),(1293,'Dimba',67),(1294,'Kihonda',67),(1295,'Lang\'ama',67),(1296,'Lindi Msitu',67),(1297,'Linua',67),(1298,'Majengo',67),(1299,'Mandwanga',67),(1300,'Mchinga',67),(1301,'Milola',67),(1302,'Mingoyo',67),(1303,'Mnara',67),(1304,'Mtama',67),(1305,'Mtua',67),(1306,'Mtumbya',67),(1307,'Mwenbe',67),(1308,'Nachunyu',67),(1309,'Namangale',67),(1310,'Namupa',67),(1311,'Nangaru',67),(1312,'Nangwaya',67),(1313,'Navanga',67),(1314,'Nyangamara',67),(1315,'Nyangao',67),(1316,'Nyengedi',67),(1317,'Pangantatwa',67),(1318,'Sudi',67),(1319,'Tandahimba',67),(1320,'Unyuwe',67),(1321,'Barikiwa',68),(1322,'Kiangara',68),(1323,'Kibutuka',68),(1324,'Kimani',68),(1325,'Kiunganyira',68),(1326,'Liwale B',68),(1327,'Liwale Mjini',68),(1328,'Makande',68),(1329,'Makata',68),(1330,'Mangirikiti',68),(1331,'Mbaya',68),(1332,'Mihumo',68),(1333,'Mirui',68),(1334,'Mkutano',68),(1335,'Mlembwe',68),(1336,'Mpigamiti',68),(1337,'Nandete',68),(1338,'Nangano',68),(1339,'Ngoro',68),(1340,'Ngumbu',68),(1342,'Babati',69),(1341,'Babati Mjini',69),(1343,'Gallapo',69),(1344,'Babati Rural',70),(1346,'Dareda',70),(1345,'Gallapo',70),(1349,'Geterere',71),(1347,'Hanang',71),(1348,'Katesh',71),(1351,'Kibaya',72),(1350,'Kiteto',72),(1352,'Matui',72),(1355,'Dongobesh',73),(1353,'Mbulu',73),(1354,'Mbulu Mjini',73),(1358,'Loiborsoit',74),(1356,'Simanjiro',74),(1357,'Terrat',74),(1361,'Bweri',75),(1359,'Musoma Mjini',75),(1360,'Nyamiongo',75),(1363,'Bunda',76),(1364,'Butiama',76),(1362,'Musoma Rural',76),(1366,'Kinegeto',77),(1367,'Nyamunga',77),(1365,'Rorya',77),(1369,'Banagi',78),(1370,'Ikoma',78),(1368,'Serengeti',78),(1372,'Busegwe',79),(1371,'Butiama',79),(1373,'Nyakatende',79),(1374,'Bunda',80),(1375,'Bunda Mjini',80),(1376,'Hunyari',80),(1379,'Nyamongo',81),(1377,'Tarime',81),(1378,'Tarime Mjini',81),(1381,'Iganjo',82),(1382,'Mbalizi',82),(1380,'Mbeya Mjini',82),(1384,'Ileje',83),(1385,'Mbarali',83),(1383,'Mbeya Rural',83),(1386,'Chunya',84),(1387,'Itumba',84),(1388,'Mafyenga',84),(1390,'Ipinda',85),(1389,'Kyela',85),(1391,'Lupingu',85),(1394,'Mapogoro',86),(1392,'Mbarali',86),(1393,'Rujewa',86),(1397,'Katumba',87),(1395,'Rungwe',87),(1396,'Tukuyu',87),(1398,'Busokelo',88),(1399,'Lutebe',88),(1400,'Mpuguso',88),(1402,'Kichangani',89),(1403,'Mazimbu',89),(1401,'Morogoro Mjini',89),(1405,'Mkambalani',90),(1406,'Mkata',90),(1404,'Morogoro Rural',90),(1408,'Ifakara',91),(1407,'Kilombero',91),(1409,'Mang\'ula',91),(1410,'Gairo',92),(1411,'Gairo Mjini',92),(1412,'Nongwe',92),(1415,'Dumila',93),(1413,'Kilosa',93),(1414,'Kilosa Mjini',93),(1418,'Itete',94),(1416,'Malinyi',94),(1417,'Malinyi Mjini',94),(1421,'Lupiro',95),(1420,'Mahenge',95),(1419,'Ulanga',95),(1424,'Mikindani',96),(1422,'Mtwara Mjini',96),(1423,'Shangani',96),(1426,'Madimba',97),(1425,'Mtwara Rural',97),(1427,'Nanyumbu',97),(1430,'Chikundi',98),(1428,'Masasi',98),(1429,'Masasi Mjini',98),(1432,'Masuguru',99),(1433,'Mkomaindo',99),(1431,'Nanyumbu',99),(1436,'Mnekachi',100),(1434,'Newala',100),(1435,'Newala Mjini',100),(1437,'Mikindani',101),(1438,'Mtwara Mikindani',101),(1440,'Mdimba',102),(1441,'Ngonga',102),(1439,'Tandahimba',102),(1444,'Bugogwa',103),(1442,'Buhongwa',103),(1443,'Butimba',103),(1445,'Igogo',103),(1446,'Igoma',103),(1447,'Isamilo',103),(1448,'Kishiri',103),(1449,'Lwanhima',103),(1450,'Mabatini',103),(1451,'Mahina',103),(1452,'Mbugani',103),(1453,'Mirongo',103),(1454,'Mkolani',103),(1455,'Mkuyuni',103),(1456,'Nyamagana',103),(1457,'Nyegezi',103),(1458,'Pamba',103),(1459,'Sahwa',103),(1460,'Bugogwa',104),(1461,'Buswelu',104),(1462,'Buzuruga',104),(1463,'Ibungilo',104),(1464,'Ilemela',104),(1465,'Kahama',104),(1466,'Kawekamo',104),(1467,'Kayenze',104),(1468,'Kirumba',104),(1469,'Kiseke',104),(1470,'Kitangiri',104),(1471,'Mecco',104),(1472,'Nyakato',104),(1473,'Nyamanoro',104),(1474,'Nyamhongolo',104),(1475,'Nyasaka',104),(1476,'Pasiansi',104),(1477,'Shibula',104),(1478,'Busisi',105),(1479,'Chifunfu',105),(1480,'Ibisabageni',105),(1481,'Igalamya',105),(1482,'Irenzi',105),(1483,'Itwambila',105),(1484,'Kagunga',105),(1485,'Kasungamile',105),(1486,'Katunguru',105),(1487,'Kishinda',105),(1488,'Kuyuni',105),(1489,'Mission',105),(1490,'Mwabaluhi',105),(1493,'Nyamatongo',105),(1494,'Nyamazugo',105),(1491,'Nyampande',105),(1492,'Nyampulukano',105),(1495,'Nyasana',105),(1496,'Nyatukala',105),(1497,'Nyehunge',105),(1498,'Sengerema',105),(1499,'Tabaruka',105),(1500,'Buhingo',106),(1501,'Buhunda',106),(1502,'Bulemeji',106),(1503,'Busongo',106),(1504,'Fella',106),(1505,'Gulumungu',106),(1506,'Idetemya',106),(1507,'Igokelo',106),(1508,'Ilujamate',106),(1509,'Isenengeja',106),(1510,'Kanyelele',106),(1511,'Kasololo',106),(1512,'Kijima',106),(1513,'Koromije',106),(1514,'Lubili',106),(1515,'Mabuki',106),(1516,'Mamaye',106),(1517,'Mbarika',106),(1518,'Misasi',106),(1519,'Misungwi',106),(1520,'Mondo',106),(1521,'Mwaniko',106),(1522,'Nhundulu',106),(1523,'Shilalo',106),(1524,'Sumbugu',106),(1525,'Ukiriguru',106),(1526,'Usagara',106),(1527,'Buhumbi',107),(1528,'Bujashi',107),(1529,'Bujora',107),(1530,'Bukandwe',107),(1531,'Chabula',107),(1532,'Isandula',107),(1533,'Itumbili',107),(1534,'Jinjimili',107),(1535,'Kabila',107),(1536,'Kahangara',107),(1537,'Kandawe',107),(1538,'Kisesa',107),(1539,'Kitongo Sima',107),(1540,'Kongolo',107),(1541,'Lubugu',107),(1542,'Lutale',107),(1543,'Magu Mjini',107),(1544,'Mwamabanza',107),(1545,'Mwamanga',107),(1546,'Ng\'haya',107),(1547,'Nkungulu',107),(1548,'Nyanguge',107),(1549,'Nyigogo',107),(1550,'Shishani',107),(1551,'Sukuma',107),(1552,'Bugando',108),(1553,'Bungulwa',108),(1554,'Bupamwa',108),(1555,'Fukalo',108),(1556,'Hungumalwa',108),(1557,'Igongwa',108),(1558,'Ilula',108),(1559,'Iseni',108),(1560,'Kikubiji',108),(1561,'Lyoma',108),(1562,'Maligisu',108),(1563,'Malya',108),(1564,'Mantare',108),(1565,'Mhande',108),(1566,'Mwabomba',108),(1567,'Mwagi',108),(1568,'Mwakilyambiti',108),(1569,'Mwamala',108),(1570,'Mwandu',108),(1571,'Mwang\'halanga',108),(1572,'Mwankulwe',108),(1573,'Ng\'hundi',108),(1574,'Ngudu',108),(1575,'Ngulla',108),(1576,'Nkalalo',108),(1577,'Nyambiti',108),(1578,'Nyamilama',108),(1579,'Shilembo',108),(1580,'Sumve',108),(1581,'Walla',108),(1582,'Bukanda',109),(1583,'Bukiko',109),(1584,'Bukindo',109),(1585,'Bukongo',109),(1586,'Bukungu',109),(1587,'Bwisya',109),(1588,'Guta',109),(1589,'Ilangala',109),(1590,'Irugwa',109),(1591,'Kagera',109),(1592,'Kagunguli',109),(1593,'Kakukuru',109),(1594,'Makiolo',109),(1595,'Muriti',109),(1596,'Murutunguru',109),(1597,'Musesese',109),(1598,'Nakasungwa',109),(1599,'Namagondo',109),(1600,'Namupa',109),(1601,'Nansio',109),(1602,'Nduru',109),(1603,'Ngambo',109),(1604,'Ngholo',109),(1605,'Numbuwe',109),(1606,'Sizu',109),(1607,'Bangwe',110),(1608,'Bugoro',110),(1609,'Buhama',110),(1610,'Bukokwa',110),(1611,'Bulyaheke',110),(1612,'Bupandwa',110),(1613,'Iligamba',110),(1614,'Irenza',110),(1615,'Kafunzo',110),(1616,'Kalebezo',110),(1617,'Kasisa',110),(1618,'Katwe',110),(1619,'Kazunzu',110),(1620,'Lugata',110),(1621,'Luharanyonga',110),(1622,'Luhuza',110),(1623,'Maisome',110),(1624,'Nyakaliro',110),(1625,'Nyakasasa',110),(1626,'Nyakasungwa',110),(1627,'Nyanzenda',110),(1628,'Nyehunge',110),(1629,'Ihanga',111),(1630,'Iwungilo',111),(1631,'Kifanya',111),(1632,'Lugenge',111),(1633,'Luponde',111),(1634,'Matola',111),(1635,'Mjimwema',111),(1636,'Mtwango',111),(1637,'Njombe Mjini',111),(1638,'Ramadhani',111),(1640,'Utalingolo',111),(1639,'Uwemba',111),(1641,'Yakobi',111),(1642,'Idamba',112),(1643,'Igongolo',112),(1644,'Ikemidi',112),(1645,'Ikondo',112),(1646,'Kichiwa',112),(1647,'Kidegembye',112),(1648,'Lupembe',112),(1649,'Matembwe',112),(1650,'Mfriga',112),(1651,'Mtwango',112),(1652,'Nundu',112),(1653,'Saja',112),(1654,'Kifumbe',113),(1655,'Kiganga',113),(1656,'Kigonsera',113),(1657,'Kitandililo',113),(1658,'Lyamkena',113),(1659,'Maguvani',113),(1660,'Mahongole',113),(1661,'Majengo',113),(1662,'Makambako Mjini',113),(1663,'Mjimwema',113),(1664,'Mlowa',113),(1665,'Mwembetogwa',113),(1666,'Ibumi',114),(1667,'Iwela',114),(1668,'Kihore',114),(1669,'Kilondo',114),(1670,'Lifua',114),(1671,'Line',114),(1672,'Ludewa',114),(1673,'Lugarawa',114),(1674,'Luilo',114),(1675,'Lumbila',114),(1677,'Lupana',114),(1676,'Lupanga',114),(1678,'Lusala',114),(1679,'Madope',114),(1680,'Makere',114),(1681,'Masasi',114),(1682,'Mavanga',114),(1683,'Milo',114),(1684,'Mkongobaki',114),(1685,'Mlangali',114),(1686,'Mundindi',114),(1687,'Namtumbu',114),(1688,'Ngosoro',114),(1689,'Nkomang\'ombe',114),(1690,'Ruhuhu',114),(1691,'Uwemba',114),(1692,'Bulongwa',115),(1693,'Ikuwo',115),(1694,'Iniho',115),(1695,'Ipelele',115),(1696,'Ipwani',115),(1697,'Isapulano',115),(1698,'Itani',115),(1699,'Iwawa',115),(1700,'Kigala',115),(1701,'Kigulu',115),(1702,'Kipagalo',115),(1703,'Kitulo',115),(1704,'Lupalilo',115),(1705,'Lupila',115),(1706,'Luvisulu',115),(1707,'Mangunua',115),(1708,'Matamba',115),(1709,'Mbalatse',115),(1710,'Mfinga',115),(1711,'Mlondwe',115),(1712,'Tandala',115),(1713,'Ukinga',115),(1714,'Uwemba',115),(1715,'Igula',116),(1716,'Igwachanya',116),(1717,'Ikingula',116),(1719,'Ilembula',116),(1718,'Imalinyi',116),(1720,'Itandula',116),(1721,'Kijombe',116),(1722,'Kipengele',116),(1723,'Luduga',116),(1724,'Makoga',116),(1725,'Matembwe',116),(1726,'Mdandu',116),(1727,'Mtwango',116),(1728,'Njombe Kusini',116),(1729,'Sajilo',116),(1730,'Ulembwe',116),(1731,'Ushiri',116),(1732,'Uwemba',116),(1735,'Wangama',116),(1733,'Wanging\'ombe',116),(1734,'Wino',116),(1736,'Kibaha',117),(1737,'Kongowe',117),(1738,'Maili Moja',117),(1739,'Mbwawa',117),(1740,'Misugusugu',117),(1741,'Mkuza',117),(1742,'Msangani',117),(1743,'Pangani',117),(1744,'Picha ya Ndege',117),(1745,'Sofu',117),(1746,'Tangini',117),(1747,'Tumbi',117),(1748,'Visiga',117),(1749,'Viziwaziwa',117),(1750,'Bokomnemela',118),(1751,'Gwata',118),(1752,'Jamboilo',118),(1753,'Kawawa',118),(1754,'Kikwira',118),(1755,'Kwala',118),(1756,'Magindu',118),(1757,'Mlandizi',118),(1758,'Mtongani',118),(1759,'Mvumo',118),(1760,'Ruvu',118),(1761,'Soga',118),(1762,'Uwemba',118),(1763,'Viziwaziwa',118),(1764,'Dunda',119),(1765,'Fukayosi',119),(1766,'Kerege',119),(1767,'Kiwangwa',119),(1768,'Magomeni',119),(1769,'Majengo',119),(1770,'Makuruge',119),(1771,'Mapinga',119),(1772,'Nianjema',119),(1773,'Yombo',119),(1774,'Zinga',119),(1775,'Bwilingu',120),(1776,'Chalinze',120),(1777,'Kibindu',120),(1778,'Kimange',120),(1779,'Kiuyuni',120),(1780,'Lugoba',120),(1781,'Mandera',120),(1782,'Mbwewe',120),(1783,'Miono',120),(1784,'Mkange',120),(1785,'Msata',120),(1786,'Msoga',120),(1787,'Pera',120),(1788,'Talawanda',120),(1789,'Uziwa',120),(1790,'Cholesamvula',121),(1791,'Kibuta',121),(1792,'Kiluvya',121),(1793,'Kisarawe',121),(1794,'Kuruwi',121),(1795,'Mafizi',121),(1796,'Maneromango',121),(1797,'Marui',121),(1798,'Masanganya',121),(1800,'Msanga',121),(1799,'Msimbu',121),(1801,'Mvuma',121),(1802,'Mwasonga',121),(1803,'Palaka',121),(1804,'Shungubweni',121),(1805,'Vihingo',121),(1806,'Vikumburu',121),(1807,'Baleni',122),(1808,'Jibondo',122),(1809,'Kanga',122),(1810,'Kiegeani',122),(1811,'Kilindoni',122),(1812,'Kirongwe',122),(1813,'Miburani',122),(1814,'Ndagoni',122),(1816,'Bulegeza',123),(1815,'Bupu',123),(1817,'Kiluvya',123),(1818,'Kimanzichana',123),(1819,'Kiparang\'anda',123),(1820,'Kisemvule',123),(1821,'Kisiju',123),(1822,'Kitumbi',123),(1823,'Lukanga',123),(1824,'Luzerere',123),(1825,'Magawa',123),(1826,'Mbezi',123),(1828,'Mkamba',123),(1827,'Mkuranga',123),(1829,'Mwalusembe',123),(1831,'Mwandege',123),(1830,'Mwarusembe',123),(1832,'Nyamato',123),(1833,'Nyamisati',123),(1834,'Panuo',123),(1835,'Shungubweni',123),(1836,'Tambani',123),(1837,'Tanduo',123),(1838,'Vianzi',123),(1839,'Vikindu',123),(1840,'Bungu',124),(1841,'Chemchem',124),(1842,'Ikwiriri',124),(1843,'Kipugira',124),(1844,'Mapanda',124),(1845,'Mbwara',124),(1846,'Mlanzi',124),(1847,'Mohoro',124),(1848,'Ngorotwa',124),(1849,'Nyamisati',124),(1850,'Salale',124),(1851,'Umwe',124),(1852,'Utete',124),(1853,'Chanji',125),(1854,'Ipuyi',125),(1855,'Izia',125),(1856,'Kasense',125),(1857,'Katandala',125),(1858,'Katuma',125),(1859,'Kizwite',125),(1860,'Majengo',125),(1861,'Malangali',125),(1862,'Matanga',125),(1863,'Mazwi',125),(1864,'Milanzi',125),(1865,'Mollo',125),(1870,'Mwadui',125),(1866,'Ntendo',125),(1867,'Old Sumbawanga',125),(1868,'Pito',125),(1869,'Senga',125),(1871,'Ilemba',126),(1872,'Kaengesa',126),(1873,'Kalambazite',126),(1874,'Kaoze',126),(1875,'Kipeta',126),(1876,'Laela',126),(1877,'Lusaka',126),(1878,'Mfinga',126),(1879,'Milepa',126),(1880,'Mpui',126),(1881,'Mtowisa',126),(1882,'Muze',126),(1883,'Mwadui',126),(1884,'Sandulula',126),(1885,'Zimba',126),(1886,'Asante',127),(1887,'Chala',127),(1888,'Isale',127),(1889,'Itebi',127),(1890,'Kabwe',127),(1891,'Kala',127),(1892,'Kate',127),(1893,'Kipande',127),(1894,'Kipili',127),(1895,'Kirando',127),(1896,'Korongwe',127),(1897,'Lwafi',127),(1898,'Manda',127),(1899,'Mkinga',127),(1900,'Mkwamba',127),(1901,'Mtenga',127),(1902,'Myula',127),(1903,'Namanyere',127),(1904,'Nambogo',127),(1905,'Namtansi',127),(1906,'Nankanga',127),(1908,'Nkomolo',127),(1907,'Nkundi',127),(1909,'Paramawe',127),(1910,'Sintali',127),(1911,'Swaila',127),(1912,'Utinta',127),(1913,'Wampembe',127),(1914,'Kalambo',128),(1915,'Kapozwa',128),(1916,'Kasanga',128),(1917,'Katazi',128),(1918,'Katete',128),(1919,'Kilesha',128),(1920,'Kisumba',128),(1921,'Legezamwendo',128),(1922,'Lyangalile',128),(1923,'Matai',128),(1924,'Mbuluma',128),(1925,'Mkali',128),(1926,'Mkowe',128),(1927,'Mnazi',128),(1928,'Mwembe',128),(1929,'Mwimbi',128),(1930,'Mwiswi',128),(1931,'Singiwe',128),(1932,'Sopa',128),(1933,'Sunduma',128),(1934,'Ulumi',128),(1935,'Bombambili',129),(1936,'Lilambo',129),(1937,'Lizaboni',129),(1938,'Magagura',129),(1939,'Majengo',129),(1940,'Matarawe',129),(1941,'Mateka',129),(1954,'Matogoro',129),(1942,'Mfaranyaki',129),(1946,'Misufini',129),(1943,'Mjimwema',129),(1944,'Mjini',129),(1945,'Mletele',129),(1947,'Msamala',129),(1948,'Mshangano',129),(1949,'Mwenge',129),(1950,'Ndilima Litembo',129),(1955,'Oysterbay',129),(1951,'Ruvuma',129),(1952,'Subira',129),(1953,'Tanga',129),(1956,'Kilagano',130),(1957,'Kiwira',130),(1958,'Liganga',130),(1959,'Litimbi',130),(1960,'Litowa',130),(1961,'Lumecha',130),(1962,'Magagura',130),(1963,'Maposeni',130),(1964,'Matimira',130),(1965,'Mbingamhalule',130),(1966,'Mpitimbi',130),(1967,'Mshangano',130),(1968,'Muhukuru',130),(1969,'Mungumaji',130),(1970,'Ndongosi',130),(1971,'Peramiho',130),(1998,'Amani Makolo',131),(1972,'Chiendagala',131),(1973,'Kigonsera',131),(1974,'Kihangi',131),(1999,'Kihita',131),(1975,'Kilimani',131),(1976,'Kingerikiti',131),(2000,'Kiperere',131),(1977,'Kitura',131),(1978,'Langiro',131),(1979,'Linda',131),(1980,'Liparamba',131),(2001,'Liteho',131),(1982,'Litembo',131),(1981,'Litumbandyosi',131),(1983,'Lukarasi',131),(2002,'Lukole',131),(1984,'Maguu',131),(2003,'Mapera',131),(1985,'Matiri',131),(1986,'Mbamba Bay',131),(1987,'Mbinga',131),(1988,'Mbuji',131),(2004,'Mkako',131),(1991,'Mkalanga',131),(1992,'Mkumbi',131),(2005,'Mpandangindo',131),(1993,'Mpapa',131),(1989,'Mpepai',131),(1994,'Mpepo',131),(1995,'Mseto',131),(2006,'Mtingi',131),(1990,'Mtipwili',131),(2007,'Muzumbanguru',131),(2008,'Ndunguru',131),(2009,'Ngimani',131),(1996,'Ngumbo',131),(2010,'Nyoni',131),(2011,'Ruanda',131),(1997,'Tingi',131),(2012,'Ukumbi',131),(2013,'Wukiro',131),(2014,'Hanga',132),(2015,'Igira',132),(2016,'Kaungo',132),(2017,'Kikolo',132),(2018,'Libasawandu',132),(2019,'Lisimonji',132),(2020,'Luegu',132),(2021,'Lusewa',132),(2022,'Magazini',132),(2023,'Mgombasi',132),(2024,'Mkongo',132),(2025,'Mputa',132),(2026,'Msindo',132),(2027,'Mtwalo',132),(2028,'Mwinyi',132),(2029,'Namtumbo',132),(2030,'Nasuli',132),(2031,'Ndirima',132),(2032,'Njomatwa',132),(2033,'Rwinga',132),(2034,'Uchindile',132),(2035,'Chiwanda',133),(2036,'Kihucha',133),(2037,'Kilosa',133),(2038,'Kingerikiti',133),(2039,'Ling\'aho',133),(2040,'Liparamba',133),(2041,'Lipingo',133),(2042,'Lituhi',133),(2043,'Liuli',133),(2044,'Lumeme',133),(2045,'Lundo',133),(2046,'Lundu',133),(2047,'Mapogoro',133),(2048,'Mbamba Bay',133),(2050,'Mpepo',133),(2051,'Mseto',133),(2049,'Mtipwili',133),(2052,'Ngumbo',133),(2053,'Tingi',133),(2054,'Chiwana',134),(2055,'Jakika',134),(2056,'Kalulu',134),(2057,'Kandulu',134),(2058,'Kasime',134),(2059,'Kibasila',134),(2060,'Ligoma',134),(2061,'Ligunga',134),(2062,'Lukumbule',134),(2063,'Lumasule',134),(2064,'Mbesa',134),(2065,'Mchangani',134),(2066,'Mchesi',134),(2067,'Mchinga',134),(2068,'Mndumbikanchele',134),(2069,'Mnemela',134),(2070,'Mtina',134),(2071,'Mtonya',134),(2072,'Muaru',134),(2073,'Mwenemtwana',134),(2074,'Namakambale',134),(2075,'Namasakata',134),(2076,'Namatunu',134),(2077,'Nandembo',134),(2078,'Nanyumbu',134),(2079,'Ngapa',134),(2080,'Nghonoli',134),(2081,'Njame',134),(2082,'Sisi kwa Sisi',134),(2083,'Tunduru Mjini',134),(2084,'Chamaguha',135),(2085,'Chibe',135),(2086,'Ibadakuli',135),(2087,'Ibinzamata',135),(2088,'Kambarage',135),(2089,'Kitangili',135),(2090,'Kizumbi',135),(2091,'Kolandoto',135),(2092,'Lubaga',135),(2093,'Masekelo',135),(2094,'Mwamalili',135),(2095,'Mwawaza',135),(2096,'Ndala',135),(2097,'Ndembezi',135),(2098,'Ngokolo',135),(2099,'Old Shinyanga',135),(2100,'Shinyanga Mjini',135),(2101,'Badui',136),(2102,'Didia',136),(2103,'Ilaula',136),(2104,'Ilola',136),(2105,'Imesela',136),(2106,'Iselamagazi',136),(2107,'Itwangi',136),(2108,'Lyabukande',136),(2109,'Lyabusalu',136),(2110,'Lyamidati',136),(2111,'Masekelo',136),(2112,'Mwakitolyo',136),(2113,'Mwamala',136),(2115,'Mwantini',136),(2114,'Mwanyenze',136),(2116,'Mwenge',136),(2117,'Nyamalogo',136),(2118,'Nyida',136),(2119,'Pandagichiza',136),(2120,'Puni',136),(2121,'Salawe',136),(2122,'Samuye',136),(2123,'Solwa',136),(2124,'Tinde',136),(2125,'Usanda',136),(2126,'Usule',136),(2127,'Busoka',137),(2128,'Isaka',137),(2129,'Iyenze',137),(2130,'Kagongwa',137),(2131,'Kahama Mjini',137),(2132,'Kilasungwa',137),(2133,'Majengo',137),(2134,'Malunga',137),(2135,'Mhongolo',137),(2136,'Mhungula',137),(2137,'Mndarpa',137),(2138,'Mshabaidu',137),(2139,'Munze',137),(2140,'Mwendakulima',137),(2141,'Ngogwa',137),(2142,'Nyahanga',137),(2143,'Nyasubi',137),(2144,'Nyatukala',137),(2145,'Sabasaba',137),(2146,'Zongomera',137),(2147,'Bubiki',138),(2148,'Bunambiyu',138),(2149,'Itilima',138),(2150,'Kiloleli',138),(2151,'Kishapu',138),(2152,'Lagana',138),(2153,'Masanga',138),(2154,'Mondo',138),(2155,'Mwadui Lohumbo',138),(2156,'Mwakido',138),(2157,'Mwamalasa',138),(2158,'Mwanyata',138),(2159,'Mwasubi',138),(2160,'Mwataga',138),(2161,'Mwaweja',138),(2162,'Ngofila',138),(2163,'Seke-Bugayambelele',138),(2164,'Songwa',138),(2165,'Talaga',138),(2166,'Uchunga',138),(2167,'Bukibi',139),(2168,'Bulungwa',139),(2169,'Dakama',139),(2170,'Igamanilo',139),(2171,'Igunda',139),(2172,'Ikindilo',139),(2173,'Kisabo',139),(2174,'Mapanda',139),(2175,'Mpunze',139),(2176,'Mvunganyanya',139),(2177,'Mwakalila',139),(2178,'Nyamigele',139),(2179,'Nyankende',139),(2180,'Nyasiro',139),(2181,'Sabasabini',139),(2182,'Ulewe',139),(2183,'Ushetu',139),(2184,'Ushimba',139),(2185,'Ushirika',139),(2186,'Uyogo',139),(2187,'Bariadi',140),(2188,'Bariadi Mjini',140),(2189,'Somanda',140),(2190,'Busega',141),(2191,'Busega Mjini',141),(2192,'Malampaka',141),(2193,'Itilima',142),(2194,'Itilima Mjini',142),(2195,'Lagang\'a',142),(2196,'Maswa',143),(2197,'Maswa Mjini',143),(2198,'Sengerema',143),(2199,'Meatu',144),(2200,'Meatu Mjini',144),(2201,'Mwanhuzi',144),(2203,'Singida',145),(2202,'Singida Mjini',145),(2204,'Unyampanda',145),(2206,'Mgori',146),(2207,'Ntunduru',146),(2205,'Singida Rural',146),(2208,'Ikungi',147),(2209,'Ikungi Mjini',147),(2210,'Sepuko',147),(2213,'Kintinku',148),(2211,'Manyoni',148),(2212,'Manyoni Mjini',148),(2214,'Iramba',149),(2215,'Kiomboi',149),(2216,'Mtoa',149),(2219,'Ibaga',150),(2217,'Mkalama',150),(2218,'Mkalama Mjini',150),(2220,'Songwe',151),(2221,'Songwe Mjini',151),(2222,'Vwawa',151),(2223,'Ileje',152),(2224,'Ileje Mjini',152),(2225,'Mbebe',152),(2226,'Mbozi',153),(2227,'Mbozi Mjini',153),(2228,'Vwawa',153),(2229,'Momba',154),(2230,'Momba Mjini',154),(2231,'Tunduma',154),(2234,'Namwawala',155),(2232,'Tunduma',155),(2233,'Tunduma Mjini',155),(2237,'Kigoma',156),(2236,'Tabora',156),(2235,'Tabora Mjini',156),(2240,'Itetemia',157),(2238,'Tabora Rural',157),(2239,'Uyui',157),(2241,'Igunga',158),(2242,'Igunga Mjini',158),(2243,'Nkinga',158),(2244,'Kaliua',159),(2245,'Kaliua Mjini',159),(2246,'Ushirika',159),(2249,'Mwanhala',160),(2247,'Nzega',160),(2248,'Nzega Mjini',160),(2250,'Sikonge',161),(2251,'Sikonge Mjini',161),(2252,'Tutuo',161),(2253,'Urambo',162),(2254,'Urambo Mjini',162),(2255,'Usoke',162),(2258,'Makorora',163),(2257,'Tanga',163),(2256,'Tanga Mjini',163),(2261,'Amani',164),(2259,'Muheza',164),(2260,'Muheza Mjini',164),(2262,'Korogwe',165),(2263,'Korogwe Mjini',165),(2264,'Mombo',165),(2265,'Lushoto',166),(2266,'Lushoto Mjini',166),(2267,'Mlalo',166),(2268,'Handeni',167),(2269,'Handeni Mjini',167),(2270,'Mkata',167),(2271,'Kilindi',168),(2272,'Kilindi Mjini',168),(2273,'Pangani',168),(2276,'Kwale',169),(2274,'Mkinga',169),(2275,'Mkinga Mjini',169),(2277,'Bumbuli',170),(2278,'Bumbuli Mjini',170),(2279,'Funta',170),(2281,'Handeni',171),(2280,'Handeni Town',171),(2283,'Korogwe',172),(2282,'Korogwe Town',172),(2286,'Kunduchi',173),(2284,'Magharibi',173),(2285,'Mbweni',173),(2289,'Kiembe Samaki',174),(2287,'Mjini',174),(2288,'Stone Town',174),(2292,'Konde',175),(2290,'Micheweni',175),(2291,'Micheweni Mjini',175),(2295,'Mkoani',176),(2293,'Wete',176),(2294,'Wete Mjini',176),(2296,'Chake Chake',177),(2297,'Chake Chake Mjini',177),(2298,'Wambaa',177),(2301,'Kengeja',178),(2299,'Mkoani',178),(2300,'Mkoani Mjini',178),(2302,'Kaskazini A',179),(2303,'Mkokotoni',179),(2304,'Nungwi',179),(2305,'Kaskazini B',180),(2306,'Mkwajuni',180),(2307,'Tumbatu',180),(2309,'Jozani',181),(2308,'Kati',181),(2310,'Muungoni',181),(2312,'Kizimkazi',182),(2311,'Kusini',182),(2313,'Makunduchi',182);
/*!40000 ALTER TABLE `core_ward` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `core_zone`
--

DROP TABLE IF EXISTS `core_zone`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `core_zone` (
  `id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(100) NOT NULL,
  `country_id` bigint NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `core_zone_country_id_name_22191a38_uniq` (`country_id`,`name`),
  CONSTRAINT `core_zone_country_id_0e457453_fk` FOREIGN KEY (`country_id`) REFERENCES `core_country` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=103 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `core_zone`
--

LOCK TABLES `core_zone` WRITE;
/*!40000 ALTER TABLE `core_zone` DISABLE KEYS */;
INSERT INTO `core_zone` VALUES (3,'Almasi & Alizeti',1),(10,'Bluu Visiwani',1),(1,'Kahawa & Dhahabu',1),(8,'Korosho Kusini',1),(5,'Mlimani Kasikazini',1),(7,'Nyasa & Mchuchuma',1),(9,'Tanganyika Kusini',1),(6,'Tanganyika Mashariki',1),(4,'Zabibu & Alizeti',1),(2,'Ziwa Victoria',1);
/*!40000 ALTER TABLE `core_zone` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `django_admin_log`
--

DROP TABLE IF EXISTS `django_admin_log`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `django_admin_log` (
  `id` int NOT NULL AUTO_INCREMENT,
  `action_time` datetime(6) NOT NULL,
  `object_id` longtext,
  `object_repr` varchar(200) NOT NULL,
  `action_flag` smallint unsigned NOT NULL,
  `change_message` longtext NOT NULL,
  `content_type_id` int DEFAULT NULL,
  `user_id` bigint NOT NULL,
  PRIMARY KEY (`id`),
  KEY `django_admin_log_content_type_id_c4bce8eb_fk_django_co` (`content_type_id`),
  KEY `django_admin_log_user_id_c564eba6_fk` (`user_id`),
  CONSTRAINT `django_admin_log_content_type_id_c4bce8eb_fk_django_co` FOREIGN KEY (`content_type_id`) REFERENCES `django_content_type` (`id`),
  CONSTRAINT `django_admin_log_chk_1` CHECK ((`action_flag` >= 0))
) ENGINE=InnoDB AUTO_INCREMENT=715 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `django_admin_log`
--

LOCK TABLES `django_admin_log` WRITE;
/*!40000 ALTER TABLE `django_admin_log` DISABLE KEYS */;
INSERT INTO `django_admin_log` VALUES (1,'2026-08-25 20:14:56.295340','1','sport teacher',1,'[{\"added\": {}}]',2,1),(2,'2026-08-25 20:24:12.464306','2','seb343@gmail.com (Sport Teacher)',1,'[{\"added\": {}}]',25,1),(3,'2026-08-25 20:28:48.618728','1','sport teacher',2,'[{\"changed\": {\"fields\": [\"Permissions\"]}}]',2,1),(52,'2026-08-26 01:54:22.196428','52','dds – Zabibu & Alizeti',1,'[{\"added\": {}}]',17,1),(103,'2026-09-09 18:55:06.828472','52','seb31243@gmail.com (District Manager)',1,'[{\"added\": {}}]',25,1),(154,'2026-09-09 21:25:05.977002','103','Charlie (Talent Admin)',1,'[{\"added\": {}}]',25,1),(155,'2026-09-09 21:27:51.294442','103','Charlie (Talent Admin)',2,'[{\"changed\": {\"fields\": [\"Gender\", \"New Password\", \"Confirm New Password\"]}}]',25,1),(156,'2026-09-09 21:31:23.418662','103','Charlie (Talent Admin)',3,'',25,1),(157,'2026-09-09 21:43:04.564912','104','charlielipingu@gmail.com (Sport Teacher)',1,'[{\"added\": {}}]',25,1),(158,'2026-09-09 21:52:12.446647','105','admin@gmail.com (District Manager)',1,'[{\"added\": {}}]',25,1),(159,'2026-09-09 22:07:33.531772','106','benja@gmail.com (Student)',1,'[{\"added\": {}}]',25,1),(160,'2026-09-09 22:16:59.845267','1','how to play so well (District)',1,'[{\"added\": {}}]',5,1),(161,'2026-09-09 22:37:28.988706','107','Iman (District Manager)',1,'[{\"added\": {}}]',25,1),(162,'2026-09-09 22:39:04.913039','107','imanseba@gmail.com (District Manager)',2,'[{\"changed\": {\"fields\": [\"Username\", \"Gender\", \"New Password\", \"Confirm New Password\"]}}]',25,1),(205,'2026-09-22 19:56:12.672042','154','sewnik@gmail.com (District Manager)',1,'[{\"added\": {}}]',25,1),(206,'2026-09-23 05:56:26.622122','155','mwes@gmail.com (Student)',1,'[{\"added\": {}}]',25,1),(256,'2026-09-23 16:30:06.625899','205','kale@gmail.com (Sport Teacher)',1,'[{\"added\": {}}]',25,1),(257,'2026-09-23 16:30:32.337371','206','kale23@gmail.com (Sport Teacher)',1,'[{\"added\": {}}]',25,1),(258,'2026-09-23 23:03:01.724090','52','nyaishoz (s.0677)',1,'[{\"added\": {}}]',18,1),(259,'2026-09-23 23:11:38.931910','207','elia@gmail.com (Sport Teacher)',1,'[{\"added\": {}}]',25,1),(307,'2026-09-26 19:21:50.004822','54','kaisho (p5677)',2,'[{\"added\": {\"name\": \"school club\", \"object\": \"Burigi Club (kaisho)\"}}]',18,1),(308,'2026-09-26 19:30:48.224496','54','kaisho (p5677)',2,'[{\"added\": {\"name\": \"school club\", \"object\": \"Mikumi Club (kaisho)\"}}, {\"added\": {\"name\": \"school club\", \"object\": \"Rumanyika Club (kaisho)\"}}]',18,1),(309,'2026-09-26 19:31:20.392086','54','kaisho (p5677)',2,'[{\"changed\": {\"fields\": [\"Is approved\"]}}]',18,1),(310,'2026-09-27 02:12:59.251761','312','pauline@gmail.com (Student)',1,'[{\"added\": {}}]',25,1),(358,'2026-10-01 23:14:43.951673','154','nyabishenge (S0665)',2,'[{\"changed\": {\"fields\": [\"Email\"]}}]',18,1),(359,'2026-10-01 23:15:28.970161','8','ST. MARY QUEEN OF THE APOSTLES SS (s0185)',2,'[]',18,1),(360,'2026-10-02 03:29:01.148661','3','CHRIST THE KING NYANTAKUBWA (GIRLS) SS (s4965)',2,'[{\"changed\": {\"fields\": [\"Is approved\"]}}]',18,1),(361,'2026-10-02 03:29:45.451549','154','nyabishenge (S0665)',2,'[{\"changed\": {\"fields\": [\"Is approved\"]}}]',18,1),(362,'2026-10-02 03:30:56.598810','103','Tosamaganga (S703)',2,'[{\"changed\": {\"fields\": [\"Is approved\"]}}]',18,1),(363,'2026-10-02 03:31:17.152823','5','JUVENARY BUZINZA SS (s1823)',2,'[{\"changed\": {\"fields\": [\"Is approved\"]}}]',18,1),(364,'2026-10-02 03:32:23.182644','4','EXPERANCIA SS (s5628)',3,'',18,1),(409,'2026-10-17 17:45:25.929125','514','nyandindi anazingua et anataka kumlea eng seba (School)',3,'',5,1),(460,'2026-10-17 23:19:41.582123','362','dudubaya (School)',3,'',5,1),(461,'2026-10-17 23:20:19.050260','565','fear ladies (School)',3,'',5,1),(462,'2026-10-17 23:20:19.050317','464','mathematics results are out (School)',3,'',5,1),(463,'2026-10-17 23:20:19.050351','463','wanafunzi matokeo yenu tayari (School)',3,'',5,1),(464,'2026-10-17 23:20:19.050383','412','mkuu wenu mimi (School)',3,'',5,1),(465,'2026-10-17 23:21:24.748607','307','gshsjs (District)',3,'',5,1),(466,'2026-10-17 23:21:24.748677','154','ee (District)',3,'',5,1),(467,'2026-10-17 23:21:24.748724','53','gg (School)',3,'',5,1),(468,'2026-10-17 23:21:24.748755','104','eeee (District)',3,'',5,1),(469,'2026-10-17 23:21:24.748783','103','fff (District)',3,'',5,1),(511,'2026-10-21 05:00:22.056492','256','ahakachiro (School)',3,'',29,1),(512,'2026-10-21 05:04:09.223193','416','TANZANIA ONE CHAMPS (District)',3,'',29,1),(513,'2026-10-21 05:04:09.223356','462','mukundane (School)',3,'',29,1),(514,'2026-10-21 05:04:09.223549','415','CHARLIE KAONJA COMPETITION (School)',3,'',29,1),(515,'2026-10-21 05:04:09.223644','209','gaston (School)',3,'',29,1),(516,'2026-10-21 05:04:09.223731','465','Gerrad livermore competition (School)',3,'',29,1),(517,'2026-10-21 05:04:09.223816','520','omgongo (District)',3,'',29,1),(518,'2026-10-21 05:04:09.223906','564','joh (School)',3,'',29,1),(519,'2026-10-21 05:04:09.224083','464','GILMORE TALENT SEARCH (School)',3,'',29,1),(520,'2026-10-21 05:04:09.224174','158','omukolo (School)',3,'',29,1),(521,'2026-10-21 05:04:09.224237','727','joh (District)',3,'',29,1),(522,'2026-10-21 05:04:09.224279','726','mwazye (District)',3,'',29,1),(523,'2026-10-21 05:04:09.224316','725','new (School)',3,'',29,1),(524,'2026-10-21 05:04:09.224350','259','programmers (School)',3,'',29,1),(525,'2026-10-21 05:04:09.224387','724','ew (School)',3,'',29,1),(526,'2026-10-21 05:04:09.224462','723','GOLDEN TULIP COMPETITION (School)',3,'',29,1),(527,'2026-10-21 05:04:09.224507','722','VUMILIA KAUSHA_1 (School)',3,'',29,1),(528,'2026-10-21 05:04:09.224540','721','VUMILIA KAUSHA CUP (School)',3,'',29,1),(529,'2026-10-21 05:04:09.224574','720','CCM_BALET COMPETITION (School)',3,'',29,1),(530,'2026-10-21 05:04:09.224607','718','MONETARY FRAUDARANT COMPETITION (School)',3,'',29,1),(531,'2026-10-21 05:04:09.224639','717','CHARLIE CHAPLIN INT\' FUND (School)',3,'',29,1),(532,'2026-10-21 05:04:09.224680','668','eng seba (School)',3,'',29,1),(533,'2026-10-21 05:04:09.224711','518','MKUYUNI FESTIVAL #102 (District)',3,'',29,1),(534,'2026-10-21 05:04:09.224740','514','GOOD NEWS COMPETITION (School)',3,'',29,1),(535,'2026-10-21 05:04:09.224768','362','Hopkins general competiton (School)',3,'',29,1),(536,'2026-10-21 05:04:09.224798','667','mji mwema (School)',3,'',29,1),(537,'2026-10-21 05:04:09.224829','666','dancing (School)',3,'',29,1),(538,'2026-10-21 05:04:09.224869','515','GOOGLE SOFTWARE COMPETITION (District)',3,'',29,1),(539,'2026-10-21 05:04:09.224934','414','ONE CHANCE-POST COMPETITION (District)',3,'',29,1),(540,'2026-10-21 05:04:09.225005','369','POST-SOFTWARE COMPETITION (District)',3,'',29,1),(541,'2026-10-21 05:04:09.225042','313','SEPTEMBER-POST COMP (District)',3,'',29,1),(542,'2026-10-21 05:04:09.225074','311','MIDTERM-POST COMPETION (District)',3,'',29,1),(543,'2026-10-21 05:04:09.225113','309','Nkwenda District competition (District)',3,'',29,1),(544,'2026-10-21 05:04:09.225141','411','BALTIMORE COMPETITION (District)',3,'',29,1),(545,'2026-10-21 05:04:09.225170','361','Gilmore national competition (School)',3,'',29,1),(546,'2026-10-21 05:04:09.225198','519','Mathematics PSLE (School)',3,'',29,1),(547,'2026-10-21 05:04:09.225226','719','gm (School)',3,'',29,1),(548,'2026-10-21 05:04:09.225255','517','MKUYUNI FESTIVAL#101 (School)',3,'',29,1),(549,'2026-10-21 05:04:09.225283','513','GERRARD LIVERMORE COMPETITION (District)',3,'',29,1),(550,'2026-10-21 05:04:09.225311','413','ONE CHANCE COMPETITION (School)',3,'',29,1),(551,'2026-10-21 05:04:09.225339','155','kagoye (District)',3,'',29,1),(552,'2026-10-21 05:04:09.225367','615','mwakanyamale (School)',3,'',29,1),(553,'2026-10-21 05:04:09.225395','521','Kahawa & Dhahabu Zone Competition (Zone)',3,'',29,1),(554,'2026-10-21 05:04:09.225422','516','Bluu Visiwani Zone Competition (Zone)',3,'',29,1),(555,'2026-10-21 05:04:09.225450','412','TANZANIA ONE COMPETITION (School)',3,'',29,1),(556,'2026-10-21 05:04:09.225478','368','SOFTWARE COMPETITION (School)',3,'',29,1),(557,'2026-10-21 05:04:09.225505','367','SEBASTIAN FUND COMPETITION (School)',3,'',29,1),(558,'2026-10-21 05:04:09.225533','366','CHARLIE KAONJA  COMPETITION FUND (School)',3,'',29,1),(559,'2026-10-21 05:04:09.225560','365','TRUMAN COMPETITION (School)',3,'',29,1),(560,'2026-10-21 05:04:09.225587','364','CHELSEA FOOTBALL KIT CLINIC (School)',3,'',29,1),(561,'2026-10-21 05:04:09.225614','360','Anna tibaijuka competition (School)',3,'',29,1),(562,'2026-10-21 05:04:09.225642','359','midterm test (District)',3,'',29,1),(563,'2026-10-21 05:04:09.225671','463','mukwatage (District)',3,'',29,1),(564,'2026-10-21 05:04:09.225699','363','Hopkins competition (School)',3,'',29,1),(565,'2026-10-21 05:04:09.225727','314','USAID FUND COMP (District)',3,'',29,1),(566,'2026-10-21 05:04:09.225755','312','SEPTEMBER STORY COMPETITION (School)',3,'',29,1),(567,'2026-10-21 05:04:09.225782','310','MIDTERM COMPETITION (School)',3,'',29,1),(568,'2026-10-21 05:04:09.225811','308','Tanzania one cooking comp (School)',3,'',29,1),(569,'2026-10-21 05:04:09.225838','307','Charlie student competition (School)',3,'',29,1),(570,'2026-10-21 05:04:09.225866','257','ahakachiri (District)',3,'',29,1),(571,'2026-10-21 05:04:09.225893','52','mwizaje (School)',3,'',29,1),(572,'2026-10-21 05:04:09.225921','258','frt (School)',3,'',29,1),(573,'2026-10-21 05:04:09.225948','154','kagoye (School)',3,'',29,1),(574,'2026-10-21 05:04:09.225975','523','kumekucha (School)',3,'',29,1),(575,'2026-10-21 05:04:09.226002','522','sefg (School)',3,'',29,1),(576,'2026-10-21 05:04:09.226029','3','cooking (School)',3,'',29,1),(577,'2026-10-21 05:04:09.226059','4','seba (District)',3,'',29,1),(578,'2026-10-21 05:04:09.226087','1','sss (School)',3,'',29,1),(579,'2026-10-21 05:04:09.226114','160','omukolo (District)',3,'',29,1),(580,'2026-10-21 05:04:38.986045','370','DAR ES SALAAM COMPETITION (School)',3,'',29,1),(581,'2026-10-21 05:05:15.741760','1027','S2000/0005/2026 (Student)',3,'',25,1),(582,'2026-10-21 05:05:15.741840','1026','S2000/0004/2026 (Student)',3,'',25,1),(583,'2026-10-21 05:05:15.741887','976','S1947/0001/2026 (Student)',3,'',25,1),(584,'2026-10-21 05:05:15.741927','975','iren@gmail.com (Sport Teacher)',3,'',25,1),(585,'2026-10-21 05:05:15.741964','924','lameckomgaiga@gmail.com (Talent Admin)',3,'',25,1),(586,'2026-10-21 05:05:15.742000','880','S.768/0002/2026 (Student)',3,'',25,1),(587,'2026-10-21 05:05:15.742117','879','S.768/0001/2026 (Student)',3,'',25,1),(588,'2026-10-21 05:05:15.742192','878','Bright@gmail.com (District Manager)',3,'',25,1),(589,'2026-10-21 05:09:36.801338','877','anesta@gmail.com (Sport Teacher)',3,'',25,1),(590,'2026-10-21 05:09:36.801403','876','s4000/0004/2026 (Student)',3,'',25,1),(591,'2026-10-21 05:09:36.801443','875','s4000/0003/2026 (Student)',3,'',25,1),(592,'2026-10-21 05:09:36.801479','874','s4000/0002/2026 (Student)',3,'',25,1),(593,'2026-10-21 05:09:36.801524','873','s4000/0001/2026 (Student)',3,'',25,1),(594,'2026-10-21 05:09:36.801560','827','S8700/0004/2026 (Student)',3,'',25,1),(595,'2026-10-21 05:09:36.801603','826','S8700/0003/2026 (Student)',3,'',25,1),(596,'2026-10-21 05:09:36.801634','825','S8700/0002/2026 (Student)',3,'',25,1),(597,'2026-10-21 05:09:36.801664','824','S8700/0001/2026 (Student)',3,'',25,1),(598,'2026-10-21 05:09:36.801694','823','anna@gmail.com (Sport Teacher)',3,'',25,1),(599,'2026-10-21 05:09:36.801725','822','pauline@gmail.com (District Manager)',3,'',25,1),(600,'2026-10-21 05:09:36.801755','772','kendrick (Sport Teacher)',3,'',25,1),(601,'2026-10-21 05:09:36.801785','771','Jira (District Manager)',3,'',25,1),(602,'2026-10-21 05:09:36.801816','723','S3500/0003/2026 (Student)',3,'',25,1),(603,'2026-10-21 05:09:36.801845','722','S3500/0002/2026 (Student)',3,'',25,1),(604,'2026-10-21 05:09:36.801874','721','S3500/0001/2026 (Student)',3,'',25,1),(605,'2026-10-21 05:09:36.801903','720','Rogers (Sport Teacher)',3,'',25,1),(606,'2026-10-21 05:09:36.801932','719','S2000/0003/2026 (Student)',3,'',25,1),(607,'2026-10-21 05:09:36.801962','718','S2000/0002/2026 (Student)',3,'',25,1),(608,'2026-10-21 05:09:36.801992','717','S2000/0001/2026 (Student)',3,'',25,1),(609,'2026-10-21 05:09:36.802021','716','doreen@gmail.com (Sport Teacher)',3,'',25,1),(610,'2026-10-21 05:09:36.802051','715','sikumbili@gmail.com (District Manager)',3,'',25,1),(611,'2026-10-21 05:09:36.802080','668','S1000/0003/2026 (Student)',3,'',25,1),(612,'2026-10-21 05:09:36.802110','667','S1000/0002/2026 (Student)',3,'',25,1),(613,'2026-10-21 05:09:36.802139','666','S1000/0001/2026 (Student)',3,'',25,1),(614,'2026-10-21 05:09:36.802169','665','mwakalambo (District Manager)',3,'',25,1),(615,'2026-10-21 05:09:36.802199','664','revo (Sport Teacher)',3,'',25,1),(616,'2026-10-21 05:09:36.802228','619','S0669/0002/2026 (Student)',3,'',25,1),(617,'2026-10-21 05:09:36.802258','618','S0669/0001/2026 (Student)',3,'',25,1),(618,'2026-10-21 05:09:36.802286','617','evance@gmail.com (District Manager)',3,'',25,1),(619,'2026-10-21 05:09:36.802316','616','elisha@gmail.com (Sport Teacher)',3,'',25,1),(620,'2026-10-21 05:09:36.802344','615','S0668/0007/2026 (Student)',3,'',25,1),(621,'2026-10-21 05:09:36.802374','614','S0668/0006/2026 (Student)',3,'',25,1),(622,'2026-10-21 05:09:36.802404','564','hyshwu@ (Sport Teacher)',3,'',25,1),(623,'2026-10-21 05:09:36.802433','527','p0655/0004/2026 (Student)',3,'',25,1),(624,'2026-10-21 05:09:36.802462','526','p0655/0003/2026 (Student)',3,'',25,1),(625,'2026-10-21 05:09:36.802492','525','p0655/0002/2026 (Student)',3,'',25,1),(626,'2026-10-21 05:09:36.802522','524','p0655/0001/2026 (Student)',3,'',25,1),(627,'2026-10-21 05:09:36.802551','523','mbalishimana@gmail.com (Sport Teacher)',3,'',25,1),(628,'2026-10-21 05:09:36.802580','522','agnes@gmail.com (Sport Teacher)',3,'',25,1),(629,'2026-10-21 05:09:36.802609','521','mchseba@gmail.com (District Manager)',3,'',25,1),(630,'2026-10-21 05:09:36.802638','519','S0668/0005/2026 (Student)',3,'',25,1),(631,'2026-10-21 05:09:36.802669','517','denis@gmail.com (District Manager)',3,'',25,1),(632,'2026-10-21 05:09:36.802700','516','s.0677/0005/2026 (Student)',3,'',25,1),(633,'2026-10-21 05:09:36.802729','515','s.0677/0004/2026 (Student)',3,'',25,1),(634,'2026-10-21 05:09:36.802972','514','s.0677/0003/2026 (Student)',3,'',25,1),(635,'2026-10-21 05:09:36.803071','513','s.0677/0002/2026 (Student)',3,'',25,1),(636,'2026-10-21 05:09:36.803151','512','s.0677/0001/2026 (Student)',3,'',25,1),(637,'2026-10-21 05:09:36.803195','511','jack@gmail.com (Sport Teacher)',3,'',25,1),(638,'2026-10-21 05:09:36.803236','464','p5677/0006/2026 (Student)',3,'',25,1),(639,'2026-10-21 05:09:36.803278','463','S0668/0002/2026 (Student)',3,'',25,1),(640,'2026-10-21 05:09:36.803319','460','Joe@gmail.com (Sport Teacher)',3,'',25,1),(641,'2026-10-21 05:09:36.803361','409','p5677/0005/2026 (Student)',3,'',25,1),(642,'2026-10-21 05:09:36.803402','358','Joe (Sport Teacher)',3,'',25,1),(643,'2026-10-21 05:09:36.803443','310','p5677/0003/2026 (Student)',3,'',25,1),(644,'2026-10-21 05:09:36.803484','309','pele@gmai.com (Student)',3,'',25,1),(645,'2026-10-21 05:09:36.803525','308','kale@gmail.com (District Manager)',3,'',25,1),(646,'2026-10-21 05:09:36.803566','256','mwesije@gmail.com (Sport Teacher)',3,'',25,1),(647,'2026-10-21 05:12:28.067664','666','Peramiho  Secondary School (S1947)',3,'',18,1),(648,'2026-10-21 05:12:28.067760','616','Rubwera Secondary School (P1500)',3,'',18,1),(649,'2026-10-21 05:12:28.067816','615','Karagwe Secondary School (S.768)',3,'',18,1),(650,'2026-10-21 05:12:28.067871','565','Bugene High School (S8700)',3,'',18,1),(651,'2026-10-21 05:12:28.067923','564','Nyaishozi High School (S5000)',3,'',18,1),(652,'2026-10-21 05:12:28.067976','513','Sega Secondary School (s4000)',3,'',18,1),(653,'2026-10-21 05:12:28.068028','463','Zanaki Secondary School (S3500)',3,'',18,1),(654,'2026-10-21 05:12:28.068079','462','Mambwe Secondary School (S3000)',3,'',18,1),(655,'2026-10-21 05:12:28.068129','411','Benjamini Primary School (p1000)',3,'',18,1),(656,'2026-10-21 05:12:28.068182','410','benjamin mkapa (S2500)',3,'',18,1),(657,'2026-10-21 05:12:28.068234','409','Azania sec school (S2000)',3,'',18,1),(658,'2026-10-21 05:12:28.068284','358','KIBITI SECONDARY SCHOOL (S1000)',3,'',18,1),(659,'2026-10-21 05:12:28.068334','307','rutunguru sc school (S0669)',3,'',18,1),(660,'2026-10-21 05:12:28.068386','258','rwensinga school (p0655)',3,'',18,1),(661,'2026-10-21 05:12:28.068435','257','nyakakoni school (s8977)',3,'',18,1),(662,'2026-10-21 05:12:28.068487','256','mambwe high school (s0999)',3,'',18,1),(663,'2026-10-21 05:12:28.068539','206','Mabibo secondary school (S2001)',3,'',18,1),(664,'2026-10-21 05:12:28.068590','205','Manzese secondary school (S0668)',3,'',18,1),(665,'2026-10-21 05:12:28.068638','103','Tosamaganga (S703)',3,'',18,1),(666,'2026-10-21 05:12:28.068689','54','kaisho (p5677)',3,'',18,1),(667,'2026-10-21 05:12:28.068739','52','nyaishoz (s.0677)',3,'',18,1),(668,'2026-10-21 05:12:28.068792','8','ST. MARY QUEEN OF THE APOSTLES SS (s0185)',3,'',18,1),(669,'2026-10-21 05:12:28.068843','7','ST. CAROLI SS (s0195)',3,'',18,1),(670,'2026-10-21 05:12:28.068892','6','MILLENIUM SS (s6040)',3,'',18,1),(671,'2026-10-21 05:12:28.068940','5','JUVENARY BUZINZA SS (s1823)',3,'',18,1),(672,'2026-10-21 05:12:28.068991','3','CHRIST THE KING NYANTAKUBWA (GIRLS) SS (s4965)',3,'',18,1),(673,'2026-10-21 06:06:14.675622','668','Results are out (School)',3,'',5,1),(674,'2026-10-21 06:06:14.675740','667','Results are out (School)',3,'',5,1),(675,'2026-10-21 06:06:14.675779','617','God is faithfull (District)',3,'',5,1),(676,'2026-10-21 06:06:14.675812','616','omkama (District)',3,'',5,1),(677,'2026-10-21 06:06:14.675852','361','umakini (School)',3,'',5,1),(678,'2026-10-21 06:06:14.675885','359','maticha tumeni matokeo chap (District)',3,'',5,1),(679,'2026-10-21 06:06:14.675917','309','ogududu (District)',3,'',5,1),(680,'2026-10-21 06:06:14.675947','308','mulisa (District)',3,'',5,1),(681,'2026-10-21 06:06:14.675978','256','Sports teachers meetings (District)',3,'',5,1),(682,'2026-10-21 06:06:14.676010','205','Landing on the moon next night boys (School)',3,'',5,1),(683,'2026-10-21 06:06:14.676042','1','how to play so well (District)',3,'',5,1),(684,'2026-10-21 06:28:50.539285','772','Makombo Sec (S8976)',3,'',18,1);
/*!40000 ALTER TABLE `django_admin_log` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `django_content_type`
--

DROP TABLE IF EXISTS `django_content_type`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `django_content_type` (
  `id` int NOT NULL AUTO_INCREMENT,
  `app_label` varchar(100) NOT NULL,
  `model` varchar(100) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `django_content_type_app_label_model_76bd3d3b_uniq` (`app_label`,`model`)
) ENGINE=InnoDB AUTO_INCREMENT=205 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `django_content_type`
--

LOCK TABLES `django_content_type` WRITE;
/*!40000 ALTER TABLE `django_content_type` DISABLE KEYS */;
INSERT INTO `django_content_type` VALUES (1,'admin','logentry'),(2,'auth','group'),(3,'auth','permission'),(29,'competitions','competition'),(30,'competitions','competitionjudge'),(31,'competitions','competitionparticipation'),(4,'contenttypes','contenttype'),(5,'core','announcement'),(6,'core','auditlog'),(7,'core','club'),(8,'core','clubtalent'),(9,'core','clubteacher'),(10,'core','country'),(103,'core','countryclub'),(11,'core','district'),(12,'core','evaluationcriterion'),(13,'core','evaluationscore'),(14,'core','message'),(15,'core','notification'),(16,'core','parent'),(17,'core','region'),(18,'core','school'),(104,'core','schoolclub'),(105,'core','schoolownershiptype'),(19,'core','studentclubmembership'),(20,'core','studenttalent'),(21,'core','submissionfeedback'),(22,'core','talent'),(106,'core','talentcategory'),(23,'core','talentevaluation'),(24,'core','talentsubmission'),(25,'core','user'),(26,'core','ward'),(27,'core','zone'),(154,'results','districtcompetitionsubmission'),(53,'results','result'),(54,'results','resultdetail'),(55,'results','resultpromotion'),(108,'results','schoolcompetitionsubmission'),(155,'results','zonecompetitionsubmission'),(52,'sessions','session'),(107,'students','educationlevel'),(28,'students','student');
/*!40000 ALTER TABLE `django_content_type` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `django_migrations`
--

DROP TABLE IF EXISTS `django_migrations`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `django_migrations` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `app` varchar(255) NOT NULL,
  `name` varchar(255) NOT NULL,
  `applied` datetime(6) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=613 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `django_migrations`
--

LOCK TABLES `django_migrations` WRITE;
/*!40000 ALTER TABLE `django_migrations` DISABLE KEYS */;
INSERT INTO `django_migrations` VALUES (1,'contenttypes','0001_initial','2026-08-22 22:17:32.326374'),(2,'contenttypes','0002_remove_content_type_name','2026-08-22 22:17:34.065996'),(3,'auth','0001_initial','2026-08-22 22:17:38.280559'),(4,'auth','0002_alter_permission_name_max_length','2026-08-22 22:17:39.226206'),(5,'auth','0003_alter_user_email_max_length','2026-08-22 22:17:39.408037'),(6,'auth','0004_alter_user_username_opts','2026-08-22 22:17:39.482688'),(7,'auth','0005_alter_user_last_login_null','2026-08-22 22:17:39.533846'),(8,'auth','0006_require_contenttypes_0002','2026-08-22 22:17:39.578936'),(9,'auth','0007_alter_validators_add_error_messages','2026-08-22 22:17:39.652151'),(10,'auth','0008_alter_user_username_max_length','2026-08-22 22:17:39.708411'),(11,'auth','0009_alter_user_last_name_max_length','2026-08-22 22:17:39.788195'),(12,'auth','0010_alter_group_name_max_length','2026-08-22 22:17:40.039028'),(13,'auth','0011_update_proxy_permissions','2026-08-22 22:17:40.091542'),(14,'auth','0012_alter_user_first_name_max_length','2026-08-22 22:17:40.170885'),(15,'core','0001_initial','2026-08-22 22:17:58.956188'),(16,'admin','0001_initial','2026-08-22 22:18:00.951586'),(17,'admin','0002_logentry_remove_auto_add','2026-08-22 22:18:01.025197'),(18,'admin','0003_logentry_add_action_flag_choices','2026-08-22 22:18:01.089996'),(19,'students','0001_initial','2026-08-22 22:18:03.167427'),(20,'competitions','0001_initial','2026-08-22 22:18:09.488753'),(21,'competitions','0002_alter_competition_id_and_more','2026-08-22 22:18:16.821538'),(22,'competitions','0003_competition_approved_at_competition_approved_by_and_more','2026-08-22 22:18:29.453341'),(23,'students','0002_alter_student_id','2026-08-22 22:18:32.491349'),(24,'core','0002_alter_user_role','2026-08-22 22:18:32.594841'),(25,'core','0003_alter_user_role','2026-08-22 22:18:32.657601'),(26,'core','0004_talent_announcement_studenttalent','2026-08-22 22:18:42.658672'),(27,'core','0005_alter_announcement_id_alter_country_id_and_more','2026-08-22 22:20:01.770810'),(28,'core','0006_user_student_and_student_role','2026-08-22 22:20:02.960427'),(29,'core','0007_parent_user_school_student_count_user_country_and_more','2026-08-22 22:20:43.191072'),(30,'core','0008_alter_user_role','2026-08-22 22:20:43.336190'),(31,'core','0009_talentevaluation_grade_alter_announcement_id_and_more','2026-08-22 22:47:27.259249'),(52,'results','0001_initial','2026-08-25 18:58:40.241046'),(53,'results','0002_alter_result_id_alter_resultdetail_id','2026-08-25 18:58:52.177058'),(54,'results','0003_result_approval_status_result_approved_at_and_more','2026-08-25 18:59:21.876718'),(55,'results','0004_result_score_alter_result_grade','2026-08-25 18:59:25.496088'),(56,'sessions','0001_initial','2026-08-25 18:59:26.859075'),(57,'students','0003_alter_student_id','2026-08-25 18:59:54.012656'),(103,'core','0010_school_is_approved_alter_school_ownership_type','2026-09-09 14:56:57.479548'),(104,'core','0011_schoolownershiptype_alter_school_ownership_type','2026-09-09 14:56:59.894298'),(105,'core','0012_remove_club_school_remove_club_talents_and_more','2026-09-09 14:57:21.018493'),(106,'core','0013_talentcategory_alter_talent_options_and_more','2026-09-09 14:57:34.957536'),(107,'core','0014_school_physical_address','2026-09-09 14:57:35.815517'),(108,'results','0005_remove_resultpromotion_unique_result_promotion_level_and_more','2026-09-09 14:57:45.424186'),(109,'results','0006_remove_resultpromotion_unique_detail_promotion_level_and_more','2026-09-09 14:57:59.371926'),(110,'results','0007_schoolcompetitionsubmission','2026-09-09 14:58:07.730961'),(111,'results','0008_resultpromotion_unique_detail_promotion_level','2026-09-09 14:58:08.800487'),(112,'students','0004_student_email_student_form_standard_student_phone','2026-09-09 14:58:29.016297'),(113,'students','0005_alter_student_student_id','2026-09-09 14:58:29.228827'),(114,'students','0006_remove_student_email_remove_student_form_standard_and_more','2026-09-09 14:58:48.082146'),(115,'students','0007_educationlevel_student_education_level_and_more','2026-09-09 14:58:57.977650'),(116,'students','0008_seed_education_levels','2026-09-09 14:58:58.291218'),(117,'students','0009_seed_tanzania_education_levels','2026-09-09 14:58:59.025542'),(118,'core','0015_user_phone','2026-09-09 18:28:17.411096'),(154,'students','0010_student_id_school_year_format','2026-09-22 18:52:34.419944'),(205,'results','0009_districtcompetitionsubmission','2026-09-30 19:32:59.875441'),(206,'results','0010_zonecompetitionsubmission','2026-09-30 20:02:04.342594'),(256,'core','0016_announcement_audience','2026-10-09 13:20:34.292780'),(257,'core','0017_active_membership_mysql_guard','2026-10-09 21:56:42.218447'),(258,'results','0011_resultdetail_promotion_status','2026-10-09 23:32:46.154231'),(259,'results','0012_resultpromotion_target_competition','2026-10-10 01:06:17.914630'),(307,'competitions','0004_competition_venue','2026-10-15 01:27:36.631901'),(358,'competitions','0005_competition_talent','2026-10-15 10:57:31.271529'),(409,'core','0018_user_created_by_alter_user_role','2026-10-15 13:01:21.596928'),(460,'core','0019_school_city_council_school_street_village_and_more','2026-10-16 03:48:46.887424'),(511,'core','0020_school_is_active','2026-10-20 17:18:07.310414'),(562,'core','0021_user_city_council_user_street_village','2026-10-23 08:47:06.079361');
/*!40000 ALTER TABLE `django_migrations` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `django_session`
--

DROP TABLE IF EXISTS `django_session`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `django_session` (
  `session_key` varchar(40) NOT NULL,
  `session_data` longtext NOT NULL,
  `expire_date` datetime(6) NOT NULL,
  PRIMARY KEY (`session_key`),
  KEY `django_session_expire_date_a5c62663` (`expire_date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `django_session`
--

LOCK TABLES `django_session` WRITE;
/*!40000 ALTER TABLE `django_session` DISABLE KEYS */;
INSERT INTO `django_session` VALUES ('53gnl2tdfe5h4zkw20nb6xcjfffvyeij','.eJxVjEEKwyAQAP-y5yKYNavm2HvfEFZXa9qiEJNT6d9LIIf2OjPMG2betzLvPa3zIjCBhssvCxyfqR5CHlzvTcVWt3UJ6kjUabu6NUmv69n-DQr3AhMkTUFzZouEUVLWloynUXJCEu98HpCdOG2CmDE7NFaPMiBaTyQhEny-7aw3wg:1wyyfE:r0Fu4C9rRfXlMzK8_S-aTC8AinCmxDwiwvipshuhfIg','2026-09-08 21:26:36.291524'),('6j3arp7vpaggfsuvwfonr3ouzmavwegk','.eJxVjMsOgjAQAP9lz6axZfvi6J1vaHa3xaIGEgon478bEg56nZnMGxLtW017K2uaMvSg4fLLmORZ5kPkB833Rckyb-vE6kjUaZsallxet7P9G1RqFXoY0XXRkVjJMXTi3eiMDxk9GhsD-64Yi3wNbJwj9IELouggxJqj9RY-X8sNNzM:1xC1lz:GkWJtI7DKy7NOmiOYvPSgecy2b5v87EUoF8JL88K65g','2026-10-14 21:23:31.529183'),('avq8755qk2xwyffmrx6c6omvb0jhtu4h','.eJxVjMsOgjAQAP9lz6axZfvi6J1vaHa3xaIGEgon478bEg56nZnMGxLtW017K2uaMvSg4fLLmORZ5kPkB833Rckyb-vE6kjUaZsallxet7P9G1RqFXoY0XXRkVjJMXTi3eiMDxk9GhsD-64Yi3wNbJwj9IELouggxJqj9RY-X8sNNzM:1xHIE7:uMnebOxp_4_LluxkV48nkHud631i1e-LsMrXZkG2s1I','2026-10-29 09:58:19.004351'),('pm6l33kk58ihsbxqj61pmyt26z6zdrus','.eJxVjMsOgjAQAP9lz6axZfvi6J1vaHa3xaIGEgon478bEg56nZnMGxLtW017K2uaMvSg4fLLmORZ5kPkB833Rckyb-vE6kjUaZsallxet7P9G1RqFXoY0XXRkVjJMXTi3eiMDxk9GhsD-64Yi3wNbJwj9IELouggxJqj9RY-X8sNNzM:1xHIE8:a0N83vENIQ3vgWF_Oyl5L3p9s1E3Vs2x3NSh6uTwep8','2026-10-29 09:58:20.055363');
/*!40000 ALTER TABLE `django_session` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `results_districtcompetitionsubmission`
--

DROP TABLE IF EXISTS `results_districtcompetitionsubmission`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `results_districtcompetitionsubmission` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `status` varchar(20) NOT NULL,
  `submitted_at` datetime(6) DEFAULT NULL,
  `competition_id` bigint NOT NULL,
  `district_id` bigint NOT NULL,
  `submitted_by_id` bigint DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `unique_district_competition_submission` (`district_id`,`competition_id`),
  KEY `results_districtcomp_competition_id_e05ec43b_fk_competiti` (`competition_id`),
  KEY `results_districtcomp_submitted_by_id_36acc579_fk_core_user` (`submitted_by_id`),
  CONSTRAINT `results_districtcomp_competition_id_e05ec43b_fk_competiti` FOREIGN KEY (`competition_id`) REFERENCES `competitions_competition` (`id`),
  CONSTRAINT `results_districtcomp_district_id_4049d7c9_fk_core_dist` FOREIGN KEY (`district_id`) REFERENCES `core_district` (`id`),
  CONSTRAINT `results_districtcomp_submitted_by_id_36acc579_fk_core_user` FOREIGN KEY (`submitted_by_id`) REFERENCES `core_user` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=307 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `results_districtcompetitionsubmission`
--

LOCK TABLES `results_districtcompetitionsubmission` WRITE;
/*!40000 ALTER TABLE `results_districtcompetitionsubmission` DISABLE KEYS */;
INSERT INTO `results_districtcompetitionsubmission` VALUES (206,'submitted','2026-10-21 06:58:28.699259',774,36,1077),(256,'submitted','2026-10-23 11:14:51.627858',820,36,1077);
/*!40000 ALTER TABLE `results_districtcompetitionsubmission` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `results_result`
--

DROP TABLE IF EXISTS `results_result`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `results_result` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `grade` varchar(3) DEFAULT NULL,
  `grade_points` decimal(4,2) DEFAULT NULL,
  `award` varchar(10) NOT NULL,
  `rank` int unsigned DEFAULT NULL,
  `venue` varchar(200) NOT NULL,
  `competition_date` date NOT NULL,
  `recorded_at` datetime(6) NOT NULL,
  `updated_at` datetime(6) NOT NULL,
  `participation_id` bigint NOT NULL,
  `approval_status` varchar(20) NOT NULL,
  `approved_at` datetime(6) DEFAULT NULL,
  `approved_by_id` bigint DEFAULT NULL,
  `score` decimal(5,2) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `participation_id` (`participation_id`),
  KEY `results_result_approved_by_id_92592f4f_fk_core_user_id` (`approved_by_id`),
  CONSTRAINT `results_result_approved_by_id_92592f4f_fk_core_user_id` FOREIGN KEY (`approved_by_id`) REFERENCES `core_user` (`id`),
  CONSTRAINT `results_result_participation_id_520b98cb_fk_competiti` FOREIGN KEY (`participation_id`) REFERENCES `competitions_competitionparticipation` (`id`),
  CONSTRAINT `results_result_chk_1` CHECK ((`rank` >= 0))
) ENGINE=InnoDB AUTO_INCREMENT=1025 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `results_result`
--

LOCK TABLES `results_result` WRITE;
/*!40000 ALTER TABLE `results_result` DISABLE KEYS */;
INSERT INTO `results_result` VALUES (923,'A',4.00,'none',NULL,'','2026-10-21','2026-10-21 05:58:54.748457','2026-10-21 05:58:54.748494',923,'pending',NULL,NULL,76.00),(924,'A+',4.00,'none',NULL,'','2026-10-21','2026-10-21 05:59:03.003268','2026-10-21 05:59:03.003315',925,'pending',NULL,NULL,98.00),(925,'C',2.00,'none',NULL,'','2026-10-21','2026-10-21 05:59:09.742795','2026-10-21 05:59:09.742827',924,'pending',NULL,NULL,43.00),(927,'A+',4.00,'none',NULL,'','2026-10-21','2026-10-21 06:22:32.433504','2026-10-21 06:22:32.433537',928,'pending',NULL,NULL,98.00),(928,'C',2.00,'none',NULL,'','2026-10-21','2026-10-21 06:22:41.815328','2026-10-21 06:22:41.815360',930,'pending',NULL,NULL,45.00),(929,'B+',3.30,'none',NULL,'','2026-10-21','2026-10-21 06:22:47.009991','2026-10-21 06:22:47.010039',927,'pending',NULL,NULL,65.00),(930,'A',4.00,'none',NULL,'','2026-10-21','2026-10-21 06:22:53.229551','2026-10-21 06:22:53.229597',929,'pending',NULL,NULL,82.00),(931,'B+',3.30,'none',NULL,'','2026-10-21','2026-10-21 06:39:40.489575','2026-10-21 06:39:40.489623',936,'pending',NULL,NULL,70.00),(932,'A',4.00,'none',NULL,'','2026-10-21','2026-10-21 06:39:48.577358','2026-10-21 06:39:48.577390',935,'pending',NULL,NULL,76.00),(933,'C',2.00,'none',NULL,'','2026-10-21','2026-10-21 06:39:55.156725','2026-10-21 06:39:55.156751',931,'pending',NULL,NULL,45.00),(934,'A',4.00,'none',NULL,'','2026-10-21','2026-10-21 06:40:00.448627','2026-10-21 06:40:00.448659',932,'pending',NULL,NULL,89.00),(935,'B+',3.30,'none',NULL,'','2026-10-21','2026-10-21 06:40:05.058943','2026-10-21 06:40:05.058967',933,'pending',NULL,NULL,65.00),(936,'A+',4.00,'none',NULL,'','2026-10-21','2026-10-21 06:40:11.546922','2026-10-21 06:40:11.546949',934,'pending',NULL,NULL,98.00),(937,'A',4.00,'none',NULL,'','2026-10-21','2026-10-21 06:43:30.470320','2026-10-21 06:43:30.470392',939,'pending',NULL,NULL,77.00),(938,'B',3.00,'none',NULL,'','2026-10-21','2026-10-21 06:43:35.156240','2026-10-21 06:43:35.156272',938,'pending',NULL,NULL,56.00),(939,'A',4.00,'none',NULL,'','2026-10-21','2026-10-21 06:43:40.913221','2026-10-21 06:43:40.913257',937,'pending',NULL,NULL,87.00),(940,NULL,NULL,'none',NULL,'','2026-10-21','2026-10-21 06:52:40.673407','2026-10-21 06:52:40.673436',940,'pending',NULL,NULL,NULL),(941,NULL,NULL,'none',NULL,'','2026-10-21','2026-10-21 06:52:40.704201','2026-10-21 06:52:40.704227',941,'pending',NULL,NULL,NULL),(942,NULL,NULL,'none',NULL,'','2026-10-21','2026-10-21 06:52:40.730722','2026-10-21 06:52:40.730748',942,'pending',NULL,NULL,NULL),(943,NULL,NULL,'none',NULL,'','2026-10-21','2026-10-21 06:52:40.770691','2026-10-21 06:52:40.770715',943,'pending',NULL,NULL,NULL),(944,NULL,NULL,'none',NULL,'','2026-10-21','2026-10-21 06:52:40.803418','2026-10-21 06:52:40.803443',944,'pending',NULL,NULL,NULL),(945,NULL,NULL,'none',NULL,'','2026-10-21','2026-10-21 06:52:40.832759','2026-10-21 06:52:40.832784',945,'pending',NULL,NULL,NULL),(946,NULL,NULL,'none',NULL,'','2026-10-21','2026-10-21 06:52:40.905077','2026-10-21 06:52:40.905102',946,'pending',NULL,NULL,NULL),(947,NULL,NULL,'none',NULL,'','2026-10-21','2026-10-21 06:52:41.152987','2026-10-21 06:52:41.153057',947,'pending',NULL,NULL,NULL),(974,'A',4.00,'none',NULL,'','2026-10-23','2026-10-23 11:12:30.817909','2026-10-23 11:12:30.817945',975,'pending',NULL,NULL,78.00),(975,'A',4.00,'none',NULL,'','2026-10-23','2026-10-23 11:12:38.501102','2026-10-23 11:12:38.501131',976,'pending',NULL,NULL,89.00),(976,'C',2.00,'none',NULL,'','2026-10-23','2026-10-23 11:12:41.781405','2026-10-23 11:12:41.781432',977,'pending',NULL,NULL,45.00),(977,'A+',4.00,'none',NULL,'','2026-10-23','2026-10-23 11:12:45.419774','2026-10-23 11:12:45.419804',974,'pending',NULL,NULL,99.00),(978,NULL,NULL,'none',NULL,'','2026-10-23','2026-10-23 11:14:23.319777','2026-10-23 11:14:23.319852',978,'pending',NULL,NULL,NULL),(979,NULL,NULL,'none',NULL,'','2026-10-23','2026-10-23 11:14:23.650498','2026-10-23 11:14:23.650559',979,'pending',NULL,NULL,NULL);
/*!40000 ALTER TABLE `results_result` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `results_resultdetail`
--

DROP TABLE IF EXISTS `results_resultdetail`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `results_resultdetail` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `raw_score` decimal(5,2) NOT NULL,
  `percentage_score` decimal(5,2) DEFAULT NULL,
  `notes` longtext NOT NULL,
  `recorded_at` datetime(6) NOT NULL,
  `result_id` bigint NOT NULL,
  `talent_id` bigint NOT NULL,
  `passed` tinyint(1) NOT NULL,
  `promoted_to` varchar(20) NOT NULL,
  `promotion_status` varchar(20) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `unique_result_detail_per_talent` (`result_id`,`talent_id`),
  KEY `results_resultdetail_talent_id_e9d05b6d_fk_core_studenttalent_id` (`talent_id`),
  CONSTRAINT `results_resultdetail_result_id_bf01ad9a_fk` FOREIGN KEY (`result_id`) REFERENCES `results_result` (`id`),
  CONSTRAINT `results_resultdetail_talent_id_e9d05b6d_fk_core_studenttalent_id` FOREIGN KEY (`talent_id`) REFERENCES `core_studenttalent` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=873 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `results_resultdetail`
--

LOCK TABLES `results_resultdetail` WRITE;
/*!40000 ALTER TABLE `results_resultdetail` DISABLE KEYS */;
INSERT INTO `results_resultdetail` VALUES (771,76.00,76.00,'','2026-10-21 05:58:54.967663',923,667,1,'','not_promoted'),(772,98.00,98.00,'','2026-10-21 05:59:03.205006',924,670,1,'district','promoted'),(773,43.00,43.00,'','2026-10-21 05:59:09.921960',925,668,0,'','not_promoted'),(775,98.00,98.00,'','2026-10-21 06:22:32.665537',927,674,1,'district','promoted'),(776,45.00,45.00,'','2026-10-21 06:22:42.032910',928,676,0,'','not_promoted'),(777,65.00,65.00,'','2026-10-21 06:22:47.229205',929,673,1,'district','promoted'),(778,82.00,82.00,'','2026-10-21 06:22:53.439551',930,675,1,'district','promoted'),(779,70.00,70.00,'','2026-10-21 06:39:40.692268',931,682,1,'','not_promoted'),(780,76.00,76.00,'','2026-10-21 06:39:48.786519',932,681,1,'','not_promoted'),(781,45.00,45.00,'','2026-10-21 06:39:55.454634',933,677,0,'','not_promoted'),(782,89.00,89.00,'','2026-10-21 06:40:00.628380',934,678,1,'district','promoted'),(783,65.00,65.00,'','2026-10-21 06:40:05.250223',935,679,1,'','not_promoted'),(784,98.00,98.00,'','2026-10-21 06:40:11.752514',936,680,1,'district','promoted'),(785,77.00,77.00,'','2026-10-21 06:43:30.761163',937,671,1,'district','promoted'),(786,56.00,56.00,'','2026-10-21 06:43:35.346403',938,669,1,'district','promoted'),(787,87.00,87.00,'','2026-10-21 06:43:41.103915',939,672,1,'district','promoted'),(788,87.00,87.00,'','2026-10-21 06:52:40.685273',940,674,1,'','not_promoted'),(789,67.00,67.00,'','2026-10-21 06:52:40.714973',941,673,1,'','not_promoted'),(790,90.00,90.00,'','2026-10-21 06:52:40.743872',942,675,1,'','not_promoted'),(791,99.00,99.00,'','2026-10-21 06:52:40.783421',943,678,1,'','not_promoted'),(792,98.00,98.00,'','2026-10-21 06:52:40.815031',944,680,1,'','not_promoted'),(793,0.00,NULL,'','2026-10-21 06:52:40.844510',945,671,0,'','not_promoted'),(794,0.00,NULL,'','2026-10-21 06:52:41.005304',946,669,0,'','not_promoted'),(795,0.00,NULL,'','2026-10-21 06:52:41.174072',947,672,0,'','not_promoted'),(822,78.00,78.00,'','2026-10-23 11:12:31.468944',974,677,1,'','not_promoted'),(823,89.00,89.00,'','2026-10-23 11:12:39.052996',975,678,1,'district','promoted'),(824,45.00,45.00,'','2026-10-23 11:12:42.138961',976,679,0,'','not_promoted'),(825,99.00,99.00,'','2026-10-23 11:12:46.139620',977,680,1,'district','promoted'),(826,93.00,93.00,'','2026-10-23 11:14:23.339549',978,678,1,'','pending'),(827,98.00,98.00,'','2026-10-23 11:14:23.699013',979,680,1,'','pending');
/*!40000 ALTER TABLE `results_resultdetail` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `results_resultpromotion`
--

DROP TABLE IF EXISTS `results_resultpromotion`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `results_resultpromotion` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `from_level` varchar(20) NOT NULL,
  `to_level` varchar(20) NOT NULL,
  `promoted_at` datetime(6) NOT NULL,
  `notes` longtext NOT NULL,
  `promoted_by_id` bigint NOT NULL,
  `result_id` bigint NOT NULL,
  `result_detail_id` bigint DEFAULT NULL,
  `target_competition_id` bigint DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `unique_detail_promotion_level` (`result_detail_id`,`to_level`),
  KEY `results_resultpromotion_promoted_by_id_30877e22_fk_core_user_id` (`promoted_by_id`),
  KEY `results_resultpromotion_result_id_9664ac01` (`result_id`),
  KEY `results_resultpromot_target_competition_i_2e5eefad_fk_competiti` (`target_competition_id`),
  CONSTRAINT `results_resultpromot_result_detail_id_940c0d24_fk_results_r` FOREIGN KEY (`result_detail_id`) REFERENCES `results_resultdetail` (`id`),
  CONSTRAINT `results_resultpromot_target_competition_i_2e5eefad_fk_competiti` FOREIGN KEY (`target_competition_id`) REFERENCES `competitions_competition` (`id`),
  CONSTRAINT `results_resultpromotion_promoted_by_id_30877e22_fk_core_user_id` FOREIGN KEY (`promoted_by_id`) REFERENCES `core_user` (`id`),
  CONSTRAINT `results_resultpromotion_result_id_9664ac01_fk_results_result_id` FOREIGN KEY (`result_id`) REFERENCES `results_result` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=568 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `results_resultpromotion`
--

LOCK TABLES `results_resultpromotion` WRITE;
/*!40000 ALTER TABLE `results_resultpromotion` DISABLE KEYS */;
INSERT INTO `results_resultpromotion` VALUES (466,'school','district','2026-10-21 06:11:00.764847','Promoted talent to district competition champions',1077,924,772,NULL),(467,'school','district','2026-10-21 06:52:40.688082','Promoted talent to district competition mabingwa',1077,927,775,774),(468,'school','district','2026-10-21 06:52:40.717453','Promoted talent to district competition mabingwa',1077,929,777,774),(469,'school','district','2026-10-21 06:52:40.746395','Promoted talent to district competition mabingwa',1077,930,778,774),(470,'school','district','2026-10-21 06:52:40.786082','Promoted talent to district competition mabingwa',1077,934,782,774),(471,'school','district','2026-10-21 06:52:40.817593','Promoted talent to district competition mabingwa',1077,936,784,774),(472,'school','district','2026-10-21 06:52:40.847237','Promoted talent to district competition mabingwa',1077,937,785,774),(473,'school','district','2026-10-21 06:52:41.007752','Promoted talent to district competition mabingwa',1077,938,786,774),(474,'school','district','2026-10-21 06:52:41.178404','Promoted talent to district competition mabingwa',1077,939,787,774),(517,'school','district','2026-10-23 11:14:23.342196','Promoted talent to district competition test',1077,975,823,820),(518,'school','district','2026-10-23 11:14:23.734225','Promoted talent to district competition test',1077,977,825,820);
/*!40000 ALTER TABLE `results_resultpromotion` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `results_schoolcompetitionsubmission`
--

DROP TABLE IF EXISTS `results_schoolcompetitionsubmission`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `results_schoolcompetitionsubmission` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `status` varchar(20) NOT NULL,
  `submitted_at` datetime(6) DEFAULT NULL,
  `approved_at` datetime(6) DEFAULT NULL,
  `feedback` longtext NOT NULL,
  `approved_by_id` bigint DEFAULT NULL,
  `competition_id` bigint NOT NULL,
  `school_id` bigint NOT NULL,
  `submitted_by_id` bigint DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `unique_school_competition_submission` (`school_id`,`competition_id`),
  KEY `results_schoolcompet_approved_by_id_0baeb357_fk_core_user` (`approved_by_id`),
  KEY `results_schoolcompet_competition_id_e46fbf34_fk_competiti` (`competition_id`),
  KEY `results_schoolcompet_submitted_by_id_fbb2cb2a_fk_core_user` (`submitted_by_id`),
  CONSTRAINT `results_schoolcompet_approved_by_id_0baeb357_fk_core_user` FOREIGN KEY (`approved_by_id`) REFERENCES `core_user` (`id`),
  CONSTRAINT `results_schoolcompet_competition_id_e46fbf34_fk_competiti` FOREIGN KEY (`competition_id`) REFERENCES `competitions_competition` (`id`),
  CONSTRAINT `results_schoolcompet_school_id_bc3a72d2_fk_core_scho` FOREIGN KEY (`school_id`) REFERENCES `core_school` (`id`),
  CONSTRAINT `results_schoolcompet_submitted_by_id_fbb2cb2a_fk_core_user` FOREIGN KEY (`submitted_by_id`) REFERENCES `core_user` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=818 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `results_schoolcompetitionsubmission`
--

LOCK TABLES `results_schoolcompetitionsubmission` WRITE;
/*!40000 ALTER TABLE `results_schoolcompetitionsubmission` DISABLE KEYS */;
INSERT INTO `results_schoolcompetitionsubmission` VALUES (716,'submitted','2026-10-21 05:59:15.504721',NULL,'',NULL,768,770,1080),(717,'submitted','2026-10-21 06:23:01.694546',NULL,'',NULL,771,769,1078),(718,'submitted','2026-10-21 06:40:19.806731',NULL,'',NULL,772,771,1079),(719,'submitted','2026-10-21 06:43:44.957163',NULL,'',NULL,773,770,1080),(767,'submitted','2026-10-23 11:12:49.193497',NULL,'',NULL,819,771,1079);
/*!40000 ALTER TABLE `results_schoolcompetitionsubmission` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `results_zonecompetitionsubmission`
--

DROP TABLE IF EXISTS `results_zonecompetitionsubmission`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `results_zonecompetitionsubmission` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `status` varchar(20) NOT NULL,
  `submitted_at` datetime(6) DEFAULT NULL,
  `competition_id` bigint NOT NULL,
  `submitted_by_id` bigint DEFAULT NULL,
  `zone_id` bigint NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `unique_zone_competition_submission` (`zone_id`,`competition_id`),
  KEY `results_zonecompetit_competition_id_8c87f8d5_fk_competiti` (`competition_id`),
  KEY `results_zonecompetit_submitted_by_id_4cf3cb47_fk_core_user` (`submitted_by_id`),
  CONSTRAINT `results_zonecompetit_competition_id_8c87f8d5_fk_competiti` FOREIGN KEY (`competition_id`) REFERENCES `competitions_competition` (`id`),
  CONSTRAINT `results_zonecompetit_submitted_by_id_4cf3cb47_fk_core_user` FOREIGN KEY (`submitted_by_id`) REFERENCES `core_user` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `results_zonecompetitionsubmission`
--

LOCK TABLES `results_zonecompetitionsubmission` WRITE;
/*!40000 ALTER TABLE `results_zonecompetitionsubmission` DISABLE KEYS */;
/*!40000 ALTER TABLE `results_zonecompetitionsubmission` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `students_educationlevel`
--

DROP TABLE IF EXISTS `students_educationlevel`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `students_educationlevel` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `name` varchar(50) NOT NULL,
  `code` varchar(20) NOT NULL,
  `level_type` varchar(20) NOT NULL,
  `order` int unsigned NOT NULL,
  `is_active` tinyint(1) NOT NULL,
  `country_id` bigint NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `unique_education_level_per_country` (`country_id`,`code`),
  CONSTRAINT `students_educationlevel_country_id_664f77f2_fk_core_country_id` FOREIGN KEY (`country_id`) REFERENCES `core_country` (`id`),
  CONSTRAINT `students_educationlevel_chk_1` CHECK ((`order` >= 0))
) ENGINE=InnoDB AUTO_INCREMENT=52 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `students_educationlevel`
--

LOCK TABLES `students_educationlevel` WRITE;
/*!40000 ALTER TABLE `students_educationlevel` DISABLE KEYS */;
INSERT INTO `students_educationlevel` VALUES (1,'Standard 1','STD_1','standard',1,1,1),(2,'Standard 2','STD_2','standard',2,1,1),(3,'Standard 3','STD_3','standard',3,1,1),(4,'Standard 4','STD_4','standard',4,1,1),(5,'Standard 5','STD_5','standard',5,1,1),(6,'Standard 6','STD_6','standard',6,1,1),(7,'Standard 7','STD_7','standard',7,1,1),(8,'Form I','FORM_I','form',1,1,1),(9,'Form II','FORM_II','form',2,1,1),(10,'Form III','FORM_III','form',3,1,1),(11,'Form IV','FORM_IV','form',4,1,1),(12,'Form V','FORM_V','form',5,1,1),(13,'Form VI','FORM_VI','form',6,1,1);
/*!40000 ALTER TABLE `students_educationlevel` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `students_student`
--

DROP TABLE IF EXISTS `students_student`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `students_student` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `first_name` varchar(100) NOT NULL,
  `last_name` varchar(100) NOT NULL,
  `gender` varchar(1) NOT NULL,
  `date_of_birth` date DEFAULT NULL,
  `student_id` varchar(50) DEFAULT NULL,
  `parent_id` bigint DEFAULT NULL,
  `school_id` bigint NOT NULL,
  `education_level_id` bigint DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `student_id` (`student_id`),
  KEY `students_student_parent_id_c1069729_fk` (`parent_id`),
  KEY `students_student_school_id_be4a7ab9_fk` (`school_id`),
  KEY `students_student_education_level_id_4afb922c_fk_students_` (`education_level_id`),
  CONSTRAINT `students_student_education_level_id_4afb922c_fk_students_` FOREIGN KEY (`education_level_id`) REFERENCES `students_educationlevel` (`id`),
  CONSTRAINT `students_student_parent_id_c1069729_fk` FOREIGN KEY (`parent_id`) REFERENCES `core_parent` (`id`),
  CONSTRAINT `students_student_school_id_be4a7ab9_fk` FOREIGN KEY (`school_id`) REFERENCES `core_school` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=718 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `students_student`
--

LOCK TABLES `students_student` WRITE;
/*!40000 ALTER TABLE `students_student` DISABLE KEYS */;
INSERT INTO `students_student` VALUES (667,'Anod','Abel','M','2026-10-07','S.0778/0001/2026',NULL,770,10),(668,'Daniel','Yohana','M','2026-10-08','S.0778/0002/2026',NULL,770,10),(669,'Joshua','Joseph','M','2026-10-15','S.0778/0003/2026',NULL,770,9),(670,'Isack','Seba','M','2026-10-08','S.0778/0004/2026',NULL,770,10),(671,'Raina','Abela','F','2026-10-15','S.0778/0005/2026',NULL,770,9),(672,'salome','salvatory','F','2026-10-08','S.0778/0006/2026',NULL,770,9),(673,'kamuhabwa','james','M','2026-10-15','S0667/0001/2026',NULL,769,11),(674,'philipo','Bilimbasa','M','2026-10-15','S0667/0002/2026',NULL,769,13),(675,'venitha','theobard','M','2026-10-14','S0667/0003/2026',NULL,769,11),(676,'delisia','fortunatus','F','2026-10-15','S0667/0004/2026',NULL,769,11),(677,'joshua','kanoni','M','2026-10-14','S.342/0001/2026',NULL,771,13),(678,'elinazi','pesa','M','2026-10-29','S.342/0002/2026',NULL,771,13),(679,'erick','said','M','2026-10-14','S.342/0003/2026',NULL,771,13),(680,'Isack','seba','M','2026-09-30','S.342/0004/2026',NULL,771,12),(681,'yusuph','finias','M','2026-10-14','S.342/0005/2026',NULL,771,13),(682,'makoye','evarist','M','2026-09-27','S.342/0006/2026',NULL,771,12);
/*!40000 ALTER TABLE `students_student` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping events for database 'talents'
--

--
-- Dumping routines for database 'talents'
--
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2026-11-04  8:00:17
