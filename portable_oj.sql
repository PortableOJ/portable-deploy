/*
 Navicat Premium Data Transfer

 Source Server         : Localhost_MySQL
 Source Server Type    : MySQL
 Source Server Version : 80028
 Source Host           : localhost:3306
 Source Schema         : portable_oj

 Target Server Type    : MySQL
 Target Server Version : 80028
 File Encoding         : 65001

 Date: 01/03/2022 16:31:37
*/

SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

-- ----------------------------
-- Table structure for batch
-- ----------------------------
DROP TABLE IF EXISTS `batch`;
CREATE TABLE `batch` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT COMMENT '主键 ID',
  `owner` bigint NOT NULL COMMENT '拥有者 ID',
  `contest_id` bigint DEFAULT NULL COMMENT '绑定至的比赛 ID',
  `prefix` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '用户名前缀',
  `count` int NOT NULL COMMENT '总数量',
  `ip_lock` tinyint(1) NOT NULL COMMENT '是否锁定 IP',
  `status` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '状态',
  PRIMARY KEY (`id`),
  KEY `idx_owner` (`owner`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- ----------------------------
-- Table structure for contest
-- ----------------------------
DROP TABLE IF EXISTS `contest`;
CREATE TABLE `contest` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '比赛 id',
  `data_id` varchar(32) DEFAULT NULL COMMENT '比赛数据 id',
  `owner` bigint DEFAULT NULL COMMENT '比赛拥有者',
  `title` varchar(255) DEFAULT NULL COMMENT '比赛标题',
  `start_time` datetime DEFAULT NULL COMMENT '比赛开始时间',
  `duration` int DEFAULT NULL COMMENT '比赛持续时间（分钟）',
  `access_type` varchar(64) DEFAULT NULL COMMENT '比赛的访问权限类型',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='比赛信息';

-- ----------------------------
-- Table structure for problem
-- ----------------------------
DROP TABLE IF EXISTS `problem`;
CREATE TABLE `problem` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '问题数据库主键id',
  `data_id` varchar(255) DEFAULT NULL COMMENT '问题内容的主键id',
  `title` varchar(255) NOT NULL COMMENT '问题标题',
  `status_type` varchar(64) NOT NULL COMMENT '当前状态',
  `access_type` varchar(64) DEFAULT NULL COMMENT '访问权限',
  `submission_count` int NOT NULL COMMENT '提交的总数量',
  `accept_count` int NOT NULL COMMENT '通过的总数量',
  `owner` bigint DEFAULT NULL COMMENT '拥有者',
  PRIMARY KEY (`id`),
  KEY `idx_access_type_owner` (`access_type`,`owner`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- ----------------------------
-- Table structure for solution
-- ----------------------------
DROP TABLE IF EXISTS `solution`;
CREATE TABLE `solution` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '提交的主键 id',
  `data_id` varchar(32) DEFAULT NULL COMMENT '题目数据主键',
  `submit_time` timestamp NOT NULL COMMENT '提交时间',
  `user_id` bigint NOT NULL COMMENT '提交的用户id',
  `problem_id` bigint NOT NULL COMMENT '提交对应的问题id',
  `contest_id` bigint DEFAULT NULL COMMENT '提交至的比赛id，为 null 时则为提交至公共题库',
  `language_type` varchar(64) NOT NULL COMMENT '提交的语言类型',
  `status` varchar(64) NOT NULL COMMENT '提交的当前状态',
  `solution_type` varchar(64) DEFAULT NULL COMMENT '提交类型',
  `time_cost` int DEFAULT NULL COMMENT '提交的耗时，非 Accept 的则可能为 null',
  `memory_cost` int DEFAULT NULL COMMENT '提交的内存消耗，非 Accept 的则可能为 null',
  PRIMARY KEY (`id`),
  KEY `idx_solution_type_user_id` (`solution_type`,`user_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- ----------------------------
-- Table structure for user
-- ----------------------------
DROP TABLE IF EXISTS `user`;
CREATE TABLE `user` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '数据库主键',
  `data_id` varchar(255) DEFAULT NULL COMMENT '用户数据主键',
  `handle` varchar(255) NOT NULL COMMENT '用户名',
  `password` varchar(255) NOT NULL COMMENT '用户密码',
  `type` varchar(64) NOT NULL COMMENT '用户类型',
  PRIMARY KEY (`id`),
  UNIQUE KEY `account_handle_uindex` (`handle`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='用户登陆信息表';

SET FOREIGN_KEY_CHECKS = 1;
