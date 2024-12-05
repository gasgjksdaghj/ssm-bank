/*
 Navicat Premium Data Transfer

 Source Server         : localhost
 Source Server Type    : MySQL
 Source Server Version : 80031
 Source Host           : localhost:3306
 Source Schema         : ssm-bank

 Target Server Type    : MySQL
 Target Server Version : 80031
 File Encoding         : 65001

 Date: 05/12/2024 15:58:51
*/

SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

-- ----------------------------
-- Table structure for sys_loan_record
-- ----------------------------
DROP TABLE IF EXISTS `sys_loan_record`;
CREATE TABLE `sys_loan_record`  (
  `id` int NOT NULL AUTO_INCREMENT COMMENT 'id',
  `user_id` int NOT NULL COMMENT '用户ID',
  `loan_amount` decimal(10, 2) NOT NULL COMMENT '贷款金额',
  `interest_rate` decimal(5, 2) NOT NULL COMMENT '利率',
  `loan_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '贷款时间',
  `repayment_time` timestamp NULL DEFAULT NULL COMMENT '还款时间',
  `status` tinyint(1) NULL DEFAULT 0 COMMENT '贷款状态：0未还，1已还',
  `remark` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '备注',
  `bank_name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '银行名称',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_user_id`(`user_id` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of sys_loan_record
-- ----------------------------
INSERT INTO `sys_loan_record` VALUES (8, 1, 10000.00, 0.05, '2024-11-26 00:00:00', '2024-12-05 07:48:02', 1, '1', '中国银行');
INSERT INTO `sys_loan_record` VALUES (9, 1, 10000.00, 0.05, '2024-12-05 15:50:37', '2024-12-05 07:51:42', 1, 'cnmsb', '中国银行');
INSERT INTO `sys_loan_record` VALUES (10, 1, 200000.00, 0.06, '2024-12-05 15:51:52', NULL, 0, '111', '工商银行');

-- ----------------------------
-- Table structure for sys_role
-- ----------------------------
DROP TABLE IF EXISTS `sys_role`;
CREATE TABLE `sys_role`  (
  `id` int NOT NULL AUTO_INCREMENT COMMENT 'id',
  `name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '名称',
  `description` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '描述',
  `flag` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '唯一标识',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 7 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of sys_role
-- ----------------------------
INSERT INTO `sys_role` VALUES (1, '管理员', '吊打一切', 'admin');
INSERT INTO `sys_role` VALUES (2, '用户', '菜鸡', 'user');

-- ----------------------------
-- Table structure for sys_transaction_record
-- ----------------------------
DROP TABLE IF EXISTS `sys_transaction_record`;
CREATE TABLE `sys_transaction_record`  (
  `id` int NOT NULL AUTO_INCREMENT COMMENT 'id',
  `user_id` int NOT NULL COMMENT '用户ID',
  `transaction_type` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '交易类型：存款、取款、转账',
  `amount` decimal(10, 2) NOT NULL COMMENT '交易金额',
  `transaction_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '交易时间',
  `remark` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '备注',
  `target_user_id` int NULL DEFAULT NULL COMMENT '目标用户ID（仅用于转账）',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_user_id`(`user_id` ASC) USING BTREE,
  INDEX `idx_target_user_id`(`target_user_id` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of sys_transaction_record
-- ----------------------------

-- ----------------------------
-- Table structure for sys_user
-- ----------------------------
DROP TABLE IF EXISTS `sys_user`;
CREATE TABLE `sys_user`  (
  `id` int NOT NULL AUTO_INCREMENT COMMENT 'id',
  `username` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '用户名',
  `password` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '密码',
  `nickname` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '昵称',
  `email` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '邮箱',
  `phone` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '电话',
  `address` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '地址',
  `create_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` timestamp NULL DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `avatar_url` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '头像',
  `role` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT 'user' COMMENT '角色',
  `status` tinyint(1) NULL DEFAULT 1 COMMENT '启用状态：1启用，0禁用',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 42 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of sys_user
-- ----------------------------
INSERT INTO `sys_user` VALUES (1, 'admin', '$2a$10$jYATUwtSpZt/IAsQv4M7GONGsKIOBrkdO0sxNZQCp/Zqlo3gE.0DG', '宝子', '234404.62', '15078012222', '北京市', '2024-10-17 11:10:57', '2024-12-05 15:57:53', 'http://localhost:8080/files/20241205/d86e406c7af44e5aae52902f560253ea.gif', 'admin', 1);
INSERT INTO `sys_user` VALUES (44, 'test2', '$2a$10$ZtrAFYK7aK0QWAQDbu2AMuBSzGO1wpdM9lhRdpRHH8.Z7X4jXLtHW', 'cnmsb测试', '1344', NULL, NULL, '2024-12-05 12:30:15', '2024-12-05 15:53:27', 'http://localhost:8080/files/20241205/afe5881105044fac9761d5f84b704b61.gif', 'user', 1);

SET FOREIGN_KEY_CHECKS = 1;
