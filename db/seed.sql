/*
 Navicat Premium Dump SQL

 Source Server         : mysql
 Source Server Type    : MySQL
 Source Server Version : 80044 (8.0.44)
 Source Host           : localhost:3306
 Source Schema         : swapcampus

 Target Server Type    : MySQL
 Target Server Version : 80044 (8.0.44)
 File Encoding         : 65001

 Date: 12/06/2026 15:54:55
*/

SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

-- ----------------------------
-- Table structure for category
-- ----------------------------
DROP TABLE IF EXISTS `category`;
CREATE TABLE `category`  (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '分类ID',
  `name` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '分类名称',
  `icon` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '分类图标',
  `sort_order` int NOT NULL DEFAULT 0 COMMENT '排序',
  `status` tinyint NOT NULL DEFAULT 1 COMMENT '状态: 0禁用, 1启用',
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 8 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '商品分类表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of category
-- ----------------------------
INSERT INTO `category` VALUES (1, '教材教辅', 'book', 1, 1, '2026-06-11 21:05:31');
INSERT INTO `category` VALUES (2, '电子数码', 'device', 2, 1, '2026-06-11 21:05:31');
INSERT INTO `category` VALUES (3, '生活用品', 'daily', 3, 1, '2026-06-11 21:05:31');
INSERT INTO `category` VALUES (4, '运动户外', 'sport', 4, 1, '2026-06-11 21:05:31');
INSERT INTO `category` VALUES (5, '服饰美妆', 'fashion', 5, 1, '2026-06-11 21:05:31');
INSERT INTO `category` VALUES (6, '图书音像', 'music', 6, 1, '2026-06-11 21:05:31');
INSERT INTO `category` VALUES (7, '其他闲置', 'other', 7, 1, '2026-06-11 21:05:31');

-- ----------------------------
-- Table structure for favorite
-- ----------------------------
DROP TABLE IF EXISTS `favorite`;
CREATE TABLE `favorite`  (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `user_id` bigint NOT NULL,
  `goods_uuid` varchar(36) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `uk_user_goods`(`user_id` ASC, `goods_uuid` ASC) USING BTREE,
  INDEX `goods_uuid`(`goods_uuid` ASC) USING BTREE,
  CONSTRAINT `favorite_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `user` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT `favorite_ibfk_2` FOREIGN KEY (`goods_uuid`) REFERENCES `goods` (`uuid`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 159 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '收藏表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of favorite
-- ----------------------------
INSERT INTO `favorite` VALUES (1, 2, 'goods-0002', '2026-03-14 05:02:22');
INSERT INTO `favorite` VALUES (2, 2, 'goods-0009', '2026-03-14 10:02:22');
INSERT INTO `favorite` VALUES (3, 2, 'goods-0016', '2026-03-14 15:02:22');
INSERT INTO `favorite` VALUES (4, 3, 'goods-0001', '2026-03-14 20:02:22');
INSERT INTO `favorite` VALUES (5, 3, 'goods-0014', '2026-03-15 01:02:22');
INSERT INTO `favorite` VALUES (6, 3, 'goods-0020', '2026-03-15 06:02:22');
INSERT INTO `favorite` VALUES (7, 4, 'goods-0005', '2026-03-15 11:02:22');
INSERT INTO `favorite` VALUES (8, 4, 'goods-0019', '2026-03-15 16:02:22');
INSERT INTO `favorite` VALUES (9, 4, 'goods-0033', '2026-03-15 21:02:22');
INSERT INTO `favorite` VALUES (10, 5, 'goods-0008', '2026-03-16 02:02:22');
INSERT INTO `favorite` VALUES (11, 5, 'goods-0022', '2026-03-16 07:02:22');
INSERT INTO `favorite` VALUES (12, 5, 'goods-0041', '2026-03-16 12:02:22');
INSERT INTO `favorite` VALUES (13, 6, 'goods-0010', '2026-03-16 17:02:22');
INSERT INTO `favorite` VALUES (14, 6, 'goods-0029', '2026-03-16 22:02:22');
INSERT INTO `favorite` VALUES (15, 6, 'goods-0050', '2026-03-17 03:02:22');
INSERT INTO `favorite` VALUES (16, 7, 'goods-0012', '2026-03-17 08:02:22');
INSERT INTO `favorite` VALUES (17, 7, 'goods-0032', '2026-03-17 13:02:22');
INSERT INTO `favorite` VALUES (18, 7, 'goods-0065', '2026-03-17 18:02:22');
INSERT INTO `favorite` VALUES (19, 8, 'goods-0004', '2026-03-17 23:02:22');
INSERT INTO `favorite` VALUES (20, 8, 'goods-0025', '2026-03-18 04:02:22');
INSERT INTO `favorite` VALUES (21, 8, 'goods-0081', '2026-03-18 09:02:22');
INSERT INTO `favorite` VALUES (22, 9, 'goods-0006', '2026-03-18 14:02:22');
INSERT INTO `favorite` VALUES (23, 9, 'goods-0027', '2026-03-18 19:02:22');
INSERT INTO `favorite` VALUES (24, 9, 'goods-0092', '2026-03-19 00:02:22');
INSERT INTO `favorite` VALUES (25, 10, 'goods-0007', '2026-03-19 05:02:22');
INSERT INTO `favorite` VALUES (26, 10, 'goods-0037', '2026-03-19 10:02:22');
INSERT INTO `favorite` VALUES (27, 10, 'goods-0100', '2026-03-19 15:02:22');
INSERT INTO `favorite` VALUES (28, 11, 'goods-0018', '2026-03-19 20:02:22');
INSERT INTO `favorite` VALUES (29, 11, 'goods-0048', '2026-03-20 01:02:22');
INSERT INTO `favorite` VALUES (30, 11, 'goods-0141', '2026-03-20 06:02:22');
INSERT INTO `favorite` VALUES (31, 15, 'goods-0012', '2026-03-20 11:02:22');
INSERT INTO `favorite` VALUES (32, 28, 'goods-0023', '2026-03-20 16:02:22');
INSERT INTO `favorite` VALUES (33, 41, 'goods-0034', '2026-03-20 21:02:22');
INSERT INTO `favorite` VALUES (34, 54, 'goods-0045', '2026-03-21 02:02:22');
INSERT INTO `favorite` VALUES (35, 67, 'goods-0056', '2026-03-21 07:02:22');
INSERT INTO `favorite` VALUES (36, 80, 'goods-0067', '2026-03-21 12:02:22');
INSERT INTO `favorite` VALUES (37, 93, 'goods-0078', '2026-03-21 17:02:22');
INSERT INTO `favorite` VALUES (38, 7, 'goods-0089', '2026-03-21 22:02:22');
INSERT INTO `favorite` VALUES (39, 20, 'goods-0100', '2026-03-22 03:02:22');
INSERT INTO `favorite` VALUES (40, 33, 'goods-0111', '2026-03-22 08:02:22');
INSERT INTO `favorite` VALUES (41, 46, 'goods-0122', '2026-03-22 13:02:22');
INSERT INTO `favorite` VALUES (42, 59, 'goods-0133', '2026-03-22 18:02:22');
INSERT INTO `favorite` VALUES (43, 72, 'goods-0144', '2026-03-22 23:02:22');
INSERT INTO `favorite` VALUES (44, 85, 'goods-0155', '2026-03-23 04:02:22');
INSERT INTO `favorite` VALUES (45, 98, 'goods-0166', '2026-03-23 09:02:22');
INSERT INTO `favorite` VALUES (46, 12, 'goods-0177', '2026-03-23 14:02:22');
INSERT INTO `favorite` VALUES (47, 25, 'goods-0188', '2026-03-23 19:02:22');
INSERT INTO `favorite` VALUES (48, 38, 'goods-0199', '2026-03-24 00:02:22');
INSERT INTO `favorite` VALUES (49, 51, 'goods-0010', '2026-03-24 05:02:22');
INSERT INTO `favorite` VALUES (50, 64, 'goods-0021', '2026-03-24 10:02:22');
INSERT INTO `favorite` VALUES (51, 77, 'goods-0032', '2026-03-24 15:02:22');
INSERT INTO `favorite` VALUES (52, 90, 'goods-0043', '2026-03-24 20:02:22');
INSERT INTO `favorite` VALUES (53, 4, 'goods-0054', '2026-03-25 01:02:22');
INSERT INTO `favorite` VALUES (54, 17, 'goods-0065', '2026-03-25 06:02:22');
INSERT INTO `favorite` VALUES (55, 30, 'goods-0076', '2026-03-25 11:02:22');
INSERT INTO `favorite` VALUES (56, 43, 'goods-0087', '2026-03-25 16:02:22');
INSERT INTO `favorite` VALUES (57, 56, 'goods-0098', '2026-03-25 21:02:22');
INSERT INTO `favorite` VALUES (58, 69, 'goods-0109', '2026-03-26 02:02:22');
INSERT INTO `favorite` VALUES (59, 82, 'goods-0120', '2026-03-26 07:02:22');
INSERT INTO `favorite` VALUES (60, 95, 'goods-0131', '2026-03-26 12:02:22');
INSERT INTO `favorite` VALUES (61, 9, 'goods-0142', '2026-03-26 17:02:22');
INSERT INTO `favorite` VALUES (62, 22, 'goods-0153', '2026-03-26 22:02:22');
INSERT INTO `favorite` VALUES (63, 35, 'goods-0164', '2026-03-27 03:02:22');
INSERT INTO `favorite` VALUES (64, 48, 'goods-0175', '2026-03-27 08:02:22');
INSERT INTO `favorite` VALUES (65, 61, 'goods-0186', '2026-03-27 13:02:22');
INSERT INTO `favorite` VALUES (66, 74, 'goods-0197', '2026-03-27 18:02:22');
INSERT INTO `favorite` VALUES (67, 87, 'goods-0008', '2026-03-27 23:02:22');
INSERT INTO `favorite` VALUES (68, 100, 'goods-0019', '2026-03-28 04:02:22');
INSERT INTO `favorite` VALUES (69, 15, 'goods-0030', '2026-03-28 09:02:22');
INSERT INTO `favorite` VALUES (70, 27, 'goods-0041', '2026-03-28 14:02:22');
INSERT INTO `favorite` VALUES (71, 40, 'goods-0052', '2026-03-28 19:02:22');
INSERT INTO `favorite` VALUES (72, 53, 'goods-0063', '2026-03-29 00:02:22');
INSERT INTO `favorite` VALUES (73, 66, 'goods-0074', '2026-03-29 05:02:22');
INSERT INTO `favorite` VALUES (74, 79, 'goods-0085', '2026-03-29 10:02:22');
INSERT INTO `favorite` VALUES (75, 92, 'goods-0096', '2026-03-29 15:02:22');
INSERT INTO `favorite` VALUES (76, 6, 'goods-0107', '2026-03-29 20:02:22');
INSERT INTO `favorite` VALUES (77, 19, 'goods-0118', '2026-03-30 01:02:22');
INSERT INTO `favorite` VALUES (78, 32, 'goods-0129', '2026-03-30 06:02:22');
INSERT INTO `favorite` VALUES (79, 45, 'goods-0140', '2026-03-30 11:02:22');
INSERT INTO `favorite` VALUES (80, 58, 'goods-0151', '2026-03-30 16:02:22');
INSERT INTO `favorite` VALUES (81, 71, 'goods-0162', '2026-03-30 21:02:22');
INSERT INTO `favorite` VALUES (82, 84, 'goods-0173', '2026-03-31 02:02:22');
INSERT INTO `favorite` VALUES (83, 97, 'goods-0184', '2026-03-31 07:02:22');
INSERT INTO `favorite` VALUES (84, 11, 'goods-0195', '2026-03-31 12:02:22');
INSERT INTO `favorite` VALUES (85, 24, 'goods-0006', '2026-03-31 17:02:22');
INSERT INTO `favorite` VALUES (86, 37, 'goods-0017', '2026-03-31 22:02:22');
INSERT INTO `favorite` VALUES (87, 50, 'goods-0028', '2026-04-01 03:02:22');
INSERT INTO `favorite` VALUES (88, 63, 'goods-0039', '2026-04-01 08:02:22');
INSERT INTO `favorite` VALUES (89, 76, 'goods-0050', '2026-04-01 13:02:22');
INSERT INTO `favorite` VALUES (90, 89, 'goods-0061', '2026-04-01 18:02:22');
INSERT INTO `favorite` VALUES (91, 3, 'goods-0072', '2026-04-01 23:02:22');
INSERT INTO `favorite` VALUES (92, 16, 'goods-0083', '2026-04-02 04:02:22');
INSERT INTO `favorite` VALUES (93, 29, 'goods-0094', '2026-04-02 09:02:22');
INSERT INTO `favorite` VALUES (94, 42, 'goods-0105', '2026-04-02 14:02:22');
INSERT INTO `favorite` VALUES (95, 55, 'goods-0116', '2026-04-02 19:02:22');
INSERT INTO `favorite` VALUES (96, 68, 'goods-0127', '2026-04-03 00:02:22');
INSERT INTO `favorite` VALUES (97, 81, 'goods-0138', '2026-04-03 05:02:22');
INSERT INTO `favorite` VALUES (98, 94, 'goods-0149', '2026-04-03 10:02:22');
INSERT INTO `favorite` VALUES (99, 8, 'goods-0160', '2026-04-03 15:02:22');
INSERT INTO `favorite` VALUES (100, 21, 'goods-0171', '2026-04-03 20:02:22');
INSERT INTO `favorite` VALUES (101, 34, 'goods-0182', '2026-04-04 01:02:22');
INSERT INTO `favorite` VALUES (102, 47, 'goods-0193', '2026-04-04 06:02:22');
INSERT INTO `favorite` VALUES (103, 60, 'goods-0004', '2026-04-04 11:02:22');
INSERT INTO `favorite` VALUES (104, 73, 'goods-0015', '2026-04-04 16:02:22');
INSERT INTO `favorite` VALUES (105, 86, 'goods-0026', '2026-04-04 21:02:22');
INSERT INTO `favorite` VALUES (106, 99, 'goods-0037', '2026-04-05 02:02:22');
INSERT INTO `favorite` VALUES (107, 13, 'goods-0048', '2026-04-05 07:02:22');
INSERT INTO `favorite` VALUES (108, 26, 'goods-0059', '2026-04-05 12:02:22');
INSERT INTO `favorite` VALUES (109, 39, 'goods-0070', '2026-04-05 17:02:22');
INSERT INTO `favorite` VALUES (110, 52, 'goods-0081', '2026-04-05 22:02:22');

-- ----------------------------
-- Table structure for goods
-- ----------------------------
DROP TABLE IF EXISTS `goods`;
CREATE TABLE `goods`  (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '商品ID',
  `uuid` varchar(36) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '商品唯一标识',
  `seller_id` bigint NOT NULL COMMENT '卖家ID',
  `category_id` bigint NULL DEFAULT NULL COMMENT '分类ID',
  `title` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '商品标题',
  `description` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL COMMENT '商品描述',
  `price` decimal(10, 2) NOT NULL COMMENT '售价',
  `original_price` decimal(10, 2) NULL DEFAULT NULL COMMENT '原价',
  `condition_level` tinyint NOT NULL DEFAULT 5 COMMENT '成色: 1-10, 10全新',
  `is_bargain` tinyint NOT NULL DEFAULT 0 COMMENT '是否接受议价',
  `trade_method` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'FACE' COMMENT '交易方式: FACE面交, LOCKER邮件柜, BOTH',
  `campus_location` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '交易地点(校区)',
  `view_count` int NOT NULL DEFAULT 0 COMMENT '浏览量',
  `favorite_count` int NOT NULL DEFAULT 0 COMMENT '收藏数',
  `status` tinyint NOT NULL DEFAULT 1 COMMENT '状态: -1已删除, 0下架, 1在售, 2已售出, 3审核中',
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `uuid`(`uuid` ASC) USING BTREE,
  INDEX `idx_uuid`(`uuid` ASC) USING BTREE,
  INDEX `idx_seller`(`seller_id` ASC) USING BTREE,
  INDEX `idx_category`(`category_id` ASC) USING BTREE,
  INDEX `idx_status`(`status` ASC) USING BTREE,
  INDEX `idx_title`(`title` ASC) USING BTREE,
  FULLTEXT INDEX `ft_title_desc`(`title`, `description`),
  CONSTRAINT `goods_ibfk_1` FOREIGN KEY (`seller_id`) REFERENCES `user` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT `goods_ibfk_2` FOREIGN KEY (`category_id`) REFERENCES `category` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 201 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '商品表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of goods
-- ----------------------------
INSERT INTO `goods` VALUES (1, 'goods-0001', 9, 1, '高等数学教材 1', '九成新教材，适合期末复习和日常上课使用。', 18.00, 45.00, 8, 1, 'FACE', '东校区', 12, 1, 1, '2026-06-11 21:15:20', '2026-06-11 22:55:43');
INSERT INTO `goods` VALUES (2, 'goods-0002', 16, 2, '蓝牙耳机 2', '功能正常，续航良好，适合日常通勤。', 79.00, 199.00, 7, 1, 'BOTH', '西校区', 23, 1, 1, '2026-06-11 21:15:20', '2026-06-11 22:55:43');
INSERT INTO `goods` VALUES (3, 'goods-0003', 23, 3, '宿舍收纳箱 3', '空间大，适合宿舍整理使用。', 15.00, 39.00, 8, 0, 'FACE', '南校区', 8, 0, 1, '2026-06-11 21:15:20', '2026-06-11 22:55:43');
INSERT INTO `goods` VALUES (4, 'goods-0004', 30, 4, '羽毛球拍 4', '正常使用痕迹，适合日常运动。', 35.00, 88.00, 7, 1, 'FACE', '北校区', 16, 2, 1, '2026-06-11 21:15:20', '2026-06-11 22:55:43');
INSERT INTO `goods` VALUES (5, 'goods-0005', 37, 5, '秋冬外套 5', '尺码合适，成色较新。', 42.00, 129.00, 8, 1, 'BOTH', '东校区', 19, 1, 2, '2026-06-11 21:15:20', '2026-06-11 22:55:43');
INSERT INTO `goods` VALUES (6, 'goods-0006', 44, 6, '小说合集 6', '保存良好，书页完整。', 22.00, 68.00, 9, 0, 'FACE', '西校区', 9, 2, 1, '2026-06-11 21:15:20', '2026-06-11 22:55:43');
INSERT INTO `goods` VALUES (7, 'goods-0007', 51, 7, '桌面小风扇 7', '夏天宿舍必备，运行正常。', 20.00, 49.00, 7, 1, 'LOCKER', '南校区', 11, 1, 1, '2026-06-11 21:15:20', '2026-06-11 22:55:43');
INSERT INTO `goods` VALUES (8, 'goods-0008', 58, 1, '英语四级资料 8', '资料齐全，包含真题与笔记。', 12.00, 35.00, 9, 0, 'FACE', '北校区', 14, 2, 1, '2026-06-11 21:15:20', '2026-06-11 22:55:43');
INSERT INTO `goods` VALUES (9, 'goods-0009', 65, 2, '机械键盘 9', '轴体手感良好，灯光正常。', 95.00, 229.00, 8, 1, 'BOTH', '东校区', 31, 1, 2, '2026-06-11 21:15:20', '2026-06-11 22:55:43');
INSERT INTO `goods` VALUES (10, 'goods-0010', 72, 3, '保温杯 10', '无漏水，保温正常。', 19.00, 59.00, 8, 0, 'FACE', '西校区', 7, 2, 1, '2026-06-11 21:15:20', '2026-06-11 22:55:43');
INSERT INTO `goods` VALUES (11, 'goods-0011', 79, 4, '瑜伽垫 11', '适合宿舍健身和操场使用。', 24.00, 69.00, 8, 1, 'FACE', '南校区', 13, 0, 1, '2026-06-11 21:15:20', '2026-06-11 22:55:43');
INSERT INTO `goods` VALUES (12, 'goods-0012', 86, 5, '口红套装 12', '颜色日常，基本未使用。', 39.00, 119.00, 9, 0, 'BOTH', '北校区', 18, 2, 1, '2026-06-11 21:15:20', '2026-06-11 22:55:43');
INSERT INTO `goods` VALUES (13, 'goods-0013', 93, 6, '考研政治书 13', '笔记完整，适合二轮复习。', 16.00, 52.00, 8, 1, 'FACE', '东校区', 15, 0, 1, '2026-06-11 21:15:20', '2026-06-11 22:55:43');
INSERT INTO `goods` VALUES (14, 'goods-0014', 100, 7, '台灯 14', '亮度正常，宿舍学习使用方便。', 26.00, 79.00, 7, 1, 'LOCKER', '西校区', 21, 1, 1, '2026-06-11 21:15:20', '2026-06-11 22:55:43');
INSERT INTO `goods` VALUES (15, 'goods-0015', 8, 1, '离散数学教材 15', '章节完整，适合平时学习。', 20.00, 48.00, 8, 0, 'FACE', '南校区', 9, 1, 1, '2026-06-11 21:15:20', '2026-06-11 22:55:43');
INSERT INTO `goods` VALUES (16, 'goods-0016', 15, 2, '移动硬盘 16', '容量正常，传输稳定。', 120.00, 299.00, 7, 1, 'BOTH', '北校区', 34, 1, 1, '2026-06-11 21:15:20', '2026-06-11 22:55:43');
INSERT INTO `goods` VALUES (17, 'goods-0017', 22, 3, '晾衣架 17', '宿舍常用，结构完整。', 10.00, 25.00, 8, 0, 'FACE', '东校区', 5, 1, 1, '2026-06-11 21:15:20', '2026-06-11 22:55:43');
INSERT INTO `goods` VALUES (18, 'goods-0018', 29, 4, '足球 18', '有使用痕迹，不影响使用。', 28.00, 79.00, 7, 1, 'FACE', '西校区', 10, 1, 1, '2026-06-11 21:15:20', '2026-06-11 22:55:43');
INSERT INTO `goods` VALUES (19, 'goods-0019', 36, 5, '双肩包 19', '容量大，拉链正常。', 36.00, 99.00, 8, 1, 'BOTH', '南校区', 17, 2, 1, '2026-06-11 21:15:20', '2026-06-11 22:55:43');
INSERT INTO `goods` VALUES (20, 'goods-0020', 43, 6, '纪录片光盘 20', '收藏向，保存完好。', 14.00, 40.00, 9, 0, 'FACE', '北校区', 6, 1, 1, '2026-06-11 21:15:20', '2026-06-11 22:55:43');
INSERT INTO `goods` VALUES (21, 'goods-0021', 50, 7, '插线板 21', '接口正常，线材完整。', 18.00, 39.00, 8, 0, 'LOCKER', '东校区', 12, 1, 1, '2026-06-11 21:15:20', '2026-06-11 22:55:43');
INSERT INTO `goods` VALUES (22, 'goods-0022', 57, 1, '计算机组成原理教材 22', '内容完整，适合考试复习。', 21.00, 55.00, 8, 1, 'FACE', '西校区', 16, 1, 1, '2026-06-11 21:15:20', '2026-06-11 22:55:43');
INSERT INTO `goods` VALUES (23, 'goods-0023', 64, 2, '鼠标 23', '功能正常，点击顺畅。', 25.00, 79.00, 8, 1, 'BOTH', '南校区', 14, 1, 1, '2026-06-11 21:15:20', '2026-06-11 22:55:43');
INSERT INTO `goods` VALUES (24, 'goods-0024', 71, 3, '洗衣篮 24', '宿舍整理使用方便。', 11.00, 28.00, 8, 0, 'FACE', '北校区', 4, 0, 1, '2026-06-11 21:15:20', '2026-06-11 22:55:43');
INSERT INTO `goods` VALUES (25, 'goods-0025', 78, 4, '跳绳 25', '适合体测训练。', 9.00, 25.00, 9, 0, 'FACE', '东校区', 8, 1, 1, '2026-06-11 21:15:20', '2026-06-11 22:55:43');
INSERT INTO `goods` VALUES (26, 'goods-0026', 85, 5, '围巾 26', '颜色百搭，冬季实用。', 17.00, 49.00, 8, 1, 'BOTH', '西校区', 7, 1, 1, '2026-06-11 21:15:20', '2026-06-11 22:55:43');
INSERT INTO `goods` VALUES (27, 'goods-0027', 92, 6, '英语原版书 27', '适合阅读训练，书况较好。', 23.00, 66.00, 8, 0, 'FACE', '南校区', 11, 1, 1, '2026-06-11 21:15:20', '2026-06-11 22:55:43');
INSERT INTO `goods` VALUES (28, 'goods-0028', 99, 7, '小夜灯 28', '可正常使用，亮度柔和。', 13.00, 35.00, 9, 0, 'LOCKER', '北校区', 6, 1, 1, '2026-06-11 21:15:20', '2026-06-11 22:55:43');
INSERT INTO `goods` VALUES (29, 'goods-0029', 7, 1, '概率论教材 29', '适合课程学习和考前复习。', 19.00, 46.00, 8, 1, 'FACE', '东校区', 13, 1, 1, '2026-06-11 21:15:20', '2026-06-11 22:55:43');
INSERT INTO `goods` VALUES (30, 'goods-0030', 14, 2, '平板支架 30', '日常学习追剧都适合。', 15.00, 42.00, 8, 1, 'BOTH', '西校区', 9, 1, 1, '2026-06-11 21:15:20', '2026-06-11 22:55:43');
INSERT INTO `goods` VALUES (31, 'goods-0031', 21, 3, '桌面收纳盒 31', '宿舍书桌整理神器。', 12.00, 29.00, 8, 0, 'FACE', '南校区', 6, 0, 1, '2026-06-11 21:15:20', '2026-06-11 22:55:43');
INSERT INTO `goods` VALUES (32, 'goods-0032', 28, 4, '篮球 32', '气密性正常。', 39.00, 99.00, 7, 1, 'FACE', '北校区', 15, 2, 1, '2026-06-11 21:15:20', '2026-06-11 22:55:43');
INSERT INTO `goods` VALUES (33, 'goods-0033', 35, 5, '卫衣 33', '宽松版型，适合秋冬穿着。', 45.00, 139.00, 8, 1, 'BOTH', '东校区', 19, 1, 1, '2026-06-11 21:15:20', '2026-06-11 22:55:43');
INSERT INTO `goods` VALUES (34, 'goods-0034', 42, 6, '摄影画册 34', '印刷精美，收藏价值高。', 26.00, 75.00, 9, 0, 'FACE', '西校区', 10, 1, 1, '2026-06-11 21:15:20', '2026-06-11 22:55:43');
INSERT INTO `goods` VALUES (35, 'goods-0035', 49, 7, 'U型枕 35', '旅行和午休都方便。', 18.00, 45.00, 8, 0, 'LOCKER', '南校区', 7, 0, 1, '2026-06-11 21:15:20', '2026-06-11 22:55:43');
INSERT INTO `goods` VALUES (36, 'goods-0036', 56, 1, '大学物理教材 36', '内容完整，边角轻微磨损。', 18.00, 50.00, 7, 1, 'FACE', '北校区', 12, 0, 1, '2026-06-11 21:15:20', '2026-06-11 22:55:43');
INSERT INTO `goods` VALUES (37, 'goods-0037', 63, 2, '便携音箱 37', '音质正常，蓝牙连接稳定。', 68.00, 168.00, 7, 1, 'BOTH', '东校区', 24, 2, 2, '2026-06-11 21:15:20', '2026-06-11 22:55:43');
INSERT INTO `goods` VALUES (38, 'goods-0038', 70, 3, '热水袋 38', '冬天宿舍常用。', 14.00, 32.00, 8, 0, 'FACE', '西校区', 5, 0, 1, '2026-06-11 21:15:20', '2026-06-11 22:55:43');
INSERT INTO `goods` VALUES (39, 'goods-0039', 77, 4, '哑铃 39', '适合宿舍轻训练。', 32.00, 88.00, 8, 1, 'FACE', '南校区', 11, 1, 1, '2026-06-11 21:15:20', '2026-06-11 22:55:43');
INSERT INTO `goods` VALUES (40, 'goods-0040', 84, 5, '帆布鞋 40', '尺码标准，成色较新。', 33.00, 109.00, 8, 1, 'BOTH', '北校区', 14, 0, 1, '2026-06-11 21:15:20', '2026-06-11 22:55:43');
INSERT INTO `goods` VALUES (41, 'goods-0041', 91, 6, '教材笔记合集 41', '包含重点标注和错题总结。', 20.00, 60.00, 9, 0, 'FACE', '东校区', 18, 2, 1, '2026-06-11 21:15:20', '2026-06-11 22:55:43');
INSERT INTO `goods` VALUES (42, 'goods-0042', 98, 7, '充电台灯 42', '续航正常，适合晚自习。', 29.00, 79.00, 8, 1, 'LOCKER', '西校区', 13, 0, 1, '2026-06-11 21:15:20', '2026-06-11 22:55:43');
INSERT INTO `goods` VALUES (43, 'goods-0043', 6, 1, '线性代数教材 43', '适合课程学习和考前冲刺。', 17.00, 42.00, 8, 0, 'FACE', '南校区', 9, 1, 1, '2026-06-11 21:15:20', '2026-06-11 22:55:43');
INSERT INTO `goods` VALUES (44, 'goods-0044', 13, 2, '显示器支架 44', '结构稳定，安装方便。', 36.00, 98.00, 8, 1, 'BOTH', '北校区', 11, 0, 1, '2026-06-11 21:15:20', '2026-06-11 22:55:43');
INSERT INTO `goods` VALUES (45, 'goods-0045', 20, 3, '抱枕 45', '午休和宿舍靠背都适合。', 16.00, 39.00, 9, 0, 'FACE', '东校区', 4, 1, 1, '2026-06-11 21:15:20', '2026-06-11 22:55:43');
INSERT INTO `goods` VALUES (46, 'goods-0046', 27, 4, '护腕 46', '打球训练可用。', 10.00, 26.00, 9, 0, 'FACE', '西校区', 6, 0, 1, '2026-06-11 21:15:20', '2026-06-11 22:55:43');
INSERT INTO `goods` VALUES (47, 'goods-0047', 34, 5, '化妆包 47', '便携耐用。', 13.00, 33.00, 8, 0, 'BOTH', '南校区', 5, 0, 1, '2026-06-11 21:15:20', '2026-06-11 22:55:43');
INSERT INTO `goods` VALUES (48, 'goods-0048', 41, 6, '考研英语书 48', '有少量笔记，适合备考。', 24.00, 69.00, 8, 1, 'FACE', '北校区', 14, 2, 1, '2026-06-11 21:15:20', '2026-06-11 22:55:43');
INSERT INTO `goods` VALUES (49, 'goods-0049', 48, 7, '宿舍挂钩 49', '可承重，实用性强。', 8.00, 20.00, 9, 0, 'LOCKER', '东校区', 3, 0, 1, '2026-06-11 21:15:20', '2026-06-11 22:55:43');
INSERT INTO `goods` VALUES (50, 'goods-0050', 55, 1, '数据结构教材 50', '课堂学习和考试复习均可使用。', 22.00, 58.00, 8, 1, 'FACE', '西校区', 20, 2, 1, '2026-06-11 21:15:20', '2026-06-11 22:55:43');
INSERT INTO `goods` VALUES (51, 'goods-0051', 62, 2, '二手路由器 51', '网络连接稳定。', 49.00, 129.00, 7, 1, 'BOTH', '南校区', 18, 0, 1, '2026-06-11 21:15:20', '2026-06-11 22:55:43');
INSERT INTO `goods` VALUES (52, 'goods-0052', 69, 3, '地垫 52', '适合宿舍门口使用。', 12.00, 30.00, 8, 0, 'FACE', '北校区', 4, 1, 1, '2026-06-11 21:15:20', '2026-06-11 22:55:43');
INSERT INTO `goods` VALUES (53, 'goods-0053', 76, 4, '乒乓球拍 53', '拍面正常，日常娱乐足够。', 21.00, 59.00, 8, 1, 'FACE', '东校区', 9, 0, 1, '2026-06-11 21:15:20', '2026-06-11 22:55:43');
INSERT INTO `goods` VALUES (54, 'goods-0054', 83, 5, '毛衣 54', '保暖舒适。', 31.00, 88.00, 8, 1, 'BOTH', '西校区', 11, 1, 1, '2026-06-11 21:15:20', '2026-06-11 22:55:43');
INSERT INTO `goods` VALUES (55, 'goods-0055', 90, 6, '漫画书 55', '成套出售，保存较好。', 25.00, 78.00, 8, 0, 'FACE', '南校区', 10, 0, 1, '2026-06-11 21:15:20', '2026-06-11 22:55:43');
INSERT INTO `goods` VALUES (56, 'goods-0056', 97, 7, '床边置物架 56', '宿舍空间利用率提升明显。', 28.00, 72.00, 8, 1, 'LOCKER', '北校区', 15, 1, 1, '2026-06-11 21:15:20', '2026-06-11 22:55:43');
INSERT INTO `goods` VALUES (57, 'goods-0057', 5, 1, 'C语言教材 57', '代码示例完整，适合初学者。', 16.00, 43.00, 8, 0, 'FACE', '东校区', 13, 0, 1, '2026-06-11 21:15:20', '2026-06-11 22:55:43');
INSERT INTO `goods` VALUES (58, 'goods-0058', 12, 2, '键鼠套装 58', '功能正常。', 52.00, 149.00, 7, 1, 'BOTH', '西校区', 19, 0, 1, '2026-06-11 21:15:20', '2026-06-11 22:55:43');
INSERT INTO `goods` VALUES (59, 'goods-0059', 19, 3, '垃圾桶 59', '宿舍常用。', 9.00, 22.00, 8, 0, 'FACE', '南校区', 3, 1, 1, '2026-06-11 21:15:20', '2026-06-11 22:55:43');
INSERT INTO `goods` VALUES (60, 'goods-0060', 26, 4, '护膝 60', '跑步或打球可用。', 14.00, 36.00, 8, 0, 'FACE', '北校区', 5, 0, 1, '2026-06-11 21:15:20', '2026-06-11 22:55:43');
INSERT INTO `goods` VALUES (61, 'goods-0061', 33, 5, '斜挎包 61', '轻便实用。', 27.00, 76.00, 8, 1, 'BOTH', '东校区', 9, 1, 1, '2026-06-11 21:15:20', '2026-06-11 22:55:43');
INSERT INTO `goods` VALUES (62, 'goods-0062', 40, 6, '文学作品集 62', '适合课余阅读。', 19.00, 57.00, 9, 0, 'FACE', '西校区', 8, 0, 1, '2026-06-11 21:15:20', '2026-06-11 22:55:43');
INSERT INTO `goods` VALUES (63, 'goods-0063', 47, 7, '电吹风 63', '冷热风正常。', 35.00, 89.00, 7, 1, 'LOCKER', '南校区', 17, 1, 1, '2026-06-11 21:15:20', '2026-06-11 22:55:43');
INSERT INTO `goods` VALUES (64, 'goods-0064', 54, 1, '操作系统教材 64', '边角有少量磨损，不影响阅读。', 18.00, 52.00, 7, 1, 'FACE', '北校区', 11, 0, 1, '2026-06-11 21:15:20', '2026-06-11 22:55:43');
INSERT INTO `goods` VALUES (65, 'goods-0065', 61, 2, '充电宝 65', '可正常充电，容量正常。', 44.00, 109.00, 7, 1, 'BOTH', '东校区', 26, 2, 1, '2026-06-11 21:15:20', '2026-06-11 22:55:43');
INSERT INTO `goods` VALUES (66, 'goods-0066', 68, 3, '洗漱收纳袋 66', '旅行和宿舍都方便。', 12.00, 28.00, 8, 0, 'FACE', '西校区', 4, 0, 1, '2026-06-11 21:15:20', '2026-06-11 22:55:43');
INSERT INTO `goods` VALUES (67, 'goods-0067', 75, 4, '臂力器 67', '使用正常。', 20.00, 58.00, 8, 1, 'FACE', '南校区', 7, 1, 1, '2026-06-11 21:15:20', '2026-06-11 22:55:43');
INSERT INTO `goods` VALUES (68, 'goods-0068', 82, 5, '羽绒马甲 68', '保暖轻便。', 46.00, 139.00, 8, 1, 'BOTH', '北校区', 16, 0, 1, '2026-06-11 21:15:20', '2026-06-11 22:55:43');
INSERT INTO `goods` VALUES (69, 'goods-0069', 89, 6, '期刊合订本 69', '适合专业学习参考。', 21.00, 63.00, 8, 0, 'FACE', '东校区', 8, 0, 1, '2026-06-11 21:15:20', '2026-06-11 22:55:43');
INSERT INTO `goods` VALUES (70, 'goods-0070', 96, 7, '小置物篮 70', '桌面整理常用。', 10.00, 24.00, 9, 0, 'LOCKER', '西校区', 4, 1, 1, '2026-06-11 21:15:20', '2026-06-11 22:55:43');
INSERT INTO `goods` VALUES (71, 'goods-0071', 4, 1, '编译原理教材 71', '适合专业课学习。', 23.00, 61.00, 8, 1, 'FACE', '南校区', 14, 0, 1, '2026-06-11 21:15:20', '2026-06-11 22:55:43');
INSERT INTO `goods` VALUES (72, 'goods-0072', 11, 2, '游戏耳机 72', '麦克风正常。', 66.00, 168.00, 7, 1, 'BOTH', '北校区', 20, 1, 1, '2026-06-11 21:15:20', '2026-06-11 22:55:43');
INSERT INTO `goods` VALUES (73, 'goods-0073', 18, 3, '折叠椅 73', '宿舍小凳，使用方便。', 18.00, 49.00, 8, 0, 'FACE', '东校区', 6, 0, 1, '2026-06-11 21:15:20', '2026-06-11 22:55:43');
INSERT INTO `goods` VALUES (74, 'goods-0074', 25, 4, '健腹轮 74', '功能正常。', 17.00, 45.00, 8, 0, 'FACE', '西校区', 5, 1, 1, '2026-06-11 21:15:20', '2026-06-11 22:55:43');
INSERT INTO `goods` VALUES (75, 'goods-0075', 32, 5, '针织帽 75', '秋冬适用。', 11.00, 29.00, 9, 0, 'BOTH', '南校区', 3, 0, 1, '2026-06-11 21:15:20', '2026-06-11 22:55:43');
INSERT INTO `goods` VALUES (76, 'goods-0076', 39, 6, '艺术设计书 76', '插图丰富，适合参考。', 24.00, 71.00, 8, 0, 'FACE', '北校区', 7, 1, 1, '2026-06-11 21:15:20', '2026-06-11 22:55:43');
INSERT INTO `goods` VALUES (77, 'goods-0077', 46, 7, '加湿器 77', '冬季宿舍常用。', 33.00, 85.00, 7, 1, 'LOCKER', '东校区', 15, 0, 1, '2026-06-11 21:15:20', '2026-06-11 22:55:43');
INSERT INTO `goods` VALUES (78, 'goods-0078', 53, 1, '数据库教材 78', '知识点齐全。', 20.00, 57.00, 8, 1, 'FACE', '西校区', 13, 1, 2, '2026-06-11 21:15:20', '2026-06-11 22:55:43');
INSERT INTO `goods` VALUES (79, 'goods-0079', 60, 2, '笔记本散热器 79', '适合宿舍学习使用。', 29.00, 88.00, 8, 1, 'BOTH', '南校区', 10, 0, 1, '2026-06-11 21:15:20', '2026-06-11 22:55:43');
INSERT INTO `goods` VALUES (80, 'goods-0080', 67, 3, '被夹 80', '固定被褥，宿舍实用。', 8.00, 18.00, 9, 0, 'FACE', '北校区', 2, 0, 1, '2026-06-11 21:15:20', '2026-06-11 22:55:43');
INSERT INTO `goods` VALUES (81, 'goods-0081', 74, 4, '网球拍 81', '有轻微使用痕迹。', 48.00, 128.00, 7, 1, 'FACE', '东校区', 17, 2, 1, '2026-06-11 21:15:20', '2026-06-11 22:55:43');
INSERT INTO `goods` VALUES (82, 'goods-0082', 81, 5, '长裙 82', '适合春秋穿着。', 38.00, 118.00, 8, 1, 'BOTH', '西校区', 12, 0, 1, '2026-06-11 21:15:20', '2026-06-11 22:55:43');
INSERT INTO `goods` VALUES (83, 'goods-0083', 88, 6, '考研数学资料 83', '有重点笔记。', 26.00, 74.00, 8, 1, 'FACE', '南校区', 18, 1, 1, '2026-06-11 21:15:20', '2026-06-11 22:55:43');
INSERT INTO `goods` VALUES (84, 'goods-0084', 95, 7, '宿舍镜子 84', '便携实用。', 9.00, 20.00, 8, 0, 'LOCKER', '北校区', 3, 0, 1, '2026-06-11 21:15:20', '2026-06-11 22:55:43');
INSERT INTO `goods` VALUES (85, 'goods-0085', 3, 1, '软件工程教材 85', '课程设计参考价值高。', 21.00, 59.00, 8, 1, 'FACE', '东校区', 16, 1, 1, '2026-06-11 21:15:20', '2026-06-11 22:55:43');
INSERT INTO `goods` VALUES (86, 'goods-0086', 10, 2, '手写板 86', '可用于网课和笔记。', 54.00, 149.00, 8, 1, 'BOTH', '西校区', 11, 0, 1, '2026-06-11 21:15:20', '2026-06-11 22:55:43');
INSERT INTO `goods` VALUES (87, 'goods-0087', 17, 3, '饭盒 87', '微波炉可用。', 14.00, 35.00, 8, 0, 'FACE', '南校区', 5, 1, 1, '2026-06-11 21:15:20', '2026-06-11 22:55:43');
INSERT INTO `goods` VALUES (88, 'goods-0088', 24, 4, '拉力带 88', '弹力正常。', 10.00, 26.00, 9, 0, 'FACE', '北校区', 4, 0, 1, '2026-06-11 21:15:20', '2026-06-11 22:55:43');
INSERT INTO `goods` VALUES (89, 'goods-0089', 31, 5, '牛仔裤 89', '尺码正常，成色较新。', 34.00, 109.00, 8, 1, 'BOTH', '东校区', 13, 1, 1, '2026-06-11 21:15:20', '2026-06-11 22:55:43');
INSERT INTO `goods` VALUES (90, 'goods-0090', 38, 6, '杂志套装 90', '成套出售。', 18.00, 49.00, 8, 0, 'FACE', '西校区', 5, 0, 1, '2026-06-11 21:15:20', '2026-06-11 22:55:43');
INSERT INTO `goods` VALUES (91, 'goods-0091', 45, 7, '床上书桌 91', '宿舍学习方便。', 41.00, 109.00, 7, 1, 'LOCKER', '南校区', 18, 0, 1, '2026-06-11 21:15:20', '2026-06-11 22:55:43');
INSERT INTO `goods` VALUES (92, 'goods-0092', 52, 1, '考研英语资料 92', '适合强化阶段。', 22.00, 62.00, 8, 1, 'FACE', '北校区', 17, 1, 1, '2026-06-11 21:15:20', '2026-06-11 22:55:43');
INSERT INTO `goods` VALUES (93, 'goods-0093', 59, 2, '摄像头 93', '视频清晰，接口正常。', 46.00, 119.00, 8, 1, 'BOTH', '东校区', 14, 0, 1, '2026-06-11 21:15:20', '2026-06-11 22:55:43');
INSERT INTO `goods` VALUES (94, 'goods-0094', 66, 3, '拖把 94', '宿舍清洁常用。', 12.00, 29.00, 8, 0, 'FACE', '西校区', 3, 1, 1, '2026-06-11 21:15:20', '2026-06-11 22:55:43');
INSERT INTO `goods` VALUES (95, 'goods-0095', 73, 4, '排球 95', '适合日常娱乐。', 29.00, 79.00, 7, 1, 'FACE', '南校区', 8, 0, 1, '2026-06-11 21:15:20', '2026-06-11 22:55:43');
INSERT INTO `goods` VALUES (96, 'goods-0096', 80, 5, '手套 96', '冬季保暖。', 10.00, 25.00, 9, 0, 'BOTH', '北校区', 2, 1, 1, '2026-06-11 21:15:20', '2026-06-11 22:55:43');
INSERT INTO `goods` VALUES (97, 'goods-0097', 87, 6, '专业参考书 97', '内容完整。', 28.00, 80.00, 8, 1, 'FACE', '东校区', 10, 0, 1, '2026-06-11 21:15:20', '2026-06-11 22:55:43');
INSERT INTO `goods` VALUES (98, 'goods-0098', 94, 7, '靠垫 98', '宿舍沙发椅子都能用。', 15.00, 36.00, 8, 0, 'LOCKER', '西校区', 5, 1, 1, '2026-06-11 21:15:20', '2026-06-11 22:55:43');
INSERT INTO `goods` VALUES (99, 'goods-0099', 2, 1, '人工智能导论教材 99', '适合入门。', 24.00, 65.00, 8, 1, 'FACE', '南校区', 14, 0, 1, '2026-06-11 21:15:20', '2026-06-11 22:55:43');
INSERT INTO `goods` VALUES (100, 'goods-0100', 9, 2, '蓝牙音箱 100', '外放正常。', 58.00, 169.00, 7, 1, 'BOTH', '北校区', 18, 2, 1, '2026-06-11 21:15:20', '2026-06-11 22:55:43');
INSERT INTO `goods` VALUES (101, 'goods-0101', 16, 3, '收纳袋 101', '搬宿舍打包方便。', 9.00, 22.00, 9, 0, 'FACE', '东校区', 3, 0, 3, '2026-06-11 21:15:20', '2026-06-11 22:55:43');
INSERT INTO `goods` VALUES (102, 'goods-0102', 23, 4, '跳高绳 102', '训练可用。', 8.00, 20.00, 8, 0, 'FACE', '西校区', 2, 0, 3, '2026-06-11 21:15:20', '2026-06-11 22:55:43');
INSERT INTO `goods` VALUES (103, 'goods-0103', 30, 5, '连帽衫 103', '秋冬可穿。', 43.00, 119.00, 8, 1, 'BOTH', '南校区', 11, 0, 3, '2026-06-11 21:15:20', '2026-06-11 22:55:43');
INSERT INTO `goods` VALUES (104, 'goods-0104', 37, 6, '英语听力资料 104', '适合四六级备考。', 16.00, 40.00, 8, 0, 'FACE', '北校区', 6, 0, 3, '2026-06-11 21:15:20', '2026-06-11 22:55:43');
INSERT INTO `goods` VALUES (105, 'goods-0105', 44, 7, '插座转换器 105', '宿舍常用。', 12.00, 28.00, 9, 0, 'LOCKER', '东校区', 4, 1, 3, '2026-06-11 21:15:20', '2026-06-11 22:55:43');
INSERT INTO `goods` VALUES (106, 'goods-0106', 51, 1, '算法教材 106', '适合刷题和复习。', 22.00, 60.00, 8, 1, 'FACE', '西校区', 12, 0, 3, '2026-06-11 21:15:20', '2026-06-11 22:55:43');
INSERT INTO `goods` VALUES (107, 'goods-0107', 58, 2, '充电线套装 107', '接口完整。', 15.00, 39.00, 8, 0, 'BOTH', '南校区', 5, 1, 3, '2026-06-11 21:15:20', '2026-06-11 22:55:43');
INSERT INTO `goods` VALUES (108, 'goods-0108', 65, 3, '懒人桌 108', '宿舍追剧学习都方便。', 26.00, 69.00, 8, 1, 'FACE', '北校区', 10, 0, 3, '2026-06-11 21:15:20', '2026-06-11 22:55:43');
INSERT INTO `goods` VALUES (109, 'goods-0109', 72, 4, '握力器 109', '训练可用。', 11.00, 30.00, 9, 0, 'FACE', '东校区', 3, 1, 3, '2026-06-11 21:15:20', '2026-06-11 22:55:43');
INSERT INTO `goods` VALUES (110, 'goods-0110', 79, 5, '半身裙 110', '版型正常。', 29.00, 88.00, 8, 1, 'BOTH', '西校区', 8, 0, 3, '2026-06-11 21:15:20', '2026-06-11 22:55:43');
INSERT INTO `goods` VALUES (111, 'goods-0111', 86, 6, '文学选读 111', '课程参考书。', 17.00, 51.00, 8, 0, 'FACE', '南校区', 5, 1, 3, '2026-06-11 21:15:20', '2026-06-11 22:55:43');
INSERT INTO `goods` VALUES (112, 'goods-0112', 93, 7, '宿舍挂帘 112', '遮光效果较好。', 18.00, 44.00, 8, 1, 'LOCKER', '北校区', 7, 0, 3, '2026-06-11 21:15:20', '2026-06-11 22:55:43');
INSERT INTO `goods` VALUES (113, 'goods-0113', 100, 1, '计算机网络教材 113', '适合课程学习。', 19.00, 53.00, 8, 1, 'FACE', '东校区', 10, 0, 3, '2026-06-11 21:15:20', '2026-06-11 22:55:43');
INSERT INTO `goods` VALUES (114, 'goods-0114', 8, 2, 'Type-C扩展坞 114', '接口正常。', 67.00, 199.00, 7, 1, 'BOTH', '西校区', 13, 0, 3, '2026-06-11 21:15:20', '2026-06-11 22:55:43');
INSERT INTO `goods` VALUES (115, 'goods-0115', 15, 3, '衣撑 115', '宿舍日常使用。', 6.00, 15.00, 9, 0, 'FACE', '南校区', 2, 0, 3, '2026-06-11 21:15:20', '2026-06-11 22:55:43');
INSERT INTO `goods` VALUES (116, 'goods-0116', 22, 4, '仰卧起坐垫 116', '体测训练使用。', 20.00, 52.00, 8, 0, 'FACE', '北校区', 6, 1, 3, '2026-06-11 21:15:20', '2026-06-11 22:55:43');
INSERT INTO `goods` VALUES (117, 'goods-0117', 29, 5, '围脖 117', '秋冬实用。', 14.00, 35.00, 8, 0, 'BOTH', '东校区', 3, 0, 3, '2026-06-11 21:15:20', '2026-06-11 22:55:43');
INSERT INTO `goods` VALUES (118, 'goods-0118', 36, 6, '专业论文集 118', '适合查阅参考。', 23.00, 68.00, 8, 0, 'FACE', '西校区', 8, 1, 3, '2026-06-11 21:15:20', '2026-06-11 22:55:43');
INSERT INTO `goods` VALUES (119, 'goods-0119', 43, 7, '收纳架 119', '节省宿舍空间。', 27.00, 70.00, 8, 1, 'LOCKER', '南校区', 9, 0, 3, '2026-06-11 21:15:20', '2026-06-11 22:55:43');
INSERT INTO `goods` VALUES (120, 'goods-0120', 50, 1, '数学分析教材 120', '内容完整。', 21.00, 57.00, 8, 1, 'FACE', '北校区', 11, 1, 3, '2026-06-11 21:15:20', '2026-06-11 22:55:43');
INSERT INTO `goods` VALUES (121, 'goods-0121', 57, 2, '无线鼠标 121', '连接稳定。', 26.00, 79.00, 8, 1, 'BOTH', '东校区', 12, 0, 2, '2026-06-11 21:15:20', '2026-06-11 22:55:43');
INSERT INTO `goods` VALUES (122, 'goods-0122', 64, 3, '洗衣液分装瓶 122', '适合宿舍使用。', 7.00, 16.00, 9, 0, 'FACE', '西校区', 2, 1, 2, '2026-06-11 21:15:20', '2026-06-11 22:55:43');
INSERT INTO `goods` VALUES (123, 'goods-0123', 71, 4, '羽毛球 123', '适合日常练习。', 9.00, 22.00, 8, 0, 'FACE', '南校区', 3, 0, 2, '2026-06-11 21:15:20', '2026-06-11 22:55:43');
INSERT INTO `goods` VALUES (124, 'goods-0124', 78, 5, '针织衫 124', '成色较新。', 36.00, 99.00, 8, 1, 'BOTH', '北校区', 9, 0, 2, '2026-06-11 21:15:20', '2026-06-11 22:55:43');
INSERT INTO `goods` VALUES (125, 'goods-0125', 85, 6, '二手小说 125', '书况良好。', 13.00, 32.00, 8, 0, 'FACE', '东校区', 5, 0, 2, '2026-06-11 21:15:20', '2026-06-11 22:55:43');
INSERT INTO `goods` VALUES (126, 'goods-0126', 92, 7, '简易鞋架 126', '宿舍常用。', 24.00, 65.00, 8, 1, 'LOCKER', '西校区', 8, 0, 2, '2026-06-11 21:15:20', '2026-06-11 22:55:43');
INSERT INTO `goods` VALUES (127, 'goods-0127', 99, 1, '高数笔记 127', '重点清晰。', 10.00, 20.00, 9, 0, 'FACE', '南校区', 6, 1, 2, '2026-06-11 21:15:20', '2026-06-11 22:55:43');
INSERT INTO `goods` VALUES (128, 'goods-0128', 7, 2, 'USB集线器 128', '功能正常。', 19.00, 49.00, 8, 1, 'BOTH', '北校区', 7, 0, 2, '2026-06-11 21:15:20', '2026-06-11 22:55:43');
INSERT INTO `goods` VALUES (129, 'goods-0129', 14, 3, '床帘夹 129', '宿舍适用。', 6.00, 12.00, 9, 0, 'FACE', '东校区', 2, 1, 2, '2026-06-11 21:15:20', '2026-06-11 22:55:43');
INSERT INTO `goods` VALUES (130, 'goods-0130', 21, 4, '瑜伽砖 130', '健身辅助。', 12.00, 30.00, 8, 0, 'FACE', '西校区', 3, 0, 2, '2026-06-11 21:15:20', '2026-06-11 22:55:43');
INSERT INTO `goods` VALUES (131, 'goods-0131', 28, 5, '休闲裤 131', '穿着舒适。', 29.00, 89.00, 8, 1, 'BOTH', '南校区', 8, 1, 2, '2026-06-11 21:15:20', '2026-06-11 22:55:43');
INSERT INTO `goods` VALUES (132, 'goods-0132', 35, 6, '英语阅读资料 132', '适合阅读提升。', 15.00, 39.00, 8, 0, 'FACE', '北校区', 5, 0, 2, '2026-06-11 21:15:20', '2026-06-11 22:55:43');
INSERT INTO `goods` VALUES (133, 'goods-0133', 42, 7, '插座延长线 133', '使用正常。', 17.00, 42.00, 8, 0, 'LOCKER', '东校区', 4, 1, 2, '2026-06-11 21:15:20', '2026-06-11 22:55:43');
INSERT INTO `goods` VALUES (134, 'goods-0134', 49, 1, '面向对象程序设计教材 134', '适合课程学习。', 20.00, 54.00, 8, 1, 'FACE', '西校区', 10, 0, 2, '2026-06-11 21:15:20', '2026-06-11 22:55:43');
INSERT INTO `goods` VALUES (135, 'goods-0135', 56, 2, '显示器挂灯 135', '亮度正常。', 42.00, 115.00, 8, 1, 'BOTH', '南校区', 9, 0, 2, '2026-06-11 21:15:20', '2026-06-11 22:55:43');
INSERT INTO `goods` VALUES (136, 'goods-0136', 63, 3, '毛巾架 136', '宿舍整理用。', 8.00, 19.00, 9, 0, 'FACE', '北校区', 2, 0, 2, '2026-06-11 21:15:20', '2026-06-11 22:55:43');
INSERT INTO `goods` VALUES (137, 'goods-0137', 70, 4, '计步器 137', '功能正常。', 11.00, 28.00, 8, 0, 'FACE', '东校区', 3, 0, 2, '2026-06-11 21:15:20', '2026-06-11 22:55:43');
INSERT INTO `goods` VALUES (138, 'goods-0138', 77, 5, '手提包 138', '轻便好用。', 31.00, 92.00, 8, 1, 'BOTH', '西校区', 8, 1, 2, '2026-06-11 21:15:20', '2026-06-11 22:55:43');
INSERT INTO `goods` VALUES (139, 'goods-0139', 84, 6, '写作参考书 139', '内容完整。', 18.00, 46.00, 8, 0, 'FACE', '南校区', 6, 0, 2, '2026-06-11 21:15:20', '2026-06-11 22:55:43');
INSERT INTO `goods` VALUES (140, 'goods-0140', 91, 7, '床边小柜 140', '宿舍实用。', 39.00, 99.00, 7, 1, 'LOCKER', '北校区', 11, 1, 2, '2026-06-11 21:15:20', '2026-06-11 22:55:43');
INSERT INTO `goods` VALUES (141, 'goods-0141', 98, 1, '机器学习教材 141', '适合入门。', 25.00, 69.00, 8, 1, 'FACE', '东校区', 13, 1, 2, '2026-06-11 21:15:20', '2026-06-11 22:55:43');
INSERT INTO `goods` VALUES (142, 'goods-0142', 6, 2, '电容笔 142', '书写正常。', 34.00, 99.00, 8, 1, 'BOTH', '西校区', 9, 1, 1, '2026-06-11 21:15:20', '2026-06-11 22:55:43');
INSERT INTO `goods` VALUES (143, 'goods-0143', 13, 3, '小药箱 143', '宿舍备用。', 16.00, 38.00, 8, 0, 'FACE', '南校区', 4, 0, 1, '2026-06-11 21:15:20', '2026-06-11 22:55:43');
INSERT INTO `goods` VALUES (144, 'goods-0144', 20, 4, '弹力绳 144', '健身训练。', 13.00, 33.00, 8, 0, 'FACE', '北校区', 3, 1, 1, '2026-06-11 21:15:20', '2026-06-11 22:55:43');
INSERT INTO `goods` VALUES (145, 'goods-0145', 27, 5, '围裙 145', '实验/生活可用。', 9.00, 22.00, 9, 0, 'BOTH', '东校区', 2, 0, 1, '2026-06-11 21:15:20', '2026-06-11 22:55:43');
INSERT INTO `goods` VALUES (146, 'goods-0146', 34, 6, '专业习题集 146', '适合刷题。', 19.00, 58.00, 8, 1, 'FACE', '西校区', 7, 0, 1, '2026-06-11 21:15:20', '2026-06-11 22:55:43');
INSERT INTO `goods` VALUES (147, 'goods-0147', 41, 7, '宿舍小推车 147', '搬运收纳方便。', 28.00, 76.00, 8, 1, 'LOCKER', '南校区', 10, 0, 1, '2026-06-11 21:15:20', '2026-06-11 22:55:43');
INSERT INTO `goods` VALUES (148, 'goods-0148', 48, 1, '大学英语教材 148', '内容完整。', 14.00, 40.00, 8, 0, 'FACE', '北校区', 6, 0, 1, '2026-06-11 21:15:20', '2026-06-11 22:55:43');
INSERT INTO `goods` VALUES (149, 'goods-0149', 55, 2, '读卡器 149', '使用正常。', 12.00, 30.00, 8, 0, 'BOTH', '东校区', 3, 1, 1, '2026-06-11 21:15:20', '2026-06-11 22:55:43');
INSERT INTO `goods` VALUES (150, 'goods-0150', 62, 3, '收纳抽屉 150', '桌面整理。', 21.00, 56.00, 8, 1, 'FACE', '西校区', 8, 0, 1, '2026-06-11 21:15:20', '2026-06-11 22:55:43');
INSERT INTO `goods` VALUES (151, 'goods-0151', 69, 4, '仰卧板 151', '可正常使用。', 49.00, 129.00, 7, 1, 'FACE', '南校区', 12, 1, 1, '2026-06-11 21:15:20', '2026-06-11 22:55:43');
INSERT INTO `goods` VALUES (152, 'goods-0152', 76, 5, '风衣 152', '适合换季。', 52.00, 159.00, 8, 1, 'BOTH', '北校区', 14, 0, 1, '2026-06-11 21:15:20', '2026-06-11 22:55:43');
INSERT INTO `goods` VALUES (153, 'goods-0153', 83, 6, '经典文学集 153', '阅读收藏均可。', 24.00, 73.00, 8, 0, 'FACE', '东校区', 7, 1, 1, '2026-06-11 21:15:20', '2026-06-11 22:55:43');
INSERT INTO `goods` VALUES (154, 'goods-0154', 90, 7, '便携收纳桶 154', '宿舍整理。', 15.00, 37.00, 8, 0, 'LOCKER', '西校区', 4, 0, 1, '2026-06-11 21:15:20', '2026-06-11 22:55:43');
INSERT INTO `goods` VALUES (155, 'goods-0155', 97, 1, 'Java教材 155', '适合课程学习。', 21.00, 60.00, 8, 1, 'FACE', '南校区', 11, 1, 1, '2026-06-11 21:15:20', '2026-06-11 22:55:43');
INSERT INTO `goods` VALUES (156, 'goods-0156', 5, 2, '显示器 156', '功能正常，无坏点。', 168.00, 399.00, 7, 1, 'BOTH', '北校区', 21, 0, 1, '2026-06-11 21:15:20', '2026-06-11 22:55:43');
INSERT INTO `goods` VALUES (157, 'goods-0157', 12, 3, '暖水壶 157', '保温正常。', 18.00, 45.00, 8, 0, 'FACE', '东校区', 5, 0, 1, '2026-06-11 21:15:20', '2026-06-11 22:55:43');
INSERT INTO `goods` VALUES (158, 'goods-0158', 19, 4, '运动护具 158', '保护性良好。', 17.00, 43.00, 8, 0, 'FACE', '西校区', 4, 0, 1, '2026-06-11 21:15:20', '2026-06-11 22:55:43');
INSERT INTO `goods` VALUES (159, 'goods-0159', 26, 5, '帽子 159', '版型正常。', 13.00, 31.00, 8, 0, 'BOTH', '南校区', 3, 0, 1, '2026-06-11 21:15:20', '2026-06-11 22:55:43');
INSERT INTO `goods` VALUES (160, 'goods-0160', 33, 6, '考研真题册 160', '适合冲刺阶段。', 20.00, 59.00, 8, 1, 'FACE', '北校区', 10, 1, 1, '2026-06-11 21:15:20', '2026-06-11 22:55:43');
INSERT INTO `goods` VALUES (161, 'goods-0161', 40, 7, '文件盒 161', '适合整理资料。', 10.00, 22.00, 9, 0, 'LOCKER', '东校区', 2, 0, 1, '2026-06-11 21:15:20', '2026-06-11 22:55:43');
INSERT INTO `goods` VALUES (162, 'goods-0162', 47, 1, '数学建模教材 162', '适合竞赛入门。', 23.00, 66.00, 8, 1, 'FACE', '西校区', 9, 1, 1, '2026-06-11 21:15:20', '2026-06-11 22:55:43');
INSERT INTO `goods` VALUES (163, 'goods-0163', 54, 2, '摄像头支架 163', '安装方便。', 16.00, 42.00, 8, 0, 'BOTH', '南校区', 4, 0, 1, '2026-06-11 21:15:20', '2026-06-11 22:55:43');
INSERT INTO `goods` VALUES (164, 'goods-0164', 61, 3, '香薰机 164', '可正常使用。', 22.00, 58.00, 8, 1, 'FACE', '北校区', 7, 1, 1, '2026-06-11 21:15:20', '2026-06-11 22:55:43');
INSERT INTO `goods` VALUES (165, 'goods-0165', 68, 4, '筋膜球 165', '放松训练。', 9.00, 24.00, 9, 0, 'FACE', '东校区', 2, 0, 1, '2026-06-11 21:15:20', '2026-06-11 22:55:43');
INSERT INTO `goods` VALUES (166, 'goods-0166', 75, 5, '针织开衫 166', '日常可穿。', 37.00, 102.00, 8, 1, 'BOTH', '西校区', 8, 1, 1, '2026-06-11 21:15:20', '2026-06-11 22:55:43');
INSERT INTO `goods` VALUES (167, 'goods-0167', 82, 6, '设计素材书 167', '内容丰富。', 26.00, 72.00, 8, 0, 'FACE', '南校区', 6, 0, 1, '2026-06-11 21:15:20', '2026-06-11 22:55:43');
INSERT INTO `goods` VALUES (168, 'goods-0168', 89, 7, '床头收纳袋 168', '宿舍实用。', 14.00, 34.00, 8, 0, 'LOCKER', '北校区', 3, 0, 1, '2026-06-11 21:15:20', '2026-06-11 22:55:43');
INSERT INTO `goods` VALUES (169, 'goods-0169', 96, 1, '计算方法教材 169', '适合专业学习。', 18.00, 51.00, 8, 1, 'FACE', '东校区', 8, 0, 1, '2026-06-11 21:15:20', '2026-06-11 22:55:43');
INSERT INTO `goods` VALUES (170, 'goods-0170', 4, 2, '无线键盘 170', '连接稳定。', 45.00, 129.00, 8, 1, 'BOTH', '西校区', 13, 0, 1, '2026-06-11 21:15:20', '2026-06-11 22:55:43');
INSERT INTO `goods` VALUES (171, 'goods-0171', 11, 3, '纸巾盒 171', '宿舍常用。', 7.00, 16.00, 9, 0, 'FACE', '南校区', 2, 1, 1, '2026-06-11 21:15:20', '2026-06-11 22:55:43');
INSERT INTO `goods` VALUES (172, 'goods-0172', 18, 4, '跳操垫 172', '运动训练。', 19.00, 49.00, 8, 0, 'FACE', '北校区', 4, 0, 1, '2026-06-11 21:15:20', '2026-06-11 22:55:43');
INSERT INTO `goods` VALUES (173, 'goods-0173', 25, 5, '棉服 173', '冬季保暖。', 55.00, 169.00, 8, 1, 'BOTH', '东校区', 12, 1, 1, '2026-06-11 21:15:20', '2026-06-11 22:55:43');
INSERT INTO `goods` VALUES (174, 'goods-0174', 32, 6, '语言学参考书 174', '课程学习。', 22.00, 61.00, 8, 0, 'FACE', '西校区', 7, 0, 1, '2026-06-11 21:15:20', '2026-06-11 22:55:43');
INSERT INTO `goods` VALUES (175, 'goods-0175', 39, 7, '桌边挂篮 175', '收纳方便。', 11.00, 26.00, 8, 0, 'LOCKER', '南校区', 3, 1, 1, '2026-06-11 21:15:20', '2026-06-11 22:55:43');
INSERT INTO `goods` VALUES (176, 'goods-0176', 46, 1, '数字逻辑教材 176', '适合专业课复习。', 19.00, 54.00, 8, 1, 'FACE', '北校区', 8, 0, 1, '2026-06-11 21:15:20', '2026-06-11 22:55:43');
INSERT INTO `goods` VALUES (177, 'goods-0177', 53, 2, '拓展屏支架 177', '功能正常。', 38.00, 109.00, 8, 1, 'BOTH', '东校区', 9, 1, 1, '2026-06-11 21:15:20', '2026-06-11 22:55:43');
INSERT INTO `goods` VALUES (178, 'goods-0178', 60, 3, '洗脸盆 178', '宿舍常用。', 8.00, 18.00, 9, 0, 'FACE', '西校区', 2, 0, 1, '2026-06-11 21:15:20', '2026-06-11 22:55:43');
INSERT INTO `goods` VALUES (179, 'goods-0179', 67, 4, '腕力球 179', '训练可用。', 12.00, 29.00, 8, 0, 'FACE', '南校区', 3, 0, 1, '2026-06-11 21:15:20', '2026-06-11 22:55:43');
INSERT INTO `goods` VALUES (180, 'goods-0180', 74, 5, '毛呢外套 180', '成色较新。', 59.00, 179.00, 8, 1, 'BOTH', '北校区', 14, 0, 1, '2026-06-11 21:15:20', '2026-06-11 22:55:43');
INSERT INTO `goods` VALUES (181, 'goods-0181', 81, 6, '翻译资料 181', '适合课程参考。', 18.00, 48.00, 8, 0, 'FACE', '东校区', 6, 0, 1, '2026-06-11 21:15:20', '2026-06-11 22:55:43');
INSERT INTO `goods` VALUES (182, 'goods-0182', 88, 7, '挂衣杆 182', '宿舍收纳。', 20.00, 52.00, 8, 1, 'LOCKER', '西校区', 5, 1, 1, '2026-06-11 21:15:20', '2026-06-11 22:55:43');
INSERT INTO `goods` VALUES (183, 'goods-0183', 95, 1, '数据库实验指导 183', '实验课配套。', 15.00, 42.00, 8, 0, 'FACE', '南校区', 7, 0, 1, '2026-06-11 21:15:20', '2026-06-11 22:55:43');
INSERT INTO `goods` VALUES (184, 'goods-0184', 3, 2, '蓝牙适配器 184', '连接正常。', 14.00, 36.00, 8, 0, 'BOTH', '北校区', 4, 1, 1, '2026-06-11 21:15:20', '2026-06-11 22:55:43');
INSERT INTO `goods` VALUES (185, 'goods-0185', 10, 3, '桌面纸篓 185', '实用。', 9.00, 20.00, 9, 0, 'FACE', '东校区', 2, 0, 1, '2026-06-11 21:15:20', '2026-06-11 22:55:43');
INSERT INTO `goods` VALUES (186, 'goods-0186', 17, 4, '羽毛球鞋 186', '尺码正常。', 39.00, 109.00, 7, 1, 'FACE', '西校区', 8, 1, 1, '2026-06-11 21:15:20', '2026-06-11 22:55:43');
INSERT INTO `goods` VALUES (187, 'goods-0187', 24, 5, '针织围巾 187', '柔软保暖。', 16.00, 42.00, 8, 0, 'BOTH', '南校区', 3, 0, 1, '2026-06-11 21:15:20', '2026-06-11 22:55:43');
INSERT INTO `goods` VALUES (188, 'goods-0188', 31, 6, '古典文学选 188', '适合阅读。', 21.00, 60.00, 8, 0, 'FACE', '北校区', 6, 1, 1, '2026-06-11 21:15:20', '2026-06-11 22:55:43');
INSERT INTO `goods` VALUES (189, 'goods-0189', 38, 7, '宿舍置物板 189', '收纳方便。', 18.00, 48.00, 8, 1, 'LOCKER', '东校区', 5, 0, 1, '2026-06-11 21:15:20', '2026-06-11 22:55:43');
INSERT INTO `goods` VALUES (190, 'goods-0190', 45, 1, '软件测试教材 190', '课程复习资料。', 20.00, 56.00, 8, 1, 'FACE', '西校区', 7, 0, 1, '2026-06-11 21:15:20', '2026-06-11 22:55:43');
INSERT INTO `goods` VALUES (191, 'goods-0191', 52, 2, '音频转接头 191', '功能正常。', 9.00, 22.00, 9, 0, 'BOTH', '南校区', 2, 0, 1, '2026-06-11 21:15:20', '2026-06-11 22:55:43');
INSERT INTO `goods` VALUES (192, 'goods-0192', 59, 3, '洗衣夹 192', '宿舍常用。', 6.00, 12.00, 9, 0, 'FACE', '北校区', 1, 0, 1, '2026-06-11 21:15:20', '2026-06-11 22:55:43');
INSERT INTO `goods` VALUES (193, 'goods-0193', 66, 4, '网球 193', '训练使用。', 12.00, 30.00, 8, 0, 'FACE', '东校区', 3, 1, 1, '2026-06-11 21:15:20', '2026-06-11 22:55:43');
INSERT INTO `goods` VALUES (194, 'goods-0194', 73, 5, '运动外套 194', '适合春秋。', 46.00, 139.00, 8, 1, 'BOTH', '西校区', 11, 0, 1, '2026-06-11 21:15:20', '2026-06-11 22:55:43');
INSERT INTO `goods` VALUES (195, 'goods-0195', 80, 6, '阅读资料包 195', '资料齐全。', 17.00, 45.00, 8, 0, 'FACE', '南校区', 5, 1, 1, '2026-06-11 21:15:20', '2026-06-11 22:55:43');
INSERT INTO `goods` VALUES (196, 'goods-0196', 87, 7, '便携书架 196', '整理资料用。', 32.00, 86.00, 8, 1, 'LOCKER', '北校区', 8, 0, 1, '2026-06-11 21:15:20', '2026-06-11 22:55:43');
INSERT INTO `goods` VALUES (197, 'goods-0197', 94, 1, 'Web开发教材 197', '适合课程学习。', 23.00, 63.00, 8, 1, 'FACE', '东校区', 9, 1, 1, '2026-06-11 21:15:20', '2026-06-11 22:55:43');
INSERT INTO `goods` VALUES (198, 'goods-0198', 2, 2, 'USB小台灯 198', '供电正常。', 13.00, 34.00, 8, 0, 'BOTH', '西校区', 3, 0, 1, '2026-06-11 21:15:20', '2026-06-11 22:55:43');
INSERT INTO `goods` VALUES (199, 'goods-0199', 9, 3, '卷纸架 199', '宿舍实用。', 7.00, 16.00, 9, 0, 'FACE', '南校区', 1, 1, 1, '2026-06-11 21:15:20', '2026-06-11 22:55:43');
INSERT INTO `goods` VALUES (200, 'goods-0200', 16, 4, '健身跳箱 200', '训练使用，状态良好。', 58.00, 159.00, 7, 1, 'FACE', '北校区', 10, 0, 1, '2026-06-11 21:15:20', '2026-06-11 22:55:43');

-- ----------------------------
-- Table structure for goods_image
-- ----------------------------
DROP TABLE IF EXISTS `goods_image`;
CREATE TABLE `goods_image`  (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `goods_uuid` varchar(36) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '商品UUID',
  `url` varchar(512) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '图片URL(MinIO)',
  `sort_order` int NOT NULL DEFAULT 0 COMMENT '排序',
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_goods_uuid`(`goods_uuid` ASC) USING BTREE,
  CONSTRAINT `goods_image_ibfk_1` FOREIGN KEY (`goods_uuid`) REFERENCES `goods` (`uuid`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 256 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '商品图片表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of goods_image
-- ----------------------------
INSERT INTO `goods_image` VALUES (1, 'goods-0001', 'https://static.swapcampus.local/goods/goods-0001.jpg', 1, '2026-06-11 21:15:20');
INSERT INTO `goods_image` VALUES (2, 'goods-0002', 'https://static.swapcampus.local/goods/goods-0002.jpg', 1, '2026-06-11 21:15:20');
INSERT INTO `goods_image` VALUES (3, 'goods-0003', 'https://static.swapcampus.local/goods/goods-0003.jpg', 1, '2026-06-11 21:15:20');
INSERT INTO `goods_image` VALUES (4, 'goods-0004', 'https://static.swapcampus.local/goods/goods-0004.jpg', 1, '2026-06-11 21:15:20');
INSERT INTO `goods_image` VALUES (5, 'goods-0005', 'https://static.swapcampus.local/goods/goods-0005.jpg', 1, '2026-06-11 21:15:20');
INSERT INTO `goods_image` VALUES (6, 'goods-0006', 'https://static.swapcampus.local/goods/goods-0006.jpg', 1, '2026-06-11 21:15:20');
INSERT INTO `goods_image` VALUES (7, 'goods-0007', 'https://static.swapcampus.local/goods/goods-0007.jpg', 1, '2026-06-11 21:15:20');
INSERT INTO `goods_image` VALUES (8, 'goods-0008', 'https://static.swapcampus.local/goods/goods-0008.jpg', 1, '2026-06-11 21:15:20');
INSERT INTO `goods_image` VALUES (9, 'goods-0009', 'https://static.swapcampus.local/goods/goods-0009.jpg', 1, '2026-06-11 21:15:20');
INSERT INTO `goods_image` VALUES (10, 'goods-0010', 'https://static.swapcampus.local/goods/goods-0010.jpg', 1, '2026-06-11 21:15:20');
INSERT INTO `goods_image` VALUES (11, 'goods-0011', 'https://static.swapcampus.local/goods/goods-0011.jpg', 1, '2026-06-11 21:15:20');
INSERT INTO `goods_image` VALUES (12, 'goods-0012', 'https://static.swapcampus.local/goods/goods-0012.jpg', 1, '2026-06-11 21:15:20');
INSERT INTO `goods_image` VALUES (13, 'goods-0013', 'https://static.swapcampus.local/goods/goods-0013.jpg', 1, '2026-06-11 21:15:20');
INSERT INTO `goods_image` VALUES (14, 'goods-0014', 'https://static.swapcampus.local/goods/goods-0014.jpg', 1, '2026-06-11 21:15:20');
INSERT INTO `goods_image` VALUES (15, 'goods-0015', 'https://static.swapcampus.local/goods/goods-0015.jpg', 1, '2026-06-11 21:15:20');
INSERT INTO `goods_image` VALUES (16, 'goods-0016', 'https://static.swapcampus.local/goods/goods-0016.jpg', 1, '2026-06-11 21:15:20');
INSERT INTO `goods_image` VALUES (17, 'goods-0017', 'https://static.swapcampus.local/goods/goods-0017.jpg', 1, '2026-06-11 21:15:20');
INSERT INTO `goods_image` VALUES (18, 'goods-0018', 'https://static.swapcampus.local/goods/goods-0018.jpg', 1, '2026-06-11 21:15:20');
INSERT INTO `goods_image` VALUES (19, 'goods-0019', 'https://static.swapcampus.local/goods/goods-0019.jpg', 1, '2026-06-11 21:15:20');
INSERT INTO `goods_image` VALUES (20, 'goods-0020', 'https://static.swapcampus.local/goods/goods-0020.jpg', 1, '2026-06-11 21:15:20');
INSERT INTO `goods_image` VALUES (21, 'goods-0021', 'https://static.swapcampus.local/goods/goods-0021.jpg', 1, '2026-06-11 21:15:20');
INSERT INTO `goods_image` VALUES (22, 'goods-0022', 'https://static.swapcampus.local/goods/goods-0022.jpg', 1, '2026-06-11 21:15:20');
INSERT INTO `goods_image` VALUES (23, 'goods-0023', 'https://static.swapcampus.local/goods/goods-0023.jpg', 1, '2026-06-11 21:15:20');
INSERT INTO `goods_image` VALUES (24, 'goods-0024', 'https://static.swapcampus.local/goods/goods-0024.jpg', 1, '2026-06-11 21:15:20');
INSERT INTO `goods_image` VALUES (25, 'goods-0025', 'https://static.swapcampus.local/goods/goods-0025.jpg', 1, '2026-06-11 21:15:20');
INSERT INTO `goods_image` VALUES (26, 'goods-0026', 'https://static.swapcampus.local/goods/goods-0026.jpg', 1, '2026-06-11 21:15:20');
INSERT INTO `goods_image` VALUES (27, 'goods-0027', 'https://static.swapcampus.local/goods/goods-0027.jpg', 1, '2026-06-11 21:15:20');
INSERT INTO `goods_image` VALUES (28, 'goods-0028', 'https://static.swapcampus.local/goods/goods-0028.jpg', 1, '2026-06-11 21:15:20');
INSERT INTO `goods_image` VALUES (29, 'goods-0029', 'https://static.swapcampus.local/goods/goods-0029.jpg', 1, '2026-06-11 21:15:20');
INSERT INTO `goods_image` VALUES (30, 'goods-0030', 'https://static.swapcampus.local/goods/goods-0030.jpg', 1, '2026-06-11 21:15:20');
INSERT INTO `goods_image` VALUES (31, 'goods-0031', 'https://static.swapcampus.local/goods/goods-0031.jpg', 1, '2026-06-11 21:15:20');
INSERT INTO `goods_image` VALUES (32, 'goods-0032', 'https://static.swapcampus.local/goods/goods-0032.jpg', 1, '2026-06-11 21:15:20');
INSERT INTO `goods_image` VALUES (33, 'goods-0033', 'https://static.swapcampus.local/goods/goods-0033.jpg', 1, '2026-06-11 21:15:20');
INSERT INTO `goods_image` VALUES (34, 'goods-0034', 'https://static.swapcampus.local/goods/goods-0034.jpg', 1, '2026-06-11 21:15:20');
INSERT INTO `goods_image` VALUES (35, 'goods-0035', 'https://static.swapcampus.local/goods/goods-0035.jpg', 1, '2026-06-11 21:15:20');
INSERT INTO `goods_image` VALUES (36, 'goods-0036', 'https://static.swapcampus.local/goods/goods-0036.jpg', 1, '2026-06-11 21:15:20');
INSERT INTO `goods_image` VALUES (37, 'goods-0037', 'https://static.swapcampus.local/goods/goods-0037.jpg', 1, '2026-06-11 21:15:20');
INSERT INTO `goods_image` VALUES (38, 'goods-0038', 'https://static.swapcampus.local/goods/goods-0038.jpg', 1, '2026-06-11 21:15:20');
INSERT INTO `goods_image` VALUES (39, 'goods-0039', 'https://static.swapcampus.local/goods/goods-0039.jpg', 1, '2026-06-11 21:15:20');
INSERT INTO `goods_image` VALUES (40, 'goods-0040', 'https://static.swapcampus.local/goods/goods-0040.jpg', 1, '2026-06-11 21:15:20');
INSERT INTO `goods_image` VALUES (41, 'goods-0041', 'https://static.swapcampus.local/goods/goods-0041.jpg', 1, '2026-06-11 21:15:20');
INSERT INTO `goods_image` VALUES (42, 'goods-0042', 'https://static.swapcampus.local/goods/goods-0042.jpg', 1, '2026-06-11 21:15:20');
INSERT INTO `goods_image` VALUES (43, 'goods-0043', 'https://static.swapcampus.local/goods/goods-0043.jpg', 1, '2026-06-11 21:15:20');
INSERT INTO `goods_image` VALUES (44, 'goods-0044', 'https://static.swapcampus.local/goods/goods-0044.jpg', 1, '2026-06-11 21:15:20');
INSERT INTO `goods_image` VALUES (45, 'goods-0045', 'https://static.swapcampus.local/goods/goods-0045.jpg', 1, '2026-06-11 21:15:20');
INSERT INTO `goods_image` VALUES (46, 'goods-0046', 'https://static.swapcampus.local/goods/goods-0046.jpg', 1, '2026-06-11 21:15:20');
INSERT INTO `goods_image` VALUES (47, 'goods-0047', 'https://static.swapcampus.local/goods/goods-0047.jpg', 1, '2026-06-11 21:15:20');
INSERT INTO `goods_image` VALUES (48, 'goods-0048', 'https://static.swapcampus.local/goods/goods-0048.jpg', 1, '2026-06-11 21:15:20');
INSERT INTO `goods_image` VALUES (49, 'goods-0049', 'https://static.swapcampus.local/goods/goods-0049.jpg', 1, '2026-06-11 21:15:20');
INSERT INTO `goods_image` VALUES (50, 'goods-0050', 'https://static.swapcampus.local/goods/goods-0050.jpg', 1, '2026-06-11 21:15:20');
INSERT INTO `goods_image` VALUES (51, 'goods-0051', 'https://static.swapcampus.local/goods/goods-0051.jpg', 1, '2026-06-11 21:15:20');
INSERT INTO `goods_image` VALUES (52, 'goods-0052', 'https://static.swapcampus.local/goods/goods-0052.jpg', 1, '2026-06-11 21:15:20');
INSERT INTO `goods_image` VALUES (53, 'goods-0053', 'https://static.swapcampus.local/goods/goods-0053.jpg', 1, '2026-06-11 21:15:20');
INSERT INTO `goods_image` VALUES (54, 'goods-0054', 'https://static.swapcampus.local/goods/goods-0054.jpg', 1, '2026-06-11 21:15:20');
INSERT INTO `goods_image` VALUES (55, 'goods-0055', 'https://static.swapcampus.local/goods/goods-0055.jpg', 1, '2026-06-11 21:15:20');
INSERT INTO `goods_image` VALUES (56, 'goods-0056', 'https://static.swapcampus.local/goods/goods-0056.jpg', 1, '2026-06-11 21:15:20');
INSERT INTO `goods_image` VALUES (57, 'goods-0057', 'https://static.swapcampus.local/goods/goods-0057.jpg', 1, '2026-06-11 21:15:20');
INSERT INTO `goods_image` VALUES (58, 'goods-0058', 'https://static.swapcampus.local/goods/goods-0058.jpg', 1, '2026-06-11 21:15:20');
INSERT INTO `goods_image` VALUES (59, 'goods-0059', 'https://static.swapcampus.local/goods/goods-0059.jpg', 1, '2026-06-11 21:15:20');
INSERT INTO `goods_image` VALUES (60, 'goods-0060', 'https://static.swapcampus.local/goods/goods-0060.jpg', 1, '2026-06-11 21:15:20');
INSERT INTO `goods_image` VALUES (61, 'goods-0061', 'https://static.swapcampus.local/goods/goods-0061.jpg', 1, '2026-06-11 21:15:20');
INSERT INTO `goods_image` VALUES (62, 'goods-0062', 'https://static.swapcampus.local/goods/goods-0062.jpg', 1, '2026-06-11 21:15:20');
INSERT INTO `goods_image` VALUES (63, 'goods-0063', 'https://static.swapcampus.local/goods/goods-0063.jpg', 1, '2026-06-11 21:15:20');
INSERT INTO `goods_image` VALUES (64, 'goods-0064', 'https://static.swapcampus.local/goods/goods-0064.jpg', 1, '2026-06-11 21:15:20');
INSERT INTO `goods_image` VALUES (65, 'goods-0065', 'https://static.swapcampus.local/goods/goods-0065.jpg', 1, '2026-06-11 21:15:20');
INSERT INTO `goods_image` VALUES (66, 'goods-0066', 'https://static.swapcampus.local/goods/goods-0066.jpg', 1, '2026-06-11 21:15:20');
INSERT INTO `goods_image` VALUES (67, 'goods-0067', 'https://static.swapcampus.local/goods/goods-0067.jpg', 1, '2026-06-11 21:15:20');
INSERT INTO `goods_image` VALUES (68, 'goods-0068', 'https://static.swapcampus.local/goods/goods-0068.jpg', 1, '2026-06-11 21:15:20');
INSERT INTO `goods_image` VALUES (69, 'goods-0069', 'https://static.swapcampus.local/goods/goods-0069.jpg', 1, '2026-06-11 21:15:20');
INSERT INTO `goods_image` VALUES (70, 'goods-0070', 'https://static.swapcampus.local/goods/goods-0070.jpg', 1, '2026-06-11 21:15:20');
INSERT INTO `goods_image` VALUES (71, 'goods-0071', 'https://static.swapcampus.local/goods/goods-0071.jpg', 1, '2026-06-11 21:15:20');
INSERT INTO `goods_image` VALUES (72, 'goods-0072', 'https://static.swapcampus.local/goods/goods-0072.jpg', 1, '2026-06-11 21:15:20');
INSERT INTO `goods_image` VALUES (73, 'goods-0073', 'https://static.swapcampus.local/goods/goods-0073.jpg', 1, '2026-06-11 21:15:20');
INSERT INTO `goods_image` VALUES (74, 'goods-0074', 'https://static.swapcampus.local/goods/goods-0074.jpg', 1, '2026-06-11 21:15:20');
INSERT INTO `goods_image` VALUES (75, 'goods-0075', 'https://static.swapcampus.local/goods/goods-0075.jpg', 1, '2026-06-11 21:15:20');
INSERT INTO `goods_image` VALUES (76, 'goods-0076', 'https://static.swapcampus.local/goods/goods-0076.jpg', 1, '2026-06-11 21:15:20');
INSERT INTO `goods_image` VALUES (77, 'goods-0077', 'https://static.swapcampus.local/goods/goods-0077.jpg', 1, '2026-06-11 21:15:20');
INSERT INTO `goods_image` VALUES (78, 'goods-0078', 'https://static.swapcampus.local/goods/goods-0078.jpg', 1, '2026-06-11 21:15:20');
INSERT INTO `goods_image` VALUES (79, 'goods-0079', 'https://static.swapcampus.local/goods/goods-0079.jpg', 1, '2026-06-11 21:15:20');
INSERT INTO `goods_image` VALUES (80, 'goods-0080', 'https://static.swapcampus.local/goods/goods-0080.jpg', 1, '2026-06-11 21:15:20');
INSERT INTO `goods_image` VALUES (81, 'goods-0081', 'https://static.swapcampus.local/goods/goods-0081.jpg', 1, '2026-06-11 21:15:20');
INSERT INTO `goods_image` VALUES (82, 'goods-0082', 'https://static.swapcampus.local/goods/goods-0082.jpg', 1, '2026-06-11 21:15:20');
INSERT INTO `goods_image` VALUES (83, 'goods-0083', 'https://static.swapcampus.local/goods/goods-0083.jpg', 1, '2026-06-11 21:15:20');
INSERT INTO `goods_image` VALUES (84, 'goods-0084', 'https://static.swapcampus.local/goods/goods-0084.jpg', 1, '2026-06-11 21:15:20');
INSERT INTO `goods_image` VALUES (85, 'goods-0085', 'https://static.swapcampus.local/goods/goods-0085.jpg', 1, '2026-06-11 21:15:20');
INSERT INTO `goods_image` VALUES (86, 'goods-0086', 'https://static.swapcampus.local/goods/goods-0086.jpg', 1, '2026-06-11 21:15:20');
INSERT INTO `goods_image` VALUES (87, 'goods-0087', 'https://static.swapcampus.local/goods/goods-0087.jpg', 1, '2026-06-11 21:15:20');
INSERT INTO `goods_image` VALUES (88, 'goods-0088', 'https://static.swapcampus.local/goods/goods-0088.jpg', 1, '2026-06-11 21:15:20');
INSERT INTO `goods_image` VALUES (89, 'goods-0089', 'https://static.swapcampus.local/goods/goods-0089.jpg', 1, '2026-06-11 21:15:20');
INSERT INTO `goods_image` VALUES (90, 'goods-0090', 'https://static.swapcampus.local/goods/goods-0090.jpg', 1, '2026-06-11 21:15:20');
INSERT INTO `goods_image` VALUES (91, 'goods-0091', 'https://static.swapcampus.local/goods/goods-0091.jpg', 1, '2026-06-11 21:15:20');
INSERT INTO `goods_image` VALUES (92, 'goods-0092', 'https://static.swapcampus.local/goods/goods-0092.jpg', 1, '2026-06-11 21:15:20');
INSERT INTO `goods_image` VALUES (93, 'goods-0093', 'https://static.swapcampus.local/goods/goods-0093.jpg', 1, '2026-06-11 21:15:20');
INSERT INTO `goods_image` VALUES (94, 'goods-0094', 'https://static.swapcampus.local/goods/goods-0094.jpg', 1, '2026-06-11 21:15:20');
INSERT INTO `goods_image` VALUES (95, 'goods-0095', 'https://static.swapcampus.local/goods/goods-0095.jpg', 1, '2026-06-11 21:15:20');
INSERT INTO `goods_image` VALUES (96, 'goods-0096', 'https://static.swapcampus.local/goods/goods-0096.jpg', 1, '2026-06-11 21:15:20');
INSERT INTO `goods_image` VALUES (97, 'goods-0097', 'https://static.swapcampus.local/goods/goods-0097.jpg', 1, '2026-06-11 21:15:20');
INSERT INTO `goods_image` VALUES (98, 'goods-0098', 'https://static.swapcampus.local/goods/goods-0098.jpg', 1, '2026-06-11 21:15:20');
INSERT INTO `goods_image` VALUES (99, 'goods-0099', 'https://static.swapcampus.local/goods/goods-0099.jpg', 1, '2026-06-11 21:15:20');
INSERT INTO `goods_image` VALUES (100, 'goods-0100', 'https://static.swapcampus.local/goods/goods-0100.jpg', 1, '2026-06-11 21:15:20');
INSERT INTO `goods_image` VALUES (101, 'goods-0101', 'https://static.swapcampus.local/goods/goods-0101.jpg', 1, '2026-06-11 21:15:20');
INSERT INTO `goods_image` VALUES (102, 'goods-0102', 'https://static.swapcampus.local/goods/goods-0102.jpg', 1, '2026-06-11 21:15:20');
INSERT INTO `goods_image` VALUES (103, 'goods-0103', 'https://static.swapcampus.local/goods/goods-0103.jpg', 1, '2026-06-11 21:15:20');
INSERT INTO `goods_image` VALUES (104, 'goods-0104', 'https://static.swapcampus.local/goods/goods-0104.jpg', 1, '2026-06-11 21:15:20');
INSERT INTO `goods_image` VALUES (105, 'goods-0105', 'https://static.swapcampus.local/goods/goods-0105.jpg', 1, '2026-06-11 21:15:20');
INSERT INTO `goods_image` VALUES (106, 'goods-0106', 'https://static.swapcampus.local/goods/goods-0106.jpg', 1, '2026-06-11 21:15:20');
INSERT INTO `goods_image` VALUES (107, 'goods-0107', 'https://static.swapcampus.local/goods/goods-0107.jpg', 1, '2026-06-11 21:15:20');
INSERT INTO `goods_image` VALUES (108, 'goods-0108', 'https://static.swapcampus.local/goods/goods-0108.jpg', 1, '2026-06-11 21:15:20');
INSERT INTO `goods_image` VALUES (109, 'goods-0109', 'https://static.swapcampus.local/goods/goods-0109.jpg', 1, '2026-06-11 21:15:20');
INSERT INTO `goods_image` VALUES (110, 'goods-0110', 'https://static.swapcampus.local/goods/goods-0110.jpg', 1, '2026-06-11 21:15:20');
INSERT INTO `goods_image` VALUES (111, 'goods-0111', 'https://static.swapcampus.local/goods/goods-0111.jpg', 1, '2026-06-11 21:15:20');
INSERT INTO `goods_image` VALUES (112, 'goods-0112', 'https://static.swapcampus.local/goods/goods-0112.jpg', 1, '2026-06-11 21:15:20');
INSERT INTO `goods_image` VALUES (113, 'goods-0113', 'https://static.swapcampus.local/goods/goods-0113.jpg', 1, '2026-06-11 21:15:20');
INSERT INTO `goods_image` VALUES (114, 'goods-0114', 'https://static.swapcampus.local/goods/goods-0114.jpg', 1, '2026-06-11 21:15:20');
INSERT INTO `goods_image` VALUES (115, 'goods-0115', 'https://static.swapcampus.local/goods/goods-0115.jpg', 1, '2026-06-11 21:15:20');
INSERT INTO `goods_image` VALUES (116, 'goods-0116', 'https://static.swapcampus.local/goods/goods-0116.jpg', 1, '2026-06-11 21:15:20');
INSERT INTO `goods_image` VALUES (117, 'goods-0117', 'https://static.swapcampus.local/goods/goods-0117.jpg', 1, '2026-06-11 21:15:20');
INSERT INTO `goods_image` VALUES (118, 'goods-0118', 'https://static.swapcampus.local/goods/goods-0118.jpg', 1, '2026-06-11 21:15:20');
INSERT INTO `goods_image` VALUES (119, 'goods-0119', 'https://static.swapcampus.local/goods/goods-0119.jpg', 1, '2026-06-11 21:15:20');
INSERT INTO `goods_image` VALUES (120, 'goods-0120', 'https://static.swapcampus.local/goods/goods-0120.jpg', 1, '2026-06-11 21:15:20');
INSERT INTO `goods_image` VALUES (121, 'goods-0121', 'https://static.swapcampus.local/goods/goods-0121.jpg', 1, '2026-06-11 21:15:20');
INSERT INTO `goods_image` VALUES (122, 'goods-0122', 'https://static.swapcampus.local/goods/goods-0122.jpg', 1, '2026-06-11 21:15:20');
INSERT INTO `goods_image` VALUES (123, 'goods-0123', 'https://static.swapcampus.local/goods/goods-0123.jpg', 1, '2026-06-11 21:15:20');
INSERT INTO `goods_image` VALUES (124, 'goods-0124', 'https://static.swapcampus.local/goods/goods-0124.jpg', 1, '2026-06-11 21:15:20');
INSERT INTO `goods_image` VALUES (125, 'goods-0125', 'https://static.swapcampus.local/goods/goods-0125.jpg', 1, '2026-06-11 21:15:20');
INSERT INTO `goods_image` VALUES (126, 'goods-0126', 'https://static.swapcampus.local/goods/goods-0126.jpg', 1, '2026-06-11 21:15:20');
INSERT INTO `goods_image` VALUES (127, 'goods-0127', 'https://static.swapcampus.local/goods/goods-0127.jpg', 1, '2026-06-11 21:15:20');
INSERT INTO `goods_image` VALUES (128, 'goods-0128', 'https://static.swapcampus.local/goods/goods-0128.jpg', 1, '2026-06-11 21:15:20');
INSERT INTO `goods_image` VALUES (129, 'goods-0129', 'https://static.swapcampus.local/goods/goods-0129.jpg', 1, '2026-06-11 21:15:20');
INSERT INTO `goods_image` VALUES (130, 'goods-0130', 'https://static.swapcampus.local/goods/goods-0130.jpg', 1, '2026-06-11 21:15:20');
INSERT INTO `goods_image` VALUES (131, 'goods-0131', 'https://static.swapcampus.local/goods/goods-0131.jpg', 1, '2026-06-11 21:15:20');
INSERT INTO `goods_image` VALUES (132, 'goods-0132', 'https://static.swapcampus.local/goods/goods-0132.jpg', 1, '2026-06-11 21:15:20');
INSERT INTO `goods_image` VALUES (133, 'goods-0133', 'https://static.swapcampus.local/goods/goods-0133.jpg', 1, '2026-06-11 21:15:20');
INSERT INTO `goods_image` VALUES (134, 'goods-0134', 'https://static.swapcampus.local/goods/goods-0134.jpg', 1, '2026-06-11 21:15:20');
INSERT INTO `goods_image` VALUES (135, 'goods-0135', 'https://static.swapcampus.local/goods/goods-0135.jpg', 1, '2026-06-11 21:15:20');
INSERT INTO `goods_image` VALUES (136, 'goods-0136', 'https://static.swapcampus.local/goods/goods-0136.jpg', 1, '2026-06-11 21:15:20');
INSERT INTO `goods_image` VALUES (137, 'goods-0137', 'https://static.swapcampus.local/goods/goods-0137.jpg', 1, '2026-06-11 21:15:20');
INSERT INTO `goods_image` VALUES (138, 'goods-0138', 'https://static.swapcampus.local/goods/goods-0138.jpg', 1, '2026-06-11 21:15:20');
INSERT INTO `goods_image` VALUES (139, 'goods-0139', 'https://static.swapcampus.local/goods/goods-0139.jpg', 1, '2026-06-11 21:15:20');
INSERT INTO `goods_image` VALUES (140, 'goods-0140', 'https://static.swapcampus.local/goods/goods-0140.jpg', 1, '2026-06-11 21:15:20');
INSERT INTO `goods_image` VALUES (141, 'goods-0141', 'https://static.swapcampus.local/goods/goods-0141.jpg', 1, '2026-06-11 21:15:20');
INSERT INTO `goods_image` VALUES (142, 'goods-0142', 'https://static.swapcampus.local/goods/goods-0142.jpg', 1, '2026-06-11 21:15:20');
INSERT INTO `goods_image` VALUES (143, 'goods-0143', 'https://static.swapcampus.local/goods/goods-0143.jpg', 1, '2026-06-11 21:15:20');
INSERT INTO `goods_image` VALUES (144, 'goods-0144', 'https://static.swapcampus.local/goods/goods-0144.jpg', 1, '2026-06-11 21:15:20');
INSERT INTO `goods_image` VALUES (145, 'goods-0145', 'https://static.swapcampus.local/goods/goods-0145.jpg', 1, '2026-06-11 21:15:20');
INSERT INTO `goods_image` VALUES (146, 'goods-0146', 'https://static.swapcampus.local/goods/goods-0146.jpg', 1, '2026-06-11 21:15:20');
INSERT INTO `goods_image` VALUES (147, 'goods-0147', 'https://static.swapcampus.local/goods/goods-0147.jpg', 1, '2026-06-11 21:15:20');
INSERT INTO `goods_image` VALUES (148, 'goods-0148', 'https://static.swapcampus.local/goods/goods-0148.jpg', 1, '2026-06-11 21:15:20');
INSERT INTO `goods_image` VALUES (149, 'goods-0149', 'https://static.swapcampus.local/goods/goods-0149.jpg', 1, '2026-06-11 21:15:20');
INSERT INTO `goods_image` VALUES (150, 'goods-0150', 'https://static.swapcampus.local/goods/goods-0150.jpg', 1, '2026-06-11 21:15:20');
INSERT INTO `goods_image` VALUES (151, 'goods-0151', 'https://static.swapcampus.local/goods/goods-0151.jpg', 1, '2026-06-11 21:15:20');
INSERT INTO `goods_image` VALUES (152, 'goods-0152', 'https://static.swapcampus.local/goods/goods-0152.jpg', 1, '2026-06-11 21:15:20');
INSERT INTO `goods_image` VALUES (153, 'goods-0153', 'https://static.swapcampus.local/goods/goods-0153.jpg', 1, '2026-06-11 21:15:20');
INSERT INTO `goods_image` VALUES (154, 'goods-0154', 'https://static.swapcampus.local/goods/goods-0154.jpg', 1, '2026-06-11 21:15:20');
INSERT INTO `goods_image` VALUES (155, 'goods-0155', 'https://static.swapcampus.local/goods/goods-0155.jpg', 1, '2026-06-11 21:15:20');
INSERT INTO `goods_image` VALUES (156, 'goods-0156', 'https://static.swapcampus.local/goods/goods-0156.jpg', 1, '2026-06-11 21:15:20');
INSERT INTO `goods_image` VALUES (157, 'goods-0157', 'https://static.swapcampus.local/goods/goods-0157.jpg', 1, '2026-06-11 21:15:20');
INSERT INTO `goods_image` VALUES (158, 'goods-0158', 'https://static.swapcampus.local/goods/goods-0158.jpg', 1, '2026-06-11 21:15:20');
INSERT INTO `goods_image` VALUES (159, 'goods-0159', 'https://static.swapcampus.local/goods/goods-0159.jpg', 1, '2026-06-11 21:15:20');
INSERT INTO `goods_image` VALUES (160, 'goods-0160', 'https://static.swapcampus.local/goods/goods-0160.jpg', 1, '2026-06-11 21:15:20');
INSERT INTO `goods_image` VALUES (161, 'goods-0161', 'https://static.swapcampus.local/goods/goods-0161.jpg', 1, '2026-06-11 21:15:20');
INSERT INTO `goods_image` VALUES (162, 'goods-0162', 'https://static.swapcampus.local/goods/goods-0162.jpg', 1, '2026-06-11 21:15:20');
INSERT INTO `goods_image` VALUES (163, 'goods-0163', 'https://static.swapcampus.local/goods/goods-0163.jpg', 1, '2026-06-11 21:15:20');
INSERT INTO `goods_image` VALUES (164, 'goods-0164', 'https://static.swapcampus.local/goods/goods-0164.jpg', 1, '2026-06-11 21:15:20');
INSERT INTO `goods_image` VALUES (165, 'goods-0165', 'https://static.swapcampus.local/goods/goods-0165.jpg', 1, '2026-06-11 21:15:20');
INSERT INTO `goods_image` VALUES (166, 'goods-0166', 'https://static.swapcampus.local/goods/goods-0166.jpg', 1, '2026-06-11 21:15:20');
INSERT INTO `goods_image` VALUES (167, 'goods-0167', 'https://static.swapcampus.local/goods/goods-0167.jpg', 1, '2026-06-11 21:15:20');
INSERT INTO `goods_image` VALUES (168, 'goods-0168', 'https://static.swapcampus.local/goods/goods-0168.jpg', 1, '2026-06-11 21:15:20');
INSERT INTO `goods_image` VALUES (169, 'goods-0169', 'https://static.swapcampus.local/goods/goods-0169.jpg', 1, '2026-06-11 21:15:20');
INSERT INTO `goods_image` VALUES (170, 'goods-0170', 'https://static.swapcampus.local/goods/goods-0170.jpg', 1, '2026-06-11 21:15:20');
INSERT INTO `goods_image` VALUES (171, 'goods-0171', 'https://static.swapcampus.local/goods/goods-0171.jpg', 1, '2026-06-11 21:15:20');
INSERT INTO `goods_image` VALUES (172, 'goods-0172', 'https://static.swapcampus.local/goods/goods-0172.jpg', 1, '2026-06-11 21:15:20');
INSERT INTO `goods_image` VALUES (173, 'goods-0173', 'https://static.swapcampus.local/goods/goods-0173.jpg', 1, '2026-06-11 21:15:20');
INSERT INTO `goods_image` VALUES (174, 'goods-0174', 'https://static.swapcampus.local/goods/goods-0174.jpg', 1, '2026-06-11 21:15:20');
INSERT INTO `goods_image` VALUES (175, 'goods-0175', 'https://static.swapcampus.local/goods/goods-0175.jpg', 1, '2026-06-11 21:15:20');
INSERT INTO `goods_image` VALUES (176, 'goods-0176', 'https://static.swapcampus.local/goods/goods-0176.jpg', 1, '2026-06-11 21:15:20');
INSERT INTO `goods_image` VALUES (177, 'goods-0177', 'https://static.swapcampus.local/goods/goods-0177.jpg', 1, '2026-06-11 21:15:20');
INSERT INTO `goods_image` VALUES (178, 'goods-0178', 'https://static.swapcampus.local/goods/goods-0178.jpg', 1, '2026-06-11 21:15:20');
INSERT INTO `goods_image` VALUES (179, 'goods-0179', 'https://static.swapcampus.local/goods/goods-0179.jpg', 1, '2026-06-11 21:15:20');
INSERT INTO `goods_image` VALUES (180, 'goods-0180', 'https://static.swapcampus.local/goods/goods-0180.jpg', 1, '2026-06-11 21:15:20');
INSERT INTO `goods_image` VALUES (181, 'goods-0181', 'https://static.swapcampus.local/goods/goods-0181.jpg', 1, '2026-06-11 21:15:20');
INSERT INTO `goods_image` VALUES (182, 'goods-0182', 'https://static.swapcampus.local/goods/goods-0182.jpg', 1, '2026-06-11 21:15:20');
INSERT INTO `goods_image` VALUES (183, 'goods-0183', 'https://static.swapcampus.local/goods/goods-0183.jpg', 1, '2026-06-11 21:15:20');
INSERT INTO `goods_image` VALUES (184, 'goods-0184', 'https://static.swapcampus.local/goods/goods-0184.jpg', 1, '2026-06-11 21:15:20');
INSERT INTO `goods_image` VALUES (185, 'goods-0185', 'https://static.swapcampus.local/goods/goods-0185.jpg', 1, '2026-06-11 21:15:20');
INSERT INTO `goods_image` VALUES (186, 'goods-0186', 'https://static.swapcampus.local/goods/goods-0186.jpg', 1, '2026-06-11 21:15:20');
INSERT INTO `goods_image` VALUES (187, 'goods-0187', 'https://static.swapcampus.local/goods/goods-0187.jpg', 1, '2026-06-11 21:15:20');
INSERT INTO `goods_image` VALUES (188, 'goods-0188', 'https://static.swapcampus.local/goods/goods-0188.jpg', 1, '2026-06-11 21:15:20');
INSERT INTO `goods_image` VALUES (189, 'goods-0189', 'https://static.swapcampus.local/goods/goods-0189.jpg', 1, '2026-06-11 21:15:20');
INSERT INTO `goods_image` VALUES (190, 'goods-0190', 'https://static.swapcampus.local/goods/goods-0190.jpg', 1, '2026-06-11 21:15:20');
INSERT INTO `goods_image` VALUES (191, 'goods-0191', 'https://static.swapcampus.local/goods/goods-0191.jpg', 1, '2026-06-11 21:15:20');
INSERT INTO `goods_image` VALUES (192, 'goods-0192', 'https://static.swapcampus.local/goods/goods-0192.jpg', 1, '2026-06-11 21:15:20');
INSERT INTO `goods_image` VALUES (193, 'goods-0193', 'https://static.swapcampus.local/goods/goods-0193.jpg', 1, '2026-06-11 21:15:20');
INSERT INTO `goods_image` VALUES (194, 'goods-0194', 'https://static.swapcampus.local/goods/goods-0194.jpg', 1, '2026-06-11 21:15:20');
INSERT INTO `goods_image` VALUES (195, 'goods-0195', 'https://static.swapcampus.local/goods/goods-0195.jpg', 1, '2026-06-11 21:15:20');
INSERT INTO `goods_image` VALUES (196, 'goods-0196', 'https://static.swapcampus.local/goods/goods-0196.jpg', 1, '2026-06-11 21:15:20');
INSERT INTO `goods_image` VALUES (197, 'goods-0197', 'https://static.swapcampus.local/goods/goods-0197.jpg', 1, '2026-06-11 21:15:20');
INSERT INTO `goods_image` VALUES (198, 'goods-0198', 'https://static.swapcampus.local/goods/goods-0198.jpg', 1, '2026-06-11 21:15:20');
INSERT INTO `goods_image` VALUES (199, 'goods-0199', 'https://static.swapcampus.local/goods/goods-0199.jpg', 1, '2026-06-11 21:15:20');
INSERT INTO `goods_image` VALUES (200, 'goods-0200', 'https://static.swapcampus.local/goods/goods-0200.jpg', 1, '2026-06-11 21:15:20');

-- ----------------------------
-- Table structure for message
-- ----------------------------
DROP TABLE IF EXISTS `message`;
CREATE TABLE `message`  (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `uuid` varchar(36) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '消息UUID',
  `sender_id` bigint NOT NULL COMMENT '发送者ID',
  `receiver_id` bigint NOT NULL COMMENT '接收者ID',
  `goods_uuid` varchar(36) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '关联商品UUID',
  `content` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '消息内容',
  `msg_type` varchar(16) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'TEXT' COMMENT '消息类型: TEXT, IMAGE, SYSTEM',
  `is_read` tinyint NOT NULL DEFAULT 0 COMMENT '是否已读',
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `uuid`(`uuid` ASC) USING BTREE,
  INDEX `idx_sender`(`sender_id` ASC) USING BTREE,
  INDEX `idx_receiver`(`receiver_id` ASC) USING BTREE,
  INDEX `idx_goods`(`goods_uuid` ASC) USING BTREE,
  INDEX `idx_created`(`created_at` ASC) USING BTREE,
  CONSTRAINT `message_ibfk_1` FOREIGN KEY (`sender_id`) REFERENCES `user` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT `message_ibfk_2` FOREIGN KEY (`receiver_id`) REFERENCES `user` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 266 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '消息表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of message
-- ----------------------------
INSERT INTO `message` VALUES (1, 'msg-0001', 3, 2, 'goods-0001', '你好，这本高数教材还在吗？', 'TEXT', 1, '2026-04-13 01:41:22');
INSERT INTO `message` VALUES (2, 'msg-0002', 2, 3, 'goods-0001', '还在，可以东校区面交。', 'TEXT', 1, '2026-04-13 03:20:22');
INSERT INTO `message` VALUES (3, 'msg-0003', 4, 3, 'goods-0002', '耳机续航大概多久？', 'TEXT', 1, '2026-04-13 04:34:22');
INSERT INTO `message` VALUES (4, 'msg-0004', 3, 4, 'goods-0002', '正常使用 4-5 小时。', 'TEXT', 0, '2026-04-13 06:13:22');
INSERT INTO `message` VALUES (5, 'msg-0005', 2, 6, 'goods-0005', '外套尺码偏大还是偏小？', 'TEXT', 1, '2026-04-13 07:52:22');
INSERT INTO `message` VALUES (6, 'msg-0006', 6, 2, 'goods-0005', '正常尺码，M 码。', 'TEXT', 1, '2026-04-13 09:06:22');
INSERT INTO `message` VALUES (7, 'msg-0007', 5, 10, 'goods-0009', '机械键盘是什么轴？', 'TEXT', 1, '2026-04-13 10:45:22');
INSERT INTO `message` VALUES (8, 'msg-0008', 10, 5, 'goods-0009', '红轴，适合宿舍安静使用。', 'TEXT', 1, '2026-04-13 12:24:22');
INSERT INTO `message` VALUES (9, 'msg-0009', 11, 9, 'goods-0058', '键鼠套装支持笔记本吗？', 'TEXT', 0, '2026-04-13 13:38:22');
INSERT INTO `message` VALUES (10, 'msg-0010', 9, 11, 'goods-0058', '支持 USB 接口。', 'TEXT', 0, '2026-04-13 15:17:22');
INSERT INTO `message` VALUES (11, 'msg-0011', 2, 7, 'goods-0141', '还在的，可以校内面交。', 'TEXT', 1, '2026-04-13 16:56:22');
INSERT INTO `message` VALUES (12, 'msg-0012', 8, 7, 'goods-0156', '请问成色和描述一致吗？', 'TEXT', 0, '2026-04-13 18:10:22');
INSERT INTO `message` VALUES (13, 'msg-0013', 93, 25, 'goods-0013', '基本一致，可以现场看实物。', 'TEXT', 1, '2026-04-13 19:49:22');
INSERT INTO `message` VALUES (14, 'msg-0014', 42, 100, 'goods-0014', '价格还能再优惠一点吗？', 'TEXT', 1, '2026-04-13 21:03:22');
INSERT INTO `message` VALUES (15, 'msg-0015', 8, 59, 'goods-0015', '可以小刀，具体见面聊。', 'TEXT', 1, '2026-04-13 22:42:22');
INSERT INTO `message` VALUES (16, 'msg-0016', 76, 15, 'goods-0016', '请问在哪里交易比较方便？', 'TEXT', 0, '2026-04-14 00:21:22');
INSERT INTO `message` VALUES (17, 'msg-0017', 22, 93, 'goods-0017', '图书馆门口或者宿舍楼下都可以。', 'TEXT', 1, '2026-04-14 01:35:22');
INSERT INTO `message` VALUES (18, 'msg-0018', 11, 29, 'goods-0018', '好的，我下单后联系你。', 'TEXT', 1, '2026-04-14 03:14:22');
INSERT INTO `message` VALUES (19, 'msg-0019', 36, 28, 'goods-0019', '收到，稍后确认交易时间。', 'TEXT', 1, '2026-04-14 04:53:22');
INSERT INTO `message` VALUES (20, 'msg-0020', 45, 43, 'goods-0020', '你好，请问这个商品还在吗？', 'TEXT', 0, '2026-04-14 06:07:22');
INSERT INTO `message` VALUES (21, 'msg-0021', 50, 62, 'goods-0021', '还在的，可以校内面交。', 'TEXT', 1, '2026-04-14 07:46:22');
INSERT INTO `message` VALUES (22, 'msg-0022', 79, 57, 'goods-0022', '请问成色和描述一致吗？', 'TEXT', 1, '2026-04-14 09:25:22');
INSERT INTO `message` VALUES (23, 'msg-0023', 64, 96, 'goods-0023', '基本一致，可以现场看实物。', 'TEXT', 1, '2026-04-14 10:39:22');
INSERT INTO `message` VALUES (24, 'msg-0024', 14, 71, 'goods-0024', '价格还能再优惠一点吗？', 'TEXT', 0, '2026-04-14 12:18:22');
INSERT INTO `message` VALUES (25, 'msg-0025', 78, 31, 'goods-0025', '可以小刀，具体见面聊。', 'TEXT', 1, '2026-04-14 13:32:22');
INSERT INTO `message` VALUES (26, 'msg-0026', 48, 85, 'goods-0026', '请问在哪里交易比较方便？', 'TEXT', 1, '2026-04-14 15:11:22');
INSERT INTO `message` VALUES (27, 'msg-0027', 92, 65, 'goods-0027', '图书馆门口或者宿舍楼下都可以。', 'TEXT', 1, '2026-04-14 16:50:22');
INSERT INTO `message` VALUES (28, 'msg-0028', 82, 99, 'goods-0028', '好的，我下单后联系你。', 'TEXT', 0, '2026-04-14 18:04:22');
INSERT INTO `message` VALUES (29, 'msg-0029', 7, 99, 'goods-0029', '收到，稍后确认交易时间。', 'TEXT', 1, '2026-04-14 19:43:22');
INSERT INTO `message` VALUES (30, 'msg-0030', 17, 14, 'goods-0030', '你好，请问这个商品还在吗？', 'TEXT', 1, '2026-04-14 21:22:22');
INSERT INTO `message` VALUES (31, 'msg-0031', 21, 34, 'goods-0031', '还在的，可以校内面交。', 'TEXT', 1, '2026-04-14 22:36:22');
INSERT INTO `message` VALUES (32, 'msg-0032', 51, 28, 'goods-0032', '请问成色和描述一致吗？', 'TEXT', 0, '2026-04-15 00:15:22');
INSERT INTO `message` VALUES (33, 'msg-0033', 35, 68, 'goods-0033', '基本一致，可以现场看实物。', 'TEXT', 1, '2026-04-15 01:54:22');
INSERT INTO `message` VALUES (34, 'msg-0034', 85, 42, 'goods-0034', '价格还能再优惠一点吗？', 'TEXT', 1, '2026-04-15 03:08:22');
INSERT INTO `message` VALUES (35, 'msg-0035', 49, 3, 'goods-0035', '可以小刀，具体见面聊。', 'TEXT', 1, '2026-04-15 04:47:22');
INSERT INTO `message` VALUES (36, 'msg-0036', 20, 56, 'goods-0036', '请问在哪里交易比较方便？', 'TEXT', 0, '2026-04-15 06:26:22');
INSERT INTO `message` VALUES (37, 'msg-0037', 63, 37, 'goods-0037', '图书馆门口或者宿舍楼下都可以。', 'TEXT', 1, '2026-04-15 07:40:22');
INSERT INTO `message` VALUES (38, 'msg-0038', 54, 70, 'goods-0038', '好的，我下单后联系你。', 'TEXT', 1, '2026-04-15 09:19:22');
INSERT INTO `message` VALUES (39, 'msg-0039', 77, 71, 'goods-0039', '收到，稍后确认交易时间。', 'TEXT', 1, '2026-04-15 10:33:22');
INSERT INTO `message` VALUES (40, 'msg-0040', 88, 84, 'goods-0040', '你好，请问这个商品还在吗？', 'TEXT', 0, '2026-04-15 12:12:22');
INSERT INTO `message` VALUES (41, 'msg-0041', 91, 6, 'goods-0041', '还在的，可以校内面交。', 'TEXT', 1, '2026-04-15 13:51:22');
INSERT INTO `message` VALUES (42, 'msg-0042', 23, 98, 'goods-0042', '请问成色和描述一致吗？', 'TEXT', 1, '2026-04-15 15:05:22');
INSERT INTO `message` VALUES (43, 'msg-0043', 6, 40, 'goods-0043', '基本一致，可以现场看实物。', 'TEXT', 1, '2026-04-15 16:44:22');
INSERT INTO `message` VALUES (44, 'msg-0044', 57, 13, 'goods-0044', '价格还能再优惠一点吗？', 'TEXT', 0, '2026-04-15 18:23:22');
INSERT INTO `message` VALUES (45, 'msg-0045', 20, 74, 'goods-0045', '可以小刀，具体见面聊。', 'TEXT', 1, '2026-04-15 19:37:22');
INSERT INTO `message` VALUES (46, 'msg-0046', 91, 27, 'goods-0046', '请问在哪里交易比较方便？', 'TEXT', 1, '2026-04-15 21:16:22');
INSERT INTO `message` VALUES (47, 'msg-0047', 34, 9, 'goods-0047', '图书馆门口或者宿舍楼下都可以。', 'TEXT', 1, '2026-04-15 22:55:22');
INSERT INTO `message` VALUES (48, 'msg-0048', 26, 41, 'goods-0048', '好的，我下单后联系你。', 'TEXT', 0, '2026-04-16 00:09:22');
INSERT INTO `message` VALUES (49, 'msg-0049', 48, 43, 'goods-0049', '收到，稍后确认交易时间。', 'TEXT', 1, '2026-04-16 01:48:22');
INSERT INTO `message` VALUES (50, 'msg-0050', 60, 55, 'goods-0050', '你好，请问这个商品还在吗？', 'TEXT', 1, '2026-04-16 03:02:22');
INSERT INTO `message` VALUES (51, 'msg-0051', 2, 3, 'goods-0001', '还在的，可以校内面交。', 'TEXT', 1, '2026-04-16 04:41:22');
INSERT INTO `message` VALUES (52, 'msg-0052', 4, 3, 'goods-0002', '请问成色和描述一致吗？', 'TEXT', 0, '2026-04-16 06:20:22');
INSERT INTO `message` VALUES (53, 'msg-0053', 6, 2, 'goods-0005', '基本一致，可以现场看实物。', 'TEXT', 1, '2026-04-16 07:34:22');
INSERT INTO `message` VALUES (54, 'msg-0054', 5, 10, 'goods-0009', '价格还能再优惠一点吗？', 'TEXT', 1, '2026-04-16 09:13:22');
INSERT INTO `message` VALUES (55, 'msg-0055', 5, 6, 'goods-0014', '可以小刀，具体见面聊。', 'TEXT', 1, '2026-04-16 10:52:22');
INSERT INTO `message` VALUES (56, 'msg-0056', 7, 10, 'goods-0019', '请问在哪里交易比较方便？', 'TEXT', 0, '2026-04-16 12:06:22');
INSERT INTO `message` VALUES (57, 'msg-0057', 8, 2, 'goods-0037', '图书馆门口或者宿舍楼下都可以。', 'TEXT', 1, '2026-04-16 13:45:22');
INSERT INTO `message` VALUES (58, 'msg-0058', 11, 9, 'goods-0058', '好的，我下单后联系你。', 'TEXT', 1, '2026-04-16 15:24:22');
INSERT INTO `message` VALUES (59, 'msg-0059', 9, 4, 'goods-0078', '收到，稍后确认交易时间。', 'TEXT', 1, '2026-04-16 16:38:22');
INSERT INTO `message` VALUES (60, 'msg-0060', 3, 6, 'goods-0085', '你好，请问这个商品还在吗？', 'TEXT', 0, '2026-04-16 18:17:22');
INSERT INTO `message` VALUES (61, 'msg-0061', 2, 7, 'goods-0141', '还在的，可以校内面交。', 'TEXT', 1, '2026-04-16 19:56:22');
INSERT INTO `message` VALUES (62, 'msg-0062', 8, 7, 'goods-0156', '请问成色和描述一致吗？', 'TEXT', 1, '2026-04-16 21:10:22');
INSERT INTO `message` VALUES (63, 'msg-0063', 93, 25, 'goods-0013', '基本一致，可以现场看实物。', 'TEXT', 1, '2026-04-16 22:49:22');
INSERT INTO `message` VALUES (64, 'msg-0064', 42, 100, 'goods-0014', '价格还能再优惠一点吗？', 'TEXT', 0, '2026-04-17 00:03:22');
INSERT INTO `message` VALUES (65, 'msg-0065', 8, 59, 'goods-0015', '可以小刀，具体见面聊。', 'TEXT', 1, '2026-04-17 01:42:22');
INSERT INTO `message` VALUES (66, 'msg-0066', 76, 15, 'goods-0016', '请问在哪里交易比较方便？', 'TEXT', 1, '2026-04-17 03:21:22');
INSERT INTO `message` VALUES (67, 'msg-0067', 22, 93, 'goods-0017', '图书馆门口或者宿舍楼下都可以。', 'TEXT', 1, '2026-04-17 04:35:22');
INSERT INTO `message` VALUES (68, 'msg-0068', 11, 29, 'goods-0018', '好的，我下单后联系你。', 'TEXT', 0, '2026-04-17 06:14:22');
INSERT INTO `message` VALUES (69, 'msg-0069', 36, 28, 'goods-0019', '收到，稍后确认交易时间。', 'TEXT', 1, '2026-04-17 07:53:22');
INSERT INTO `message` VALUES (70, 'msg-0070', 45, 43, 'goods-0020', '你好，请问这个商品还在吗？', 'TEXT', 1, '2026-04-17 09:07:22');
INSERT INTO `message` VALUES (71, 'msg-0071', 50, 62, 'goods-0021', '还在的，可以校内面交。', 'TEXT', 1, '2026-04-17 10:46:22');
INSERT INTO `message` VALUES (72, 'msg-0072', 79, 57, 'goods-0022', '请问成色和描述一致吗？', 'TEXT', 0, '2026-04-17 12:25:22');
INSERT INTO `message` VALUES (73, 'msg-0073', 64, 96, 'goods-0023', '基本一致，可以现场看实物。', 'TEXT', 1, '2026-04-17 13:39:22');
INSERT INTO `message` VALUES (74, 'msg-0074', 14, 71, 'goods-0024', '价格还能再优惠一点吗？', 'TEXT', 1, '2026-04-17 15:18:22');
INSERT INTO `message` VALUES (75, 'msg-0075', 78, 31, 'goods-0025', '可以小刀，具体见面聊。', 'TEXT', 1, '2026-04-17 16:32:22');
INSERT INTO `message` VALUES (76, 'msg-0076', 48, 85, 'goods-0026', '请问在哪里交易比较方便？', 'TEXT', 0, '2026-04-17 18:11:22');
INSERT INTO `message` VALUES (77, 'msg-0077', 92, 65, 'goods-0027', '图书馆门口或者宿舍楼下都可以。', 'TEXT', 1, '2026-04-17 19:50:22');
INSERT INTO `message` VALUES (78, 'msg-0078', 82, 99, 'goods-0028', '好的，我下单后联系你。', 'TEXT', 1, '2026-04-17 21:04:22');
INSERT INTO `message` VALUES (79, 'msg-0079', 7, 99, 'goods-0029', '收到，稍后确认交易时间。', 'TEXT', 1, '2026-04-17 22:43:22');
INSERT INTO `message` VALUES (80, 'msg-0080', 17, 14, 'goods-0030', '你好，请问这个商品还在吗？', 'TEXT', 0, '2026-04-18 00:22:22');
INSERT INTO `message` VALUES (81, 'msg-0081', 21, 34, 'goods-0031', '还在的，可以校内面交。', 'TEXT', 1, '2026-04-18 01:36:22');
INSERT INTO `message` VALUES (82, 'msg-0082', 51, 28, 'goods-0032', '请问成色和描述一致吗？', 'TEXT', 1, '2026-04-18 03:15:22');
INSERT INTO `message` VALUES (83, 'msg-0083', 35, 68, 'goods-0033', '基本一致，可以现场看实物。', 'TEXT', 1, '2026-04-18 04:54:22');
INSERT INTO `message` VALUES (84, 'msg-0084', 85, 42, 'goods-0034', '价格还能再优惠一点吗？', 'TEXT', 0, '2026-04-18 06:08:22');
INSERT INTO `message` VALUES (85, 'msg-0085', 49, 3, 'goods-0035', '可以小刀，具体见面聊。', 'TEXT', 1, '2026-04-18 07:47:22');
INSERT INTO `message` VALUES (86, 'msg-0086', 20, 56, 'goods-0036', '请问在哪里交易比较方便？', 'TEXT', 1, '2026-04-18 09:26:22');
INSERT INTO `message` VALUES (87, 'msg-0087', 63, 37, 'goods-0037', '图书馆门口或者宿舍楼下都可以。', 'TEXT', 1, '2026-04-18 10:40:22');
INSERT INTO `message` VALUES (88, 'msg-0088', 54, 70, 'goods-0038', '好的，我下单后联系你。', 'TEXT', 0, '2026-04-18 12:19:22');
INSERT INTO `message` VALUES (89, 'msg-0089', 77, 71, 'goods-0039', '收到，稍后确认交易时间。', 'TEXT', 1, '2026-04-18 13:33:22');
INSERT INTO `message` VALUES (90, 'msg-0090', 88, 84, 'goods-0040', '你好，请问这个商品还在吗？', 'TEXT', 1, '2026-04-18 15:12:22');
INSERT INTO `message` VALUES (91, 'msg-0091', 91, 6, 'goods-0041', '还在的，可以校内面交。', 'TEXT', 1, '2026-04-18 16:51:22');
INSERT INTO `message` VALUES (92, 'msg-0092', 23, 98, 'goods-0042', '请问成色和描述一致吗？', 'TEXT', 0, '2026-04-18 18:05:22');
INSERT INTO `message` VALUES (93, 'msg-0093', 6, 40, 'goods-0043', '基本一致，可以现场看实物。', 'TEXT', 1, '2026-04-18 19:44:22');
INSERT INTO `message` VALUES (94, 'msg-0094', 57, 13, 'goods-0044', '价格还能再优惠一点吗？', 'TEXT', 1, '2026-04-18 21:23:22');
INSERT INTO `message` VALUES (95, 'msg-0095', 20, 74, 'goods-0045', '可以小刀，具体见面聊。', 'TEXT', 1, '2026-04-18 22:37:22');
INSERT INTO `message` VALUES (96, 'msg-0096', 91, 27, 'goods-0046', '请问在哪里交易比较方便？', 'TEXT', 0, '2026-04-19 00:16:22');
INSERT INTO `message` VALUES (97, 'msg-0097', 34, 9, 'goods-0047', '图书馆门口或者宿舍楼下都可以。', 'TEXT', 1, '2026-04-19 01:55:22');
INSERT INTO `message` VALUES (98, 'msg-0098', 26, 41, 'goods-0048', '好的，我下单后联系你。', 'TEXT', 1, '2026-04-19 03:09:22');
INSERT INTO `message` VALUES (99, 'msg-0099', 48, 43, 'goods-0049', '收到，稍后确认交易时间。', 'TEXT', 1, '2026-04-19 04:48:22');
INSERT INTO `message` VALUES (100, 'msg-0100', 60, 55, 'goods-0050', '你好，请问这个商品还在吗？', 'TEXT', 0, '2026-04-19 06:02:22');
INSERT INTO `message` VALUES (101, 'msg-0101', 2, 3, 'goods-0001', '还在的，可以校内面交。', 'TEXT', 1, '2026-04-19 07:41:22');
INSERT INTO `message` VALUES (102, 'msg-0102', 4, 3, 'goods-0002', '请问成色和描述一致吗？', 'TEXT', 1, '2026-04-19 09:20:22');
INSERT INTO `message` VALUES (103, 'msg-0103', 6, 2, 'goods-0005', '基本一致，可以现场看实物。', 'TEXT', 1, '2026-04-19 10:34:22');
INSERT INTO `message` VALUES (104, 'msg-0104', 5, 10, 'goods-0009', '价格还能再优惠一点吗？', 'TEXT', 0, '2026-04-19 12:13:22');
INSERT INTO `message` VALUES (105, 'msg-0105', 5, 6, 'goods-0014', '可以小刀，具体见面聊。', 'TEXT', 1, '2026-04-19 13:52:22');
INSERT INTO `message` VALUES (106, 'msg-0106', 7, 10, 'goods-0019', '请问在哪里交易比较方便？', 'TEXT', 1, '2026-04-19 15:06:22');
INSERT INTO `message` VALUES (107, 'msg-0107', 8, 2, 'goods-0037', '图书馆门口或者宿舍楼下都可以。', 'TEXT', 1, '2026-04-19 16:45:22');
INSERT INTO `message` VALUES (108, 'msg-0108', 11, 9, 'goods-0058', '好的，我下单后联系你。', 'TEXT', 0, '2026-04-19 18:24:22');
INSERT INTO `message` VALUES (109, 'msg-0109', 9, 4, 'goods-0078', '收到，稍后确认交易时间。', 'TEXT', 1, '2026-04-19 19:38:22');
INSERT INTO `message` VALUES (110, 'msg-0110', 3, 6, 'goods-0085', '你好，请问这个商品还在吗？', 'TEXT', 1, '2026-04-19 21:17:22');
INSERT INTO `message` VALUES (111, 'msg-0111', 2, 7, 'goods-0141', '还在的，可以校内面交。', 'TEXT', 1, '2026-04-19 22:56:22');
INSERT INTO `message` VALUES (112, 'msg-0112', 8, 7, 'goods-0156', '请问成色和描述一致吗？', 'TEXT', 0, '2026-04-20 00:10:22');
INSERT INTO `message` VALUES (113, 'msg-0113', 93, 25, 'goods-0013', '基本一致，可以现场看实物。', 'TEXT', 1, '2026-04-20 01:49:22');
INSERT INTO `message` VALUES (114, 'msg-0114', 42, 100, 'goods-0014', '价格还能再优惠一点吗？', 'TEXT', 1, '2026-04-20 03:03:22');
INSERT INTO `message` VALUES (115, 'msg-0115', 8, 59, 'goods-0015', '可以小刀，具体见面聊。', 'TEXT', 1, '2026-04-20 04:42:22');
INSERT INTO `message` VALUES (116, 'msg-0116', 76, 15, 'goods-0016', '请问在哪里交易比较方便？', 'TEXT', 0, '2026-04-20 06:21:22');
INSERT INTO `message` VALUES (117, 'msg-0117', 22, 93, 'goods-0017', '图书馆门口或者宿舍楼下都可以。', 'TEXT', 1, '2026-04-20 07:35:22');
INSERT INTO `message` VALUES (118, 'msg-0118', 11, 29, 'goods-0018', '好的，我下单后联系你。', 'TEXT', 1, '2026-04-20 09:14:22');
INSERT INTO `message` VALUES (119, 'msg-0119', 36, 28, 'goods-0019', '收到，稍后确认交易时间。', 'TEXT', 1, '2026-04-20 10:53:22');
INSERT INTO `message` VALUES (120, 'msg-0120', 45, 43, 'goods-0020', '你好，请问这个商品还在吗？', 'TEXT', 0, '2026-04-20 12:07:22');
INSERT INTO `message` VALUES (121, 'msg-0121', 50, 62, 'goods-0021', '还在的，可以校内面交。', 'TEXT', 1, '2026-04-20 13:46:22');
INSERT INTO `message` VALUES (122, 'msg-0122', 79, 57, 'goods-0022', '请问成色和描述一致吗？', 'TEXT', 1, '2026-04-20 15:25:22');
INSERT INTO `message` VALUES (123, 'msg-0123', 64, 96, 'goods-0023', '基本一致，可以现场看实物。', 'TEXT', 1, '2026-04-20 16:39:22');
INSERT INTO `message` VALUES (124, 'msg-0124', 14, 71, 'goods-0024', '价格还能再优惠一点吗？', 'TEXT', 0, '2026-04-20 18:18:22');
INSERT INTO `message` VALUES (125, 'msg-0125', 78, 31, 'goods-0025', '可以小刀，具体见面聊。', 'TEXT', 1, '2026-04-20 19:32:22');
INSERT INTO `message` VALUES (126, 'msg-0126', 48, 85, 'goods-0026', '请问在哪里交易比较方便？', 'TEXT', 1, '2026-04-20 21:11:22');
INSERT INTO `message` VALUES (127, 'msg-0127', 92, 65, 'goods-0027', '图书馆门口或者宿舍楼下都可以。', 'TEXT', 1, '2026-04-20 22:50:22');
INSERT INTO `message` VALUES (128, 'msg-0128', 82, 99, 'goods-0028', '好的，我下单后联系你。', 'TEXT', 0, '2026-04-21 00:04:22');
INSERT INTO `message` VALUES (129, 'msg-0129', 7, 99, 'goods-0029', '收到，稍后确认交易时间。', 'TEXT', 1, '2026-04-21 01:43:22');
INSERT INTO `message` VALUES (130, 'msg-0130', 17, 14, 'goods-0030', '你好，请问这个商品还在吗？', 'TEXT', 1, '2026-04-21 03:22:22');
INSERT INTO `message` VALUES (131, 'msg-0131', 21, 34, 'goods-0031', '还在的，可以校内面交。', 'TEXT', 1, '2026-04-21 04:36:22');
INSERT INTO `message` VALUES (132, 'msg-0132', 51, 28, 'goods-0032', '请问成色和描述一致吗？', 'TEXT', 0, '2026-04-21 06:15:22');
INSERT INTO `message` VALUES (133, 'msg-0133', 35, 68, 'goods-0033', '基本一致，可以现场看实物。', 'TEXT', 1, '2026-04-21 07:54:22');
INSERT INTO `message` VALUES (134, 'msg-0134', 85, 42, 'goods-0034', '价格还能再优惠一点吗？', 'TEXT', 1, '2026-04-21 09:08:22');
INSERT INTO `message` VALUES (135, 'msg-0135', 49, 3, 'goods-0035', '可以小刀，具体见面聊。', 'TEXT', 1, '2026-04-21 10:47:22');
INSERT INTO `message` VALUES (136, 'msg-0136', 20, 56, 'goods-0036', '请问在哪里交易比较方便？', 'TEXT', 0, '2026-04-21 12:26:22');
INSERT INTO `message` VALUES (137, 'msg-0137', 63, 37, 'goods-0037', '图书馆门口或者宿舍楼下都可以。', 'TEXT', 1, '2026-04-21 13:40:22');
INSERT INTO `message` VALUES (138, 'msg-0138', 54, 70, 'goods-0038', '好的，我下单后联系你。', 'TEXT', 1, '2026-04-21 15:19:22');
INSERT INTO `message` VALUES (139, 'msg-0139', 77, 71, 'goods-0039', '收到，稍后确认交易时间。', 'TEXT', 1, '2026-04-21 16:33:22');
INSERT INTO `message` VALUES (140, 'msg-0140', 88, 84, 'goods-0040', '你好，请问这个商品还在吗？', 'TEXT', 0, '2026-04-21 18:12:22');
INSERT INTO `message` VALUES (141, 'msg-0141', 91, 6, 'goods-0041', '还在的，可以校内面交。', 'TEXT', 1, '2026-04-21 19:51:22');
INSERT INTO `message` VALUES (142, 'msg-0142', 23, 98, 'goods-0042', '请问成色和描述一致吗？', 'TEXT', 1, '2026-04-21 21:05:22');
INSERT INTO `message` VALUES (143, 'msg-0143', 6, 40, 'goods-0043', '基本一致，可以现场看实物。', 'TEXT', 1, '2026-04-21 22:44:22');
INSERT INTO `message` VALUES (144, 'msg-0144', 57, 13, 'goods-0044', '价格还能再优惠一点吗？', 'TEXT', 0, '2026-04-22 00:23:22');
INSERT INTO `message` VALUES (145, 'msg-0145', 20, 74, 'goods-0045', '可以小刀，具体见面聊。', 'TEXT', 1, '2026-04-22 01:37:22');
INSERT INTO `message` VALUES (146, 'msg-0146', 91, 27, 'goods-0046', '请问在哪里交易比较方便？', 'TEXT', 1, '2026-04-22 03:16:22');
INSERT INTO `message` VALUES (147, 'msg-0147', 34, 9, 'goods-0047', '图书馆门口或者宿舍楼下都可以。', 'TEXT', 1, '2026-04-22 04:55:22');
INSERT INTO `message` VALUES (148, 'msg-0148', 26, 41, 'goods-0048', '好的，我下单后联系你。', 'TEXT', 0, '2026-04-22 06:09:22');
INSERT INTO `message` VALUES (149, 'msg-0149', 48, 43, 'goods-0049', '收到，稍后确认交易时间。', 'TEXT', 1, '2026-04-22 07:48:22');
INSERT INTO `message` VALUES (150, 'msg-0150', 60, 55, 'goods-0050', '你好，请问这个商品还在吗？', 'TEXT', 1, '2026-04-22 09:02:22');
INSERT INTO `message` VALUES (151, 'msg-0151', 2, 3, 'goods-0001', '还在的，可以校内面交。', 'TEXT', 1, '2026-04-22 10:41:22');
INSERT INTO `message` VALUES (152, 'msg-0152', 4, 3, 'goods-0002', '请问成色和描述一致吗？', 'TEXT', 0, '2026-04-22 12:20:22');
INSERT INTO `message` VALUES (153, 'msg-0153', 6, 2, 'goods-0005', '基本一致，可以现场看实物。', 'TEXT', 1, '2026-04-22 13:34:22');
INSERT INTO `message` VALUES (154, 'msg-0154', 5, 10, 'goods-0009', '价格还能再优惠一点吗？', 'TEXT', 1, '2026-04-22 15:13:22');
INSERT INTO `message` VALUES (155, 'msg-0155', 5, 6, 'goods-0014', '可以小刀，具体见面聊。', 'TEXT', 1, '2026-04-22 16:52:22');
INSERT INTO `message` VALUES (156, 'msg-0156', 7, 10, 'goods-0019', '请问在哪里交易比较方便？', 'TEXT', 0, '2026-04-22 18:06:22');
INSERT INTO `message` VALUES (157, 'msg-0157', 8, 2, 'goods-0037', '图书馆门口或者宿舍楼下都可以。', 'TEXT', 1, '2026-04-22 19:45:22');
INSERT INTO `message` VALUES (158, 'msg-0158', 11, 9, 'goods-0058', '好的，我下单后联系你。', 'TEXT', 1, '2026-04-22 21:24:22');
INSERT INTO `message` VALUES (159, 'msg-0159', 9, 4, 'goods-0078', '收到，稍后确认交易时间。', 'TEXT', 1, '2026-04-22 22:38:22');
INSERT INTO `message` VALUES (160, 'msg-0160', 3, 6, 'goods-0085', '你好，请问这个商品还在吗？', 'TEXT', 0, '2026-04-23 00:17:22');

-- ----------------------------
-- Table structure for notification
-- ----------------------------
DROP TABLE IF EXISTS `notification`;
CREATE TABLE `notification`  (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `user_id` bigint NOT NULL,
  `title` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `content` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `is_read` tinyint NOT NULL DEFAULT 0,
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_user_read`(`user_id` ASC, `is_read` ASC) USING BTREE,
  CONSTRAINT `notification_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `user` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 133 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '通知表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of notification
-- ----------------------------
INSERT INTO `notification` VALUES (1, 2, '商品审核通过', '你发布的商品 goods-0001 已通过审核并上架。', 0, '2026-05-13 04:32:22');
INSERT INTO `notification` VALUES (2, 3, '收到新消息', '你有一条新的站内消息，请及时查看。', 0, '2026-05-13 08:02:22');
INSERT INTO `notification` VALUES (3, 4, '订单状态更新', '你的订单 order-0002 已进入进行中状态。', 0, '2026-05-13 12:32:22');
INSERT INTO `notification` VALUES (4, 5, '举报处理结果', '你提交的举报已处理，请在举报中心查看结果。', 1, '2026-05-13 16:02:22');
INSERT INTO `notification` VALUES (5, 6, '商品已售出', '你发布的商品 goods-0005 已完成交易。', 1, '2026-05-13 20:32:22');
INSERT INTO `notification` VALUES (6, 12, '订单状态更新', '你的订单状态发生变化，请及时查看并确认交易安排。', 1, '2026-05-14 00:02:22');
INSERT INTO `notification` VALUES (7, 23, '收到新的站内消息', '你收到一条新的站内消息，请及时回复对方。', 1, '2026-05-14 04:32:22');
INSERT INTO `notification` VALUES (8, 34, '举报处理结果', '你提交或涉及的举报已有处理进展，请查看处理结果。', 0, '2026-05-14 08:02:22');
INSERT INTO `notification` VALUES (9, 45, '收藏商品提醒', '你收藏的商品近期有新的交易动态。', 1, '2026-05-14 12:32:22');
INSERT INTO `notification` VALUES (10, 56, '交易完成提醒', '交易已完成，欢迎对本次交易进行评价。', 1, '2026-05-14 16:02:22');
INSERT INTO `notification` VALUES (11, 67, '账号安全提醒', '请注意保护账号安全，不要泄露个人登录信息。', 0, '2026-05-14 20:32:22');
INSERT INTO `notification` VALUES (12, 78, '系统公告', '平台近期更新了校园闲置交易相关功能，欢迎体验。', 1, '2026-05-15 00:02:22');
INSERT INTO `notification` VALUES (13, 89, '商品审核通知', '你发布的商品状态已更新，请前往个人中心查看详情。', 1, '2026-05-15 04:32:22');
INSERT INTO `notification` VALUES (14, 100, '订单状态更新', '你的订单状态发生变化，请及时查看并确认交易安排。', 0, '2026-05-15 08:02:22');
INSERT INTO `notification` VALUES (15, 11, '收到新的站内消息', '你收到一条新的站内消息，请及时回复对方。', 1, '2026-05-15 12:32:22');
INSERT INTO `notification` VALUES (16, 22, '举报处理结果', '你提交或涉及的举报已有处理进展，请查看处理结果。', 1, '2026-05-15 16:02:22');
INSERT INTO `notification` VALUES (17, 33, '收藏商品提醒', '你收藏的商品近期有新的交易动态。', 0, '2026-05-15 20:32:22');
INSERT INTO `notification` VALUES (18, 44, '交易完成提醒', '交易已完成，欢迎对本次交易进行评价。', 1, '2026-05-16 00:02:22');
INSERT INTO `notification` VALUES (19, 55, '账号安全提醒', '请注意保护账号安全，不要泄露个人登录信息。', 1, '2026-05-16 04:32:22');
INSERT INTO `notification` VALUES (20, 66, '系统公告', '平台近期更新了校园闲置交易相关功能，欢迎体验。', 0, '2026-05-16 08:02:22');
INSERT INTO `notification` VALUES (21, 77, '商品审核通知', '你发布的商品状态已更新，请前往个人中心查看详情。', 1, '2026-05-16 12:32:22');
INSERT INTO `notification` VALUES (22, 88, '订单状态更新', '你的订单状态发生变化，请及时查看并确认交易安排。', 1, '2026-05-16 16:02:22');
INSERT INTO `notification` VALUES (23, 99, '收到新的站内消息', '你收到一条新的站内消息，请及时回复对方。', 0, '2026-05-16 20:32:22');
INSERT INTO `notification` VALUES (24, 10, '举报处理结果', '你提交或涉及的举报已有处理进展，请查看处理结果。', 1, '2026-05-17 00:02:22');
INSERT INTO `notification` VALUES (25, 21, '收藏商品提醒', '你收藏的商品近期有新的交易动态。', 1, '2026-05-17 04:32:22');
INSERT INTO `notification` VALUES (26, 32, '交易完成提醒', '交易已完成，欢迎对本次交易进行评价。', 0, '2026-05-17 08:02:22');
INSERT INTO `notification` VALUES (27, 43, '账号安全提醒', '请注意保护账号安全，不要泄露个人登录信息。', 1, '2026-05-17 12:32:22');
INSERT INTO `notification` VALUES (28, 54, '系统公告', '平台近期更新了校园闲置交易相关功能，欢迎体验。', 1, '2026-05-17 16:02:22');
INSERT INTO `notification` VALUES (29, 65, '商品审核通知', '你发布的商品状态已更新，请前往个人中心查看详情。', 0, '2026-05-17 20:32:22');
INSERT INTO `notification` VALUES (30, 76, '订单状态更新', '你的订单状态发生变化，请及时查看并确认交易安排。', 1, '2026-05-18 00:02:22');
INSERT INTO `notification` VALUES (31, 87, '收到新的站内消息', '你收到一条新的站内消息，请及时回复对方。', 1, '2026-05-18 04:32:22');
INSERT INTO `notification` VALUES (32, 98, '举报处理结果', '你提交或涉及的举报已有处理进展，请查看处理结果。', 0, '2026-05-18 08:02:22');
INSERT INTO `notification` VALUES (33, 9, '收藏商品提醒', '你收藏的商品近期有新的交易动态。', 1, '2026-05-18 12:32:22');
INSERT INTO `notification` VALUES (34, 20, '交易完成提醒', '交易已完成，欢迎对本次交易进行评价。', 1, '2026-05-18 16:02:22');
INSERT INTO `notification` VALUES (35, 31, '账号安全提醒', '请注意保护账号安全，不要泄露个人登录信息。', 0, '2026-05-18 20:32:22');
INSERT INTO `notification` VALUES (36, 42, '系统公告', '平台近期更新了校园闲置交易相关功能，欢迎体验。', 1, '2026-05-19 00:02:22');
INSERT INTO `notification` VALUES (37, 53, '商品审核通知', '你发布的商品状态已更新，请前往个人中心查看详情。', 1, '2026-05-19 04:32:22');
INSERT INTO `notification` VALUES (38, 64, '订单状态更新', '你的订单状态发生变化，请及时查看并确认交易安排。', 0, '2026-05-19 08:02:22');
INSERT INTO `notification` VALUES (39, 75, '收到新的站内消息', '你收到一条新的站内消息，请及时回复对方。', 1, '2026-05-19 12:32:22');
INSERT INTO `notification` VALUES (40, 86, '举报处理结果', '你提交或涉及的举报已有处理进展，请查看处理结果。', 1, '2026-05-19 16:02:22');
INSERT INTO `notification` VALUES (41, 97, '收藏商品提醒', '你收藏的商品近期有新的交易动态。', 0, '2026-05-19 20:32:22');
INSERT INTO `notification` VALUES (42, 8, '交易完成提醒', '交易已完成，欢迎对本次交易进行评价。', 1, '2026-05-20 00:02:22');
INSERT INTO `notification` VALUES (43, 19, '账号安全提醒', '请注意保护账号安全，不要泄露个人登录信息。', 1, '2026-05-20 04:32:22');
INSERT INTO `notification` VALUES (44, 30, '系统公告', '平台近期更新了校园闲置交易相关功能，欢迎体验。', 0, '2026-05-20 08:02:22');
INSERT INTO `notification` VALUES (45, 41, '商品审核通知', '你发布的商品状态已更新，请前往个人中心查看详情。', 1, '2026-05-20 12:32:22');
INSERT INTO `notification` VALUES (46, 52, '订单状态更新', '你的订单状态发生变化，请及时查看并确认交易安排。', 1, '2026-05-20 16:02:22');
INSERT INTO `notification` VALUES (47, 63, '收到新的站内消息', '你收到一条新的站内消息，请及时回复对方。', 0, '2026-05-20 20:32:22');
INSERT INTO `notification` VALUES (48, 74, '举报处理结果', '你提交或涉及的举报已有处理进展，请查看处理结果。', 1, '2026-05-21 00:02:22');
INSERT INTO `notification` VALUES (49, 85, '收藏商品提醒', '你收藏的商品近期有新的交易动态。', 1, '2026-05-21 04:32:22');
INSERT INTO `notification` VALUES (50, 96, '交易完成提醒', '交易已完成，欢迎对本次交易进行评价。', 0, '2026-05-21 08:02:22');
INSERT INTO `notification` VALUES (51, 7, '账号安全提醒', '请注意保护账号安全，不要泄露个人登录信息。', 1, '2026-05-21 12:32:22');
INSERT INTO `notification` VALUES (52, 18, '系统公告', '平台近期更新了校园闲置交易相关功能，欢迎体验。', 1, '2026-05-21 16:02:22');
INSERT INTO `notification` VALUES (53, 29, '商品审核通知', '你发布的商品状态已更新，请前往个人中心查看详情。', 0, '2026-05-21 20:32:22');
INSERT INTO `notification` VALUES (54, 40, '订单状态更新', '你的订单状态发生变化，请及时查看并确认交易安排。', 1, '2026-05-22 00:02:22');
INSERT INTO `notification` VALUES (55, 51, '收到新的站内消息', '你收到一条新的站内消息，请及时回复对方。', 1, '2026-05-22 04:32:22');
INSERT INTO `notification` VALUES (56, 62, '举报处理结果', '你提交或涉及的举报已有处理进展，请查看处理结果。', 0, '2026-05-22 08:02:22');
INSERT INTO `notification` VALUES (57, 73, '收藏商品提醒', '你收藏的商品近期有新的交易动态。', 1, '2026-05-22 12:32:22');
INSERT INTO `notification` VALUES (58, 84, '交易完成提醒', '交易已完成，欢迎对本次交易进行评价。', 1, '2026-05-22 16:02:22');
INSERT INTO `notification` VALUES (59, 95, '账号安全提醒', '请注意保护账号安全，不要泄露个人登录信息。', 0, '2026-05-22 20:32:22');
INSERT INTO `notification` VALUES (60, 6, '系统公告', '平台近期更新了校园闲置交易相关功能，欢迎体验。', 1, '2026-05-23 00:02:22');
INSERT INTO `notification` VALUES (61, 17, '商品审核通知', '你发布的商品状态已更新，请前往个人中心查看详情。', 1, '2026-05-23 04:32:22');
INSERT INTO `notification` VALUES (62, 28, '订单状态更新', '你的订单状态发生变化，请及时查看并确认交易安排。', 0, '2026-05-23 08:02:22');
INSERT INTO `notification` VALUES (63, 39, '收到新的站内消息', '你收到一条新的站内消息，请及时回复对方。', 1, '2026-05-23 12:32:22');
INSERT INTO `notification` VALUES (64, 50, '举报处理结果', '你提交或涉及的举报已有处理进展，请查看处理结果。', 1, '2026-05-23 16:02:22');
INSERT INTO `notification` VALUES (65, 61, '收藏商品提醒', '你收藏的商品近期有新的交易动态。', 0, '2026-05-23 20:32:22');
INSERT INTO `notification` VALUES (66, 72, '交易完成提醒', '交易已完成，欢迎对本次交易进行评价。', 1, '2026-05-24 00:02:22');
INSERT INTO `notification` VALUES (67, 83, '账号安全提醒', '请注意保护账号安全，不要泄露个人登录信息。', 1, '2026-05-24 04:32:22');
INSERT INTO `notification` VALUES (68, 94, '系统公告', '平台近期更新了校园闲置交易相关功能，欢迎体验。', 0, '2026-05-24 08:02:22');
INSERT INTO `notification` VALUES (69, 5, '商品审核通知', '你发布的商品状态已更新，请前往个人中心查看详情。', 1, '2026-05-24 12:32:22');
INSERT INTO `notification` VALUES (70, 16, '订单状态更新', '你的订单状态发生变化，请及时查看并确认交易安排。', 1, '2026-05-24 16:02:22');
INSERT INTO `notification` VALUES (71, 27, '收到新的站内消息', '你收到一条新的站内消息，请及时回复对方。', 0, '2026-05-24 20:32:22');
INSERT INTO `notification` VALUES (72, 38, '举报处理结果', '你提交或涉及的举报已有处理进展，请查看处理结果。', 1, '2026-05-25 00:02:22');
INSERT INTO `notification` VALUES (73, 49, '收藏商品提醒', '你收藏的商品近期有新的交易动态。', 1, '2026-05-25 04:32:22');
INSERT INTO `notification` VALUES (74, 60, '交易完成提醒', '交易已完成，欢迎对本次交易进行评价。', 0, '2026-05-25 08:02:22');
INSERT INTO `notification` VALUES (75, 71, '账号安全提醒', '请注意保护账号安全，不要泄露个人登录信息。', 1, '2026-05-25 12:32:22');
INSERT INTO `notification` VALUES (76, 82, '系统公告', '平台近期更新了校园闲置交易相关功能，欢迎体验。', 1, '2026-05-25 16:02:22');
INSERT INTO `notification` VALUES (77, 93, '商品审核通知', '你发布的商品状态已更新，请前往个人中心查看详情。', 0, '2026-05-25 20:32:22');
INSERT INTO `notification` VALUES (78, 4, '订单状态更新', '你的订单状态发生变化，请及时查看并确认交易安排。', 1, '2026-05-26 00:02:22');
INSERT INTO `notification` VALUES (79, 15, '收到新的站内消息', '你收到一条新的站内消息，请及时回复对方。', 1, '2026-05-26 04:32:22');
INSERT INTO `notification` VALUES (80, 26, '举报处理结果', '你提交或涉及的举报已有处理进展，请查看处理结果。', 0, '2026-05-26 08:02:22');
INSERT INTO `notification` VALUES (81, 37, '收藏商品提醒', '你收藏的商品近期有新的交易动态。', 1, '2026-05-26 12:32:22');
INSERT INTO `notification` VALUES (82, 48, '交易完成提醒', '交易已完成，欢迎对本次交易进行评价。', 1, '2026-05-26 16:02:22');
INSERT INTO `notification` VALUES (83, 59, '账号安全提醒', '请注意保护账号安全，不要泄露个人登录信息。', 0, '2026-05-26 20:32:22');
INSERT INTO `notification` VALUES (84, 70, '系统公告', '平台近期更新了校园闲置交易相关功能，欢迎体验。', 1, '2026-05-27 00:02:22');
INSERT INTO `notification` VALUES (85, 81, '商品审核通知', '你发布的商品状态已更新，请前往个人中心查看详情。', 1, '2026-05-27 04:32:22');
INSERT INTO `notification` VALUES (86, 92, '订单状态更新', '你的订单状态发生变化，请及时查看并确认交易安排。', 0, '2026-05-27 08:02:22');
INSERT INTO `notification` VALUES (87, 3, '收到新的站内消息', '你收到一条新的站内消息，请及时回复对方。', 1, '2026-05-27 12:32:22');
INSERT INTO `notification` VALUES (88, 14, '举报处理结果', '你提交或涉及的举报已有处理进展，请查看处理结果。', 1, '2026-05-27 16:02:22');
INSERT INTO `notification` VALUES (89, 25, '收藏商品提醒', '你收藏的商品近期有新的交易动态。', 0, '2026-05-27 20:32:22');
INSERT INTO `notification` VALUES (90, 36, '交易完成提醒', '交易已完成，欢迎对本次交易进行评价。', 1, '2026-05-28 00:02:22');
INSERT INTO `notification` VALUES (91, 47, '账号安全提醒', '请注意保护账号安全，不要泄露个人登录信息。', 1, '2026-05-28 04:32:22');
INSERT INTO `notification` VALUES (92, 58, '系统公告', '平台近期更新了校园闲置交易相关功能，欢迎体验。', 0, '2026-05-28 08:02:22');
INSERT INTO `notification` VALUES (93, 69, '商品审核通知', '你发布的商品状态已更新，请前往个人中心查看详情。', 1, '2026-05-28 12:32:22');
INSERT INTO `notification` VALUES (94, 80, '订单状态更新', '你的订单状态发生变化，请及时查看并确认交易安排。', 1, '2026-05-28 16:02:22');
INSERT INTO `notification` VALUES (95, 91, '收到新的站内消息', '你收到一条新的站内消息，请及时回复对方。', 0, '2026-05-28 20:32:22');
INSERT INTO `notification` VALUES (96, 2, '举报处理结果', '你提交或涉及的举报已有处理进展，请查看处理结果。', 1, '2026-05-29 00:02:22');
INSERT INTO `notification` VALUES (97, 13, '收藏商品提醒', '你收藏的商品近期有新的交易动态。', 1, '2026-05-29 04:32:22');
INSERT INTO `notification` VALUES (98, 24, '交易完成提醒', '交易已完成，欢迎对本次交易进行评价。', 0, '2026-05-29 08:02:22');
INSERT INTO `notification` VALUES (99, 35, '账号安全提醒', '请注意保护账号安全，不要泄露个人登录信息。', 1, '2026-05-29 12:32:22');
INSERT INTO `notification` VALUES (100, 46, '系统公告', '平台近期更新了校园闲置交易相关功能，欢迎体验。', 1, '2026-05-29 16:02:22');
INSERT INTO `notification` VALUES (101, 57, '商品审核通知', '你发布的商品状态已更新，请前往个人中心查看详情。', 0, '2026-05-29 20:32:22');
INSERT INTO `notification` VALUES (102, 68, '订单状态更新', '你的订单状态发生变化，请及时查看并确认交易安排。', 1, '2026-05-30 00:02:22');
INSERT INTO `notification` VALUES (103, 79, '收到新的站内消息', '你收到一条新的站内消息，请及时回复对方。', 1, '2026-05-30 04:32:22');
INSERT INTO `notification` VALUES (104, 90, '举报处理结果', '你提交或涉及的举报已有处理进展，请查看处理结果。', 0, '2026-05-30 08:02:22');
INSERT INTO `notification` VALUES (105, 1, '收藏商品提醒', '你收藏的商品近期有新的交易动态。', 1, '2026-05-30 12:32:22');
INSERT INTO `notification` VALUES (106, 12, '交易完成提醒', '交易已完成，欢迎对本次交易进行评价。', 1, '2026-05-30 16:02:22');
INSERT INTO `notification` VALUES (107, 23, '账号安全提醒', '请注意保护账号安全，不要泄露个人登录信息。', 0, '2026-05-30 20:32:22');
INSERT INTO `notification` VALUES (108, 34, '系统公告', '平台近期更新了校园闲置交易相关功能，欢迎体验。', 1, '2026-05-31 00:02:22');
INSERT INTO `notification` VALUES (109, 45, '商品审核通知', '你发布的商品状态已更新，请前往个人中心查看详情。', 1, '2026-05-31 04:32:22');
INSERT INTO `notification` VALUES (110, 56, '订单状态更新', '你的订单状态发生变化，请及时查看并确认交易安排。', 0, '2026-05-31 08:02:22');
INSERT INTO `notification` VALUES (111, 67, '收到新的站内消息', '你收到一条新的站内消息，请及时回复对方。', 1, '2026-05-31 12:32:22');
INSERT INTO `notification` VALUES (112, 78, '举报处理结果', '你提交或涉及的举报已有处理进展，请查看处理结果。', 1, '2026-05-31 16:02:22');
INSERT INTO `notification` VALUES (113, 89, '收藏商品提醒', '你收藏的商品近期有新的交易动态。', 0, '2026-05-31 20:32:22');
INSERT INTO `notification` VALUES (114, 100, '交易完成提醒', '交易已完成，欢迎对本次交易进行评价。', 1, '2026-06-01 00:02:22');
INSERT INTO `notification` VALUES (115, 11, '账号安全提醒', '请注意保护账号安全，不要泄露个人登录信息。', 1, '2026-06-01 04:32:22');
INSERT INTO `notification` VALUES (116, 22, '系统公告', '平台近期更新了校园闲置交易相关功能，欢迎体验。', 0, '2026-06-01 08:02:22');
INSERT INTO `notification` VALUES (117, 33, '商品审核通知', '你发布的商品状态已更新，请前往个人中心查看详情。', 1, '2026-06-01 12:32:22');
INSERT INTO `notification` VALUES (118, 44, '订单状态更新', '你的订单状态发生变化，请及时查看并确认交易安排。', 1, '2026-06-01 16:02:22');
INSERT INTO `notification` VALUES (119, 55, '收到新的站内消息', '你收到一条新的站内消息，请及时回复对方。', 0, '2026-06-01 20:32:22');
INSERT INTO `notification` VALUES (120, 66, '举报处理结果', '你提交或涉及的举报已有处理进展，请查看处理结果。', 1, '2026-06-02 00:02:22');
INSERT INTO `notification` VALUES (121, 77, '收藏商品提醒', '你收藏的商品近期有新的交易动态。', 1, '2026-06-02 04:32:22');
INSERT INTO `notification` VALUES (122, 88, '交易完成提醒', '交易已完成，欢迎对本次交易进行评价。', 0, '2026-06-02 08:02:22');
INSERT INTO `notification` VALUES (123, 99, '账号安全提醒', '请注意保护账号安全，不要泄露个人登录信息。', 1, '2026-06-02 12:32:22');
INSERT INTO `notification` VALUES (124, 10, '系统公告', '平台近期更新了校园闲置交易相关功能，欢迎体验。', 1, '2026-06-02 16:02:22');
INSERT INTO `notification` VALUES (125, 21, '商品审核通知', '你发布的商品状态已更新，请前往个人中心查看详情。', 0, '2026-06-02 20:32:22');

-- ----------------------------
-- Table structure for orders
-- ----------------------------
DROP TABLE IF EXISTS `orders`;
CREATE TABLE `orders`  (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `uuid` varchar(36) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '订单号',
  `goods_uuid` varchar(36) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '商品UUID',
  `buyer_id` bigint NOT NULL COMMENT '买家ID',
  `seller_id` bigint NOT NULL COMMENT '卖家ID',
  `amount` decimal(10, 2) NOT NULL COMMENT '成交金额',
  `trade_method` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '交易方式',
  `meet_location` varchar(256) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '面交地点',
  `meet_time` datetime NULL DEFAULT NULL COMMENT '面交时间',
  `buyer_confirm` tinyint NOT NULL DEFAULT 0 COMMENT '买家确认: 0未确认, 1已确认',
  `seller_confirm` tinyint NOT NULL DEFAULT 0 COMMENT '卖家确认: 0未确认, 1已确认',
  `status` tinyint NOT NULL DEFAULT 0 COMMENT '状态: -1已取消, 0待确认, 1进行中, 2已完成, 3退货中',
  `buyer_rating` tinyint NULL DEFAULT NULL COMMENT '买家评分(1-5)',
  `buyer_review` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL COMMENT '买家评价',
  `completed_at` datetime NULL DEFAULT NULL COMMENT '完成时间',
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `uuid`(`uuid` ASC) USING BTREE,
  INDEX `goods_uuid`(`goods_uuid` ASC) USING BTREE,
  INDEX `idx_uuid`(`uuid` ASC) USING BTREE,
  INDEX `idx_buyer`(`buyer_id` ASC) USING BTREE,
  INDEX `idx_seller`(`seller_id` ASC) USING BTREE,
  INDEX `idx_status`(`status` ASC) USING BTREE,
  CONSTRAINT `orders_ibfk_1` FOREIGN KEY (`goods_uuid`) REFERENCES `goods` (`uuid`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT `orders_ibfk_2` FOREIGN KEY (`buyer_id`) REFERENCES `user` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT `orders_ibfk_3` FOREIGN KEY (`seller_id`) REFERENCES `user` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 77 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '订单表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of orders
-- ----------------------------
INSERT INTO `orders` VALUES (1, 'order-0001', 'goods-0001', 3, 2, 18.00, 'FACE', '东校区图书馆门口', '2026-06-12 21:00:00', 0, 1, 0, NULL, NULL, NULL, '2026-04-03 08:02:22', '2026-04-03 17:02:22');
INSERT INTO `orders` VALUES (2, 'order-0002', 'goods-0002', 4, 3, 79.00, 'BOTH', '西校区宿舍楼下', '2026-06-13 11:30:00', 0, 1, 1, NULL, NULL, NULL, '2026-04-03 16:02:22', '2026-04-04 08:02:22');
INSERT INTO `orders` VALUES (3, 'order-0003', 'goods-0005', 2, 6, 42.00, 'FACE', '东校区食堂门口', '2026-06-09 18:00:00', 1, 1, 2, 5, '商品成色很好，交易顺利', '2026-06-09 19:02:22', '2026-04-04 00:02:22', '2026-06-12 15:41:16');
INSERT INTO `orders` VALUES (4, 'order-0004', 'goods-0009', 5, 10, 95.00, 'BOTH', '东校区教学楼', '2026-06-08 12:00:00', 1, 1, 2, 4, '使用正常，卖家回复及时', '2026-06-18 14:02:22', '2026-04-04 08:02:22', '2026-06-12 15:39:38');
INSERT INTO `orders` VALUES (5, 'order-0005', 'goods-0014', 6, 5, 26.00, 'LOCKER', '西校区快递柜', '2026-06-12 21:30:00', 0, 0, 0, NULL, NULL, NULL, '2026-04-04 16:02:22', '2026-04-06 05:02:22');
INSERT INTO `orders` VALUES (6, 'order-0006', 'goods-0019', 7, 10, 36.00, 'BOTH', '南校区操场门口', '2026-06-14 08:00:00', 0, 1, 1, NULL, NULL, NULL, '2026-04-05 00:02:22', '2026-04-06 20:02:22');
INSERT INTO `orders` VALUES (7, 'order-0007', 'goods-0037', 2, 8, 68.00, 'BOTH', '东校区宿舍楼下', '2026-06-07 20:30:00', 1, 1, 2, 5, '音箱效果不错', '2026-06-07 23:02:22', '2026-04-05 08:02:22', '2026-06-12 15:39:55');
INSERT INTO `orders` VALUES (8, 'order-0008', 'goods-0058', 11, 9, 52.00, 'BOTH', '西校区教学楼', '2026-06-13 09:30:00', 0, 1, 1, NULL, NULL, NULL, '2026-04-05 16:02:22', '2026-04-08 02:02:22');
INSERT INTO `orders` VALUES (9, 'order-0009', 'goods-0078', 4, 9, 20.00, 'FACE', '西校区图书馆', '2026-06-09 22:00:00', 1, 1, 2, 4, '教材完整', '2026-06-09 23:02:22', '2026-04-06 00:02:22', '2026-06-12 15:40:07');
INSERT INTO `orders` VALUES (10, 'order-0010', 'goods-0085', 3, 6, 21.00, 'FACE', '东校区教学楼', '2026-06-13 17:30:00', 0, 0, 0, NULL, NULL, NULL, '2026-04-06 08:02:22', '2026-04-09 08:02:22');
INSERT INTO `orders` VALUES (11, 'order-0011', 'goods-0141', 7, 2, 25.00, 'FACE', '东校区图书馆门口', '2026-06-06 10:00:00', 1, 1, 2, 5, '书况很好', '2026-06-06 17:02:22', '2026-04-06 16:02:22', '2026-06-12 15:40:41');
INSERT INTO `orders` VALUES (12, 'order-0012', 'goods-0156', 8, 7, 168.00, 'BOTH', '北校区宿舍楼', '2026-06-13 21:00:00', 0, 1, 1, NULL, NULL, NULL, '2026-04-07 00:02:22', '2026-04-07 14:02:22');
INSERT INTO `orders` VALUES (13, 'order-0013', 'goods-0013', 25, 93, 16.00, 'FACE', '西校区操场入口', '2026-05-20 13:30:00', 1, 1, 2, 4, '价格合适，校园面交很安全。', '2026-05-20 17:02:22', '2026-04-07 08:02:22', '2026-06-12 15:40:55');
INSERT INTO `orders` VALUES (14, 'order-0014', 'goods-0014', 42, 100, 26.00, 'LOCKER', '南校区实验楼门口', '2026-06-05 18:00:00', 1, 1, 2, 5, '体验不错，下次还会继续使用平台。', '2026-06-05 20:02:22', '2026-04-07 16:02:22', '2026-06-12 15:41:08');
INSERT INTO `orders` VALUES (15, 'order-0015', 'goods-0015', 59, 8, 20.00, 'FACE', '北校区主楼大厅', '2026-06-06 11:30:00', 1, 1, 2, 3, '交易顺利，商品和描述一致。', '2026-06-06 21:02:22', '2026-04-08 00:02:22', '2026-06-12 15:41:29');
INSERT INTO `orders` VALUES (16, 'order-0016', 'goods-0016', 76, 15, 120.00, 'BOTH', '东校区图书馆门口', '2026-06-02 16:00:00', 1, 1, 2, 4, '卖家回复及时，面交很方便。', '2026-06-02 16:02:22', '2026-04-08 08:02:22', '2026-06-12 15:41:42');
INSERT INTO `orders` VALUES (17, 'order-0017', 'goods-0017', 93, 22, 10.00, 'FACE', '西校区宿舍楼下', '2026-05-29 09:30:00', 1, 1, 2, 5, '物品保存较好，整体满意。', '2026-05-29 11:02:22', '2026-04-08 16:02:22', '2026-06-12 15:41:53');
INSERT INTO `orders` VALUES (18, 'order-0018', 'goods-0018', 11, 29, 28.00, 'FACE', '南校区食堂门口', '2026-05-25 14:00:00', 1, 1, 2, 3, '价格合适，校园面交很安全。', '2026-05-25 16:02:22', '2026-04-09 00:02:22', '2026-06-12 15:42:09');
INSERT INTO `orders` VALUES (19, 'order-0019', 'goods-0019', 28, 36, 36.00, 'BOTH', '北校区教学楼大厅', '2026-05-21 19:30:00', 1, 1, 2, 4, '体验不错，下次还会继续使用平台。', '2026-05-21 20:02:22', '2026-04-09 08:02:22', '2026-06-12 15:42:22');
INSERT INTO `orders` VALUES (20, 'order-0020', 'goods-0020', 45, 43, 14.00, 'FACE', '东校区快递柜', '2026-06-11 12:00:00', 1, 1, 2, 5, '交易顺利，商品和描述一致。', '2026-06-11 20:02:22', '2026-04-09 16:02:22', '2026-06-12 15:42:29');
INSERT INTO `orders` VALUES (21, 'order-0021', 'goods-0021', 62, 50, 18.00, 'LOCKER', '西校区操场入口', '2026-06-13 17:30:00', 1, 1, 1, NULL, NULL, NULL, '2026-04-10 00:02:22', '2026-04-10 05:02:22');
INSERT INTO `orders` VALUES (22, 'order-0022', 'goods-0022', 79, 57, 21.00, 'FACE', '南校区实验楼门口', '2026-06-11 10:00:00', 0, 1, 1, NULL, NULL, NULL, '2026-04-10 08:02:22', '2026-04-10 20:02:22');
INSERT INTO `orders` VALUES (23, 'order-0023', 'goods-0023', 96, 64, 25.00, 'BOTH', '北校区主楼大厅', '2026-06-09 15:30:00', 1, 1, 1, NULL, NULL, NULL, '2026-04-10 16:02:22', '2026-04-11 11:02:22');
INSERT INTO `orders` VALUES (24, 'order-0024', 'goods-0024', 14, 71, 11.00, 'FACE', '东校区图书馆门口', '2026-06-30 08:00:00', 0, 1, 1, NULL, NULL, NULL, '2026-04-11 00:02:22', '2026-06-12 15:44:20');
INSERT INTO `orders` VALUES (25, 'order-0025', 'goods-0025', 31, 78, 9.00, 'FACE', '西校区宿舍楼下', '2026-06-28 13:30:00', 1, 1, 1, NULL, NULL, NULL, '2026-04-11 08:02:22', '2026-06-12 15:44:24');
INSERT INTO `orders` VALUES (26, 'order-0026', 'goods-0026', 48, 85, 17.00, 'BOTH', '南校区食堂门口', '2026-06-26 18:00:00', 0, 1, 1, NULL, NULL, NULL, '2026-04-11 16:02:22', '2026-06-12 15:44:28');
INSERT INTO `orders` VALUES (27, 'order-0027', 'goods-0027', 65, 92, 23.00, 'FACE', '北校区教学楼大厅', '2026-06-13 11:30:00', 1, 1, 1, NULL, NULL, NULL, '2026-04-12 00:02:22', '2026-04-13 23:02:22');
INSERT INTO `orders` VALUES (28, 'order-0028', 'goods-0028', 82, 99, 13.00, 'LOCKER', '东校区快递柜', '2026-06-11 16:00:00', 0, 1, 1, NULL, NULL, NULL, '2026-04-12 08:02:22', '2026-04-14 14:02:22');
INSERT INTO `orders` VALUES (29, 'order-0029', 'goods-0029', 99, 7, 19.00, 'FACE', '西校区操场入口', '2026-06-09 09:30:00', 1, 1, 1, NULL, NULL, NULL, '2026-04-12 16:02:22', '2026-04-15 05:02:22');
INSERT INTO `orders` VALUES (30, 'order-0030', 'goods-0030', 17, 14, 15.00, 'BOTH', '南校区实验楼门口', '2026-06-07 14:00:00', 0, 1, 1, NULL, NULL, NULL, '2026-04-13 00:02:22', '2026-04-15 20:02:22');
INSERT INTO `orders` VALUES (31, 'order-0031', 'goods-0031', 34, 21, 12.00, 'FACE', '北校区主楼大厅', '2026-06-05 19:30:00', 1, 1, 1, NULL, NULL, NULL, '2026-04-13 08:02:22', '2026-04-13 11:02:22');
INSERT INTO `orders` VALUES (32, 'order-0032', 'goods-0032', 51, 28, 39.00, 'FACE', '东校区图书馆门口', '2026-06-26 12:00:00', 0, 1, 1, NULL, NULL, NULL, '2026-04-13 16:02:22', '2026-06-12 15:44:31');
INSERT INTO `orders` VALUES (33, 'order-0033', 'goods-0033', 68, 35, 45.00, 'BOTH', '西校区宿舍楼下', '2026-06-24 17:30:00', 1, 1, 1, NULL, NULL, NULL, '2026-04-14 00:02:22', '2026-06-12 15:44:36');
INSERT INTO `orders` VALUES (34, 'order-0034', 'goods-0034', 85, 42, 26.00, 'FACE', '南校区食堂门口', '2026-06-11 10:00:00', 0, 1, 1, NULL, NULL, NULL, '2026-04-14 08:02:22', '2026-04-15 08:02:22');
INSERT INTO `orders` VALUES (35, 'order-0035', 'goods-0035', 3, 49, 18.00, 'LOCKER', '北校区教学楼大厅', '2026-06-09 15:30:00', 1, 1, 1, NULL, NULL, NULL, '2026-04-14 16:02:22', '2026-04-15 23:02:22');
INSERT INTO `orders` VALUES (36, 'order-0036', 'goods-0036', 20, 56, 18.00, 'FACE', '东校区快递柜', '2026-06-07 08:00:00', 0, 0, 0, NULL, NULL, NULL, '2026-04-15 00:02:22', '2026-04-16 14:02:22');
INSERT INTO `orders` VALUES (37, 'order-0037', 'goods-0037', 37, 63, 68.00, 'BOTH', '西校区操场入口', '2026-06-05 13:30:00', 0, 0, 0, NULL, NULL, NULL, '2026-04-15 08:02:22', '2026-04-17 05:02:22');
INSERT INTO `orders` VALUES (38, 'order-0038', 'goods-0038', 54, 70, 14.00, 'FACE', '南校区实验楼门口', '2026-06-03 18:00:00', 0, 0, 0, NULL, NULL, NULL, '2026-04-15 16:02:22', '2026-04-17 20:02:22');
INSERT INTO `orders` VALUES (39, 'order-0039', 'goods-0039', 71, 77, 32.00, 'FACE', '北校区主楼大厅', '2026-06-01 11:30:00', 0, 0, 0, NULL, NULL, NULL, '2026-04-16 00:02:22', '2026-04-18 11:02:22');
INSERT INTO `orders` VALUES (40, 'order-0040', 'goods-0040', 88, 84, 33.00, 'BOTH', '东校区图书馆门口', '2026-06-11 16:00:00', 0, 0, 0, NULL, NULL, NULL, '2026-04-16 08:02:22', '2026-04-19 02:02:22');
INSERT INTO `orders` VALUES (41, 'order-0041', 'goods-0041', 6, 91, 20.00, 'FACE', '西校区宿舍楼下', '2026-06-09 09:30:00', 0, 0, 0, NULL, NULL, NULL, '2026-04-16 16:02:22', '2026-04-19 17:02:22');
INSERT INTO `orders` VALUES (42, 'order-0042', 'goods-0042', 23, 98, 29.00, 'LOCKER', '南校区食堂门口', '2026-06-07 14:00:00', 0, 0, 0, NULL, NULL, NULL, '2026-04-17 00:02:22', '2026-04-17 08:02:22');
INSERT INTO `orders` VALUES (43, 'order-0043', 'goods-0043', 40, 6, 17.00, 'FACE', '北校区教学楼大厅', '2026-06-05 19:30:00', 0, 0, 0, NULL, NULL, NULL, '2026-04-17 08:02:22', '2026-04-17 23:02:22');
INSERT INTO `orders` VALUES (44, 'order-0044', 'goods-0044', 57, 13, 36.00, 'BOTH', '东校区快递柜', '2026-06-03 12:00:00', 0, 0, 0, NULL, NULL, NULL, '2026-04-17 16:02:22', '2026-04-18 14:02:22');
INSERT INTO `orders` VALUES (45, 'order-0045', 'goods-0045', 74, 20, 16.00, 'FACE', '西校区操场入口', '2026-06-01 17:30:00', 0, 0, 0, NULL, NULL, NULL, '2026-04-18 00:02:22', '2026-04-19 05:02:22');
INSERT INTO `orders` VALUES (46, 'order-0046', 'goods-0046', 91, 27, 10.00, 'FACE', '南校区实验楼门口', '2026-06-30 10:00:00', 0, 0, -1, NULL, NULL, NULL, '2026-04-18 08:02:22', '2026-06-12 15:44:45');
INSERT INTO `orders` VALUES (47, 'order-0047', 'goods-0047', 9, 34, 13.00, 'BOTH', '北校区主楼大厅', '2026-06-17 15:30:00', 0, 0, -1, NULL, NULL, NULL, '2026-04-18 16:02:22', '2026-04-20 11:02:22');
INSERT INTO `orders` VALUES (48, 'order-0048', 'goods-0048', 26, 41, 24.00, 'FACE', '东校区图书馆门口', '2026-06-07 08:00:00', 0, 0, -1, NULL, NULL, NULL, '2026-04-19 00:02:22', '2026-04-21 02:02:22');
INSERT INTO `orders` VALUES (49, 'order-0049', 'goods-0049', 43, 48, 8.00, 'LOCKER', '西校区宿舍楼下', '2026-06-05 13:30:00', 0, 0, -1, NULL, NULL, NULL, '2026-04-19 08:02:22', '2026-04-21 17:02:22');
INSERT INTO `orders` VALUES (50, 'order-0050', 'goods-0050', 60, 55, 22.00, 'FACE', '南校区食堂门口', '2026-06-03 18:00:00', 0, 0, -1, NULL, NULL, NULL, '2026-04-19 16:02:22', '2026-04-22 08:02:22');

-- ----------------------------
-- Table structure for report
-- ----------------------------
DROP TABLE IF EXISTS `report`;
CREATE TABLE `report`  (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `reporter_id` bigint NOT NULL COMMENT '举报人ID',
  `goods_uuid` varchar(36) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '被举报商品UUID',
  `reported_user_id` bigint NULL DEFAULT NULL COMMENT '被举报用户ID',
  `reason` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '举报原因',
  `description` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL COMMENT '举报描述',
  `status` tinyint NOT NULL DEFAULT 0 COMMENT '状态: 0待处理, 1已处理, 2已驳回',
  `handler_id` bigint NULL DEFAULT NULL COMMENT '处理人ID',
  `handle_remark` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL COMMENT '处理备注',
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `handled_at` datetime NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `reporter_id`(`reporter_id` ASC) USING BTREE,
  INDEX `idx_status`(`status` ASC) USING BTREE,
  CONSTRAINT `report_ibfk_1` FOREIGN KEY (`reporter_id`) REFERENCES `user` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 19 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '举报表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of report
-- ----------------------------
INSERT INTO `report` VALUES (1, 3, 'goods-0103', 4, '疑似描述不符', '商品描述与实物可能存在差异', 0, 1, '已核查，提醒卖家补充说明', '2026-05-01 08:32:22', '2026-05-02 10:02:22');
INSERT INTO `report` VALUES (2, 5, 'goods-0114', 5, '价格异常', '怀疑存在不实宣传', 1, 1, '已核查，提醒卖家补充说明', '2026-05-04 16:02:22', '2026-05-05 12:02:22');
INSERT INTO `report` VALUES (3, 8, 'goods-0122', 3, '疑似重复发布', '与其他商品过于相似', 2, 1, '经核查暂未发现明显违规，举报已驳回。', '2026-05-07 06:32:22', '2026-05-08 09:32:22');
INSERT INTO `report` VALUES (4, 21, 'goods-0017', 22, '价格异常', '商品价格与市场常见价格差异较大，建议审核。', 0, 1, '已核查并提醒相关用户规范发布和沟通。', '2026-05-10 14:02:22', '2026-05-12 12:02:22');
INSERT INTO `report` VALUES (5, 40, 'goods-0024', 71, '疑似重复发布', '疑似与平台已有商品重复发布。', 0, 1, '已核查并提醒相关用户规范发布和沟通。', '2026-05-13 04:32:22', '2026-05-15 12:02:22');
INSERT INTO `report` VALUES (6, 59, 'goods-0031', 21, '商品图片不清晰', '图片信息不足，无法判断商品真实状态。', 0, 1, '已核查并提醒相关用户规范发布和沟通。', '2026-05-16 12:02:22', '2026-05-17 12:02:22');
INSERT INTO `report` VALUES (7, 78, 'goods-0038', 70, '沟通态度问题', '交易沟通过程中存在不友好情况。', 0, 1, '已核查并提醒相关用户规范发布和沟通。', '2026-05-19 02:32:22', '2026-05-19 12:02:22');
INSERT INTO `report` VALUES (8, 97, 'goods-0045', 20, '疑似虚假描述', '商品描述与实际情况可能不一致，请管理员核查。', 1, 1, '已核查并提醒相关用户规范发布和沟通。', '2026-05-22 10:02:22', '2026-05-21 00:02:22');
INSERT INTO `report` VALUES (9, 17, 'goods-0052', 69, '价格异常', '商品价格与市场常见价格差异较大，建议审核。', 1, 1, '经核查暂未发现明显违规，举报已驳回。', '2026-05-25 00:32:22', '2026-05-25 21:32:22');
INSERT INTO `report` VALUES (10, 36, 'goods-0059', 19, '疑似重复发布', '疑似与平台已有商品重复发布。', 1, 1, '已核查并提醒相关用户规范发布和沟通。', '2026-05-28 08:02:22', '2026-05-31 12:02:22');
INSERT INTO `report` VALUES (11, 55, 'goods-0066', 68, '商品图片不清晰', '图片信息不足，无法判断商品真实状态。', 1, 1, '已核查并提醒相关用户规范发布和沟通。', '2026-05-31 16:32:22', '2026-06-01 03:32:22');
INSERT INTO `report` VALUES (12, 74, 'goods-0073', 18, '沟通态度问题', '交易沟通过程中存在不友好情况。', 2, 1, '经核查暂未发现明显违规，举报已驳回。', '2026-06-03 06:02:22', '2026-06-04 00:02:22');
INSERT INTO `report` VALUES (13, 93, 'goods-0080', 67, '疑似虚假描述', '商品描述与实际情况可能不一致，请管理员核查。', 2, 1, '经核查暂未发现明显违规，举报已驳回。', '2026-06-06 14:32:22', '2026-06-07 15:32:22');

-- ----------------------------
-- Table structure for user
-- ----------------------------
DROP TABLE IF EXISTS `user`;
CREATE TABLE `user`  (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '用户ID',
  `student_id` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '学号',
  `username` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '用户名',
  `password` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '密码(BCrypt加密)',
  `real_name` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '真实姓名',
  `avatar_url` varchar(512) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '头像URL',
  `phone` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '手机号',
  `email` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '邮箱',
  `role` tinyint NOT NULL DEFAULT 0 COMMENT '角色: 0普通用户, 1管理员',
  `credit_score` int NOT NULL DEFAULT 80 COMMENT '信用分(0-100)',
  `status` tinyint NOT NULL DEFAULT 1 COMMENT '状态: 0禁用, 1正常, 2待审核',
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '注册时间',
  `updated_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `student_id`(`student_id` ASC) USING BTREE,
  UNIQUE INDEX `username`(`username` ASC) USING BTREE,
  INDEX `idx_student_id`(`student_id` ASC) USING BTREE,
  INDEX `idx_username`(`username` ASC) USING BTREE,
  INDEX `idx_status`(`status` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 140 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '用户表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of user
-- ----------------------------
INSERT INTO `user` VALUES (1, 'admin001', 'admin', '$2a$10$N.zmdr9k7uOCQb376NoUnuTJ8iAt6Z5EHsM8lE9lBOsl7iKTVKIUi', '系统管理员', 'https://static.swapcampus.local/avatar/admin.png', '13800001000', 'admin@bjfu.edu.cn', 1, 100, 1, '2026-06-11 21:05:31', '2026-06-12 15:54:17');
INSERT INTO `user` VALUES (2, '2021001001', 'zhangsan', '$2a$10$N.zmdr9k7uOCQb376NoUnuTJ8iAt6Z5EHsM8lE9lBOsl7iKTVKIUi', '张三', 'https://static.swapcampus.local/avatar/zhangsan.png', '13800001001', 'zhangsan@bjfu.edu.cn', 0, 85, 1, '2026-06-11 21:05:31', '2026-06-12 15:49:27');
INSERT INTO `user` VALUES (3, '2021001002', 'lisi', '$2a$10$N.zmdr9k7uOCQb376NoUnuTJ8iAt6Z5EHsM8lE9lBOsl7iKTVKIUi', '李四', 'https://static.swapcampus.local/avatar/lisi.png', '13800001002', 'lisi@bjfu.edu.cn', 0, 90, 1, '2026-06-11 21:05:31', '2026-06-12 15:49:51');
INSERT INTO `user` VALUES (4, '2021001003', 'wangwu', '$2a$10$N.zmdr9k7uOCQb376NoUnuTJ8iAt6Z5EHsM8lE9lBOsl7iKTVKIUi', '王五', 'https://static.swapcampus.local/avatar/wangwu.png', '13800001003', 'wangwu@bjfu.edu.cn', 0, 75, 1, '2026-06-11 21:05:31', '2026-06-12 15:50:07');
INSERT INTO `user` VALUES (5, '2021001004', 'zhaoliu', '$2a$10$N.zmdr9k7uOCQb376NoUnuTJ8iAt6Z5EHsM8lE9lBOsl7iKTVKIUi', '赵六', 'https://static.swapcampus.local/avatar/zhaoliu.png', '13800001004', 'zhaoliu@bjfu.edu.cn', 0, 88, 1, '2026-06-11 21:15:19', '2026-06-12 15:50:21');
INSERT INTO `user` VALUES (6, '2021001005', 'sunqi', '$2a$10$N.zmdr9k7uOCQb376NoUnuTJ8iAt6Z5EHsM8lE9lBOsl7iKTVKIUi', '孙七', 'https://static.swapcampus.local/avatar/sunqi.png', '13800001005', 'sunqi@bjfu.edu.cn', 0, 82, 1, '2026-06-11 21:15:19', '2026-06-12 15:50:30');
INSERT INTO `user` VALUES (7, '2021001006', 'zhouba', '$2a$10$N.zmdr9k7uOCQb376NoUnuTJ8iAt6Z5EHsM8lE9lBOsl7iKTVKIUi', '周八', 'https://static.swapcampus.local/avatar/zhouba.png', '13800001006', 'zhouba@bjfu.edu.cn', 0, 86, 1, '2026-06-11 21:15:19', '2026-06-12 15:50:44');
INSERT INTO `user` VALUES (8, '2021001007', 'wujiu', '$2a$10$N.zmdr9k7uOCQb376NoUnuTJ8iAt6Z5EHsM8lE9lBOsl7iKTVKIUi', '吴九', 'https://static.swapcampus.local/avatar/wujiu.png', '13800001007', 'wujiu@bjfu.edu.cn', 0, 79, 1, '2026-06-11 21:15:19', '2026-06-12 15:51:10');
INSERT INTO `user` VALUES (9, '2021001008', 'zhengshi', '$2a$10$N.zmdr9k7uOCQb376NoUnuTJ8iAt6Z5EHsM8lE9lBOsl7iKTVKIUi', '郑十', 'https://static.swapcampus.local/avatar/zhengshi.png', '13800001008', 'zhengshi@bjfu.edu.cn', 0, 91, 1, '2026-06-11 21:15:19', '2026-06-12 15:51:26');
INSERT INTO `user` VALUES (10, '2021001009', 'qianyi', '$2a$10$N.zmdr9k7uOCQb376NoUnuTJ8iAt6Z5EHsM8lE9lBOsl7iKTVKIUi', '钱一', 'https://static.swapcampus.local/avatar/qianyi.png', '13800001009', 'qianyi@bjfu.edu.cn', 0, 84, 1, '2026-06-11 21:15:19', '2026-06-12 15:51:39');
INSERT INTO `user` VALUES (11, '2021001010', 'liyi', '$2a$10$N.zmdr9k7uOCQb376NoUnuTJ8iAt6Z5EHsM8lE9lBOsl7iKTVKIUi', '李一', 'https://static.swapcampus.local/avatar/liyi.png', '13800001010', 'liyi@bjfu.edu.cn', 0, 87, 1, '2026-06-11 21:15:19', '2026-06-12 15:51:48');
INSERT INTO `user` VALUES (12, '2021001011', 'chener', '$2a$10$N.zmdr9k7uOCQb376NoUnuTJ8iAt6Z5EHsM8lE9lBOsl7iKTVKIUi', '陈二', 'https://static.swapcampus.local/avatar/chener.png', '13800001011', 'chener@bjfu.edu.cn', 0, 80, 1, '2026-06-11 21:15:19', '2026-06-12 15:52:11');
INSERT INTO `user` VALUES (13, '2021001012', 'user012', '$2a$10$N.zmdr9k7uOCQb376NoUnuTJ8iAt6Z5EHsM8lE9lBOsl7iKTVKIUi', '用户012', 'https://static.swapcampus.local/avatar/user012.png', '13800000012', 'user012@bjfu.edu.cn', 0, 62, 1, '2026-01-06 22:55:43', '2026-06-11 23:22:43');
INSERT INTO `user` VALUES (14, '2021001013', 'user013', '$2a$10$N.zmdr9k7uOCQb376NoUnuTJ8iAt6Z5EHsM8lE9lBOsl7iKTVKIUi', '用户013', 'https://static.swapcampus.local/avatar/user013.png', '13800000013', 'user013@bjfu.edu.cn', 0, 69, 1, '2025-12-24 22:55:43', '2026-06-11 23:22:47');
INSERT INTO `user` VALUES (15, '2021001014', 'user014', '$2a$10$N.zmdr9k7uOCQb376NoUnuTJ8iAt6Z5EHsM8lE9lBOsl7iKTVKIUi', '用户014', 'https://static.swapcampus.local/avatar/user014.png', '13800000014', 'user014@bjfu.edu.cn', 0, 76, 1, '2026-06-09 22:55:43', '2026-06-11 23:22:49');
INSERT INTO `user` VALUES (16, '2021001015', 'user015', '$2a$10$N.zmdr9k7uOCQb376NoUnuTJ8iAt6Z5EHsM8lE9lBOsl7iKTVKIUi', '用户015', 'https://static.swapcampus.local/avatar/user015.png', '13800000015', 'user015@bjfu.edu.cn', 0, 83, 1, '2026-05-27 22:55:43', '2026-06-11 23:22:52');
INSERT INTO `user` VALUES (17, '2021001016', 'user016', '$2a$10$N.zmdr9k7uOCQb376NoUnuTJ8iAt6Z5EHsM8lE9lBOsl7iKTVKIUi', '用户016', 'https://static.swapcampus.local/avatar/user016.png', '13800000016', 'user016@bjfu.edu.cn', 0, 90, 1, '2026-05-14 22:55:43', '2026-06-11 23:22:55');
INSERT INTO `user` VALUES (18, '2021001017', 'user017', '$2a$10$N.zmdr9k7uOCQb376NoUnuTJ8iAt6Z5EHsM8lE9lBOsl7iKTVKIUi', '用户017', 'https://static.swapcampus.local/avatar/user017.png', '13800000017', 'user017@bjfu.edu.cn', 0, 97, 1, '2026-05-01 22:55:43', '2026-06-11 23:22:58');
INSERT INTO `user` VALUES (19, '2021001018', 'user018', '$2a$10$N.zmdr9k7uOCQb376NoUnuTJ8iAt6Z5EHsM8lE9lBOsl7iKTVKIUi', '用户018', 'https://static.swapcampus.local/avatar/user018.png', '13800000018', 'user018@bjfu.edu.cn', 0, 63, 1, '2026-04-18 22:55:43', '2026-06-11 23:23:01');
INSERT INTO `user` VALUES (20, '2021001019', 'user019', '$2a$10$N.zmdr9k7uOCQb376NoUnuTJ8iAt6Z5EHsM8lE9lBOsl7iKTVKIUi', '用户019', 'https://static.swapcampus.local/avatar/user019.png', '13800000019', 'user019@bjfu.edu.cn', 0, 70, 1, '2026-04-05 22:55:43', '2026-06-11 23:23:05');
INSERT INTO `user` VALUES (21, '2021001020', 'user020', '$2a$10$N.zmdr9k7uOCQb376NoUnuTJ8iAt6Z5EHsM8lE9lBOsl7iKTVKIUi', '用户020', 'https://static.swapcampus.local/avatar/user020.png', '13800000020', 'user020@bjfu.edu.cn', 0, 77, 1, '2026-03-23 22:55:43', '2026-06-11 23:23:06');
INSERT INTO `user` VALUES (22, '2021001021', 'user021', '$2a$10$N.zmdr9k7uOCQb376NoUnuTJ8iAt6Z5EHsM8lE9lBOsl7iKTVKIUi', '用户021', 'https://static.swapcampus.local/avatar/user021.png', '13800000021', 'user021@bjfu.edu.cn', 0, 84, 1, '2026-03-10 22:55:43', '2026-06-11 23:23:10');
INSERT INTO `user` VALUES (23, '2021001022', 'user022', '$2a$10$N.zmdr9k7uOCQb376NoUnuTJ8iAt6Z5EHsM8lE9lBOsl7iKTVKIUi', '用户022', 'https://static.swapcampus.local/avatar/user022.png', '13800000022', 'user022@bjfu.edu.cn', 0, 91, 1, '2026-02-25 22:55:43', '2026-06-11 23:23:15');
INSERT INTO `user` VALUES (24, '2021001023', 'user023', '$2a$10$N.zmdr9k7uOCQb376NoUnuTJ8iAt6Z5EHsM8lE9lBOsl7iKTVKIUi', '用户023', 'https://static.swapcampus.local/avatar/user023.png', '13800000023', 'user023@bjfu.edu.cn', 0, 98, 1, '2026-02-12 22:55:43', '2026-06-11 23:23:17');
INSERT INTO `user` VALUES (25, '2021001024', 'user024', '$2a$10$N.zmdr9k7uOCQb376NoUnuTJ8iAt6Z5EHsM8lE9lBOsl7iKTVKIUi', '用户024', 'https://static.swapcampus.local/avatar/user024.png', '13800000024', 'user024@bjfu.edu.cn', 0, 64, 1, '2026-01-30 22:55:43', '2026-06-11 23:23:20');
INSERT INTO `user` VALUES (26, '2021001025', 'user025', '$2a$10$N.zmdr9k7uOCQb376NoUnuTJ8iAt6Z5EHsM8lE9lBOsl7iKTVKIUi', '用户025', 'https://static.swapcampus.local/avatar/user025.png', '13800000025', 'user025@bjfu.edu.cn', 0, 71, 1, '2026-01-17 22:55:43', '2026-06-11 23:23:22');
INSERT INTO `user` VALUES (27, '2021001026', 'user026', '$2a$10$N.zmdr9k7uOCQb376NoUnuTJ8iAt6Z5EHsM8lE9lBOsl7iKTVKIUi', '用户026', 'https://static.swapcampus.local/avatar/user026.png', '13800000026', 'user026@bjfu.edu.cn', 0, 78, 1, '2026-01-04 22:55:43', '2026-06-11 23:23:25');
INSERT INTO `user` VALUES (28, '2021001027', 'user027', '$2a$10$N.zmdr9k7uOCQb376NoUnuTJ8iAt6Z5EHsM8lE9lBOsl7iKTVKIUi', '用户027', 'https://static.swapcampus.local/avatar/user027.png', '13800000027', 'user027@bjfu.edu.cn', 0, 85, 1, '2025-12-22 22:55:43', '2026-06-11 23:23:29');
INSERT INTO `user` VALUES (29, '2021001028', 'user028', '$2a$10$N.zmdr9k7uOCQb376NoUnuTJ8iAt6Z5EHsM8lE9lBOsl7iKTVKIUi', '用户028', 'https://static.swapcampus.local/avatar/user028.png', '13800000028', 'user028@bjfu.edu.cn', 0, 92, 1, '2026-06-07 22:55:43', '2026-06-11 23:23:31');
INSERT INTO `user` VALUES (30, '2021001029', 'user029', '$2a$10$N.zmdr9k7uOCQb376NoUnuTJ8iAt6Z5EHsM8lE9lBOsl7iKTVKIUi', '用户029', 'https://static.swapcampus.local/avatar/user029.png', '13800000029', 'user029@bjfu.edu.cn', 0, 99, 2, '2026-05-25 22:55:43', '2026-06-11 23:23:34');
INSERT INTO `user` VALUES (31, '2021001030', 'user030', '$2a$10$N.zmdr9k7uOCQb376NoUnuTJ8iAt6Z5EHsM8lE9lBOsl7iKTVKIUi', '用户030', 'https://static.swapcampus.local/avatar/user030.png', '13800000030', 'user030@bjfu.edu.cn', 0, 65, 1, '2026-05-12 22:55:43', '2026-06-11 23:23:36');
INSERT INTO `user` VALUES (32, '2021001031', 'user031', '$2a$10$N.zmdr9k7uOCQb376NoUnuTJ8iAt6Z5EHsM8lE9lBOsl7iKTVKIUi', '用户031', 'https://static.swapcampus.local/avatar/user031.png', '13800000031', 'user031@bjfu.edu.cn', 0, 72, 1, '2026-04-29 22:55:43', '2026-06-11 23:23:40');
INSERT INTO `user` VALUES (33, '2021001032', 'user032', '$2a$10$N.zmdr9k7uOCQb376NoUnuTJ8iAt6Z5EHsM8lE9lBOsl7iKTVKIUi', '用户032', 'https://static.swapcampus.local/avatar/user032.png', '13800000032', 'user032@bjfu.edu.cn', 0, 79, 1, '2026-04-16 22:55:43', '2026-06-11 23:23:43');
INSERT INTO `user` VALUES (34, '2021001033', 'user033', '$2a$10$N.zmdr9k7uOCQb376NoUnuTJ8iAt6Z5EHsM8lE9lBOsl7iKTVKIUi', '用户033', 'https://static.swapcampus.local/avatar/user033.png', '13800000033', 'user033@bjfu.edu.cn', 0, 86, 1, '2026-04-03 22:55:43', '2026-06-11 23:23:44');
INSERT INTO `user` VALUES (35, '2021001034', 'user034', '$2a$10$N.zmdr9k7uOCQb376NoUnuTJ8iAt6Z5EHsM8lE9lBOsl7iKTVKIUi', '用户034', 'https://static.swapcampus.local/avatar/user034.png', '13800000034', 'user034@bjfu.edu.cn', 0, 93, 1, '2026-03-21 22:55:43', '2026-06-11 23:23:52');
INSERT INTO `user` VALUES (36, '2021001035', 'user035', '$2a$10$N.zmdr9k7uOCQb376NoUnuTJ8iAt6Z5EHsM8lE9lBOsl7iKTVKIUi', '用户035', 'https://static.swapcampus.local/avatar/user035.png', '13800000035', 'user035@bjfu.edu.cn', 0, 100, 1, '2026-03-08 22:55:43', '2026-06-11 23:23:54');
INSERT INTO `user` VALUES (37, '2021001036', 'user036', '$2a$10$N.zmdr9k7uOCQb376NoUnuTJ8iAt6Z5EHsM8lE9lBOsl7iKTVKIUi', '用户036', 'https://static.swapcampus.local/avatar/user036.png', '13800000036', 'user036@bjfu.edu.cn', 0, 66, 1, '2026-02-23 22:55:43', '2026-06-11 23:23:56');
INSERT INTO `user` VALUES (38, '2021001037', 'user037', '$2a$10$N.zmdr9k7uOCQb376NoUnuTJ8iAt6Z5EHsM8lE9lBOsl7iKTVKIUi', '用户037', 'https://static.swapcampus.local/avatar/user037.png', '13800000037', 'user037@bjfu.edu.cn', 0, 73, 0, '2026-02-10 22:55:43', '2026-06-11 23:23:58');
INSERT INTO `user` VALUES (39, '2021001038', 'user038', '$2a$10$N.zmdr9k7uOCQb376NoUnuTJ8iAt6Z5EHsM8lE9lBOsl7iKTVKIUi', '用户038', 'https://static.swapcampus.local/avatar/user038.png', '13800000038', 'user038@bjfu.edu.cn', 0, 80, 1, '2026-01-28 22:55:43', '2026-06-11 23:23:59');
INSERT INTO `user` VALUES (40, '2021001039', 'user039', '$2a$10$N.zmdr9k7uOCQb376NoUnuTJ8iAt6Z5EHsM8lE9lBOsl7iKTVKIUi', '用户039', 'https://static.swapcampus.local/avatar/user039.png', '13800000039', 'user039@bjfu.edu.cn', 0, 87, 1, '2026-01-15 22:55:43', '2026-06-11 23:24:03');
INSERT INTO `user` VALUES (41, '2021001040', 'user040', '$2a$10$N.zmdr9k7uOCQb376NoUnuTJ8iAt6Z5EHsM8lE9lBOsl7iKTVKIUi', '用户040', 'https://static.swapcampus.local/avatar/user040.png', '13800000040', 'user040@bjfu.edu.cn', 0, 94, 1, '2026-01-02 22:55:43', '2026-06-11 23:24:05');
INSERT INTO `user` VALUES (42, '2021001041', 'user041', '$2a$10$N.zmdr9k7uOCQb376NoUnuTJ8iAt6Z5EHsM8lE9lBOsl7iKTVKIUi', '用户041', 'https://static.swapcampus.local/avatar/user041.png', '13800000041', 'user041@bjfu.edu.cn', 0, 60, 1, '2025-12-20 22:55:43', '2026-06-11 23:24:08');
INSERT INTO `user` VALUES (43, '2021001042', 'user042', '$2a$10$N.zmdr9k7uOCQb376NoUnuTJ8iAt6Z5EHsM8lE9lBOsl7iKTVKIUi', '用户042', 'https://static.swapcampus.local/avatar/user042.png', '13800000042', 'user042@bjfu.edu.cn', 0, 67, 1, '2026-06-05 22:55:43', '2026-06-11 23:24:10');
INSERT INTO `user` VALUES (44, '2021001043', 'user043', '$2a$10$N.zmdr9k7uOCQb376NoUnuTJ8iAt6Z5EHsM8lE9lBOsl7iKTVKIUi', '用户043', 'https://static.swapcampus.local/avatar/user043.png', '13800000043', 'user043@bjfu.edu.cn', 0, 74, 1, '2026-05-23 22:55:43', '2026-06-11 23:24:13');
INSERT INTO `user` VALUES (45, '2021001044', 'user044', '$2a$10$N.zmdr9k7uOCQb376NoUnuTJ8iAt6Z5EHsM8lE9lBOsl7iKTVKIUi', '用户044', 'https://static.swapcampus.local/avatar/user044.png', '13800000044', 'user044@bjfu.edu.cn', 0, 81, 1, '2026-05-10 22:55:43', '2026-06-11 23:24:16');
INSERT INTO `user` VALUES (46, '2021001045', 'user045', '$2a$10$N.zmdr9k7uOCQb376NoUnuTJ8iAt6Z5EHsM8lE9lBOsl7iKTVKIUi', '用户045', 'https://static.swapcampus.local/avatar/user045.png', '13800000045', 'user045@bjfu.edu.cn', 0, 88, 1, '2026-04-27 22:55:43', '2026-06-11 23:24:18');
INSERT INTO `user` VALUES (47, '2021001046', 'user046', '$2a$10$N.zmdr9k7uOCQb376NoUnuTJ8iAt6Z5EHsM8lE9lBOsl7iKTVKIUi', '用户046', 'https://static.swapcampus.local/avatar/user046.png', '13800000046', 'user046@bjfu.edu.cn', 0, 95, 1, '2026-04-14 22:55:43', '2026-06-11 23:24:20');
INSERT INTO `user` VALUES (48, '2021001047', 'user047', '$2a$10$N.zmdr9k7uOCQb376NoUnuTJ8iAt6Z5EHsM8lE9lBOsl7iKTVKIUi', '用户047', 'https://static.swapcampus.local/avatar/user047.png', '13800000047', 'user047@bjfu.edu.cn', 0, 61, 1, '2026-04-01 22:55:43', '2026-06-11 23:24:24');
INSERT INTO `user` VALUES (49, '2021001048', 'user048', '$2a$10$N.zmdr9k7uOCQb376NoUnuTJ8iAt6Z5EHsM8lE9lBOsl7iKTVKIUi', '用户048', 'https://static.swapcampus.local/avatar/user048.png', '13800000048', 'user048@bjfu.edu.cn', 0, 68, 1, '2026-03-19 22:55:43', '2026-06-11 23:24:27');
INSERT INTO `user` VALUES (50, '2021001049', 'user049', '$2a$10$N.zmdr9k7uOCQb376NoUnuTJ8iAt6Z5EHsM8lE9lBOsl7iKTVKIUi', '用户049', 'https://static.swapcampus.local/avatar/user049.png', '13800000049', 'user049@bjfu.edu.cn', 0, 75, 1, '2026-03-06 22:55:43', '2026-06-11 23:24:30');
INSERT INTO `user` VALUES (51, '2021001050', 'user050', '$2a$10$N.zmdr9k7uOCQb376NoUnuTJ8iAt6Z5EHsM8lE9lBOsl7iKTVKIUi', '用户050', 'https://static.swapcampus.local/avatar/user050.png', '13800000050', 'user050@bjfu.edu.cn', 0, 82, 1, '2026-02-21 22:55:43', '2026-06-11 23:24:32');
INSERT INTO `user` VALUES (52, '2021001051', 'user051', '$2a$10$N.zmdr9k7uOCQb376NoUnuTJ8iAt6Z5EHsM8lE9lBOsl7iKTVKIUi', '用户051', 'https://static.swapcampus.local/avatar/user051.png', '13800000051', 'user051@bjfu.edu.cn', 0, 89, 1, '2026-02-08 22:55:43', '2026-06-11 23:24:34');
INSERT INTO `user` VALUES (53, '2021001052', 'user052', '$2a$10$N.zmdr9k7uOCQb376NoUnuTJ8iAt6Z5EHsM8lE9lBOsl7iKTVKIUi', '用户052', 'https://static.swapcampus.local/avatar/user052.png', '13800000052', 'user052@bjfu.edu.cn', 0, 96, 1, '2026-01-26 22:55:43', '2026-06-11 23:24:36');
INSERT INTO `user` VALUES (54, '2021001053', 'user053', '$2a$10$N.zmdr9k7uOCQb376NoUnuTJ8iAt6Z5EHsM8lE9lBOsl7iKTVKIUi', '用户053', 'https://static.swapcampus.local/avatar/user053.png', '13800000053', 'user053@bjfu.edu.cn', 0, 62, 1, '2026-01-13 22:55:43', '2026-06-11 23:24:38');
INSERT INTO `user` VALUES (55, '2021001054', 'user054', '$2a$10$N.zmdr9k7uOCQb376NoUnuTJ8iAt6Z5EHsM8lE9lBOsl7iKTVKIUi', '用户054', 'https://static.swapcampus.local/avatar/user054.png', '13800000054', 'user054@bjfu.edu.cn', 0, 69, 1, '2025-12-31 22:55:43', '2026-06-11 23:24:39');
INSERT INTO `user` VALUES (56, '2021001055', 'user055', '$2a$10$N.zmdr9k7uOCQb376NoUnuTJ8iAt6Z5EHsM8lE9lBOsl7iKTVKIUi', '用户055', 'https://static.swapcampus.local/avatar/user055.png', '13800000055', 'user055@bjfu.edu.cn', 0, 76, 1, '2025-12-18 22:55:43', '2026-06-11 23:24:41');
INSERT INTO `user` VALUES (57, '2021001056', 'user056', '$2a$10$N.zmdr9k7uOCQb376NoUnuTJ8iAt6Z5EHsM8lE9lBOsl7iKTVKIUi', '用户056', 'https://static.swapcampus.local/avatar/user056.png', '13800000056', 'user056@bjfu.edu.cn', 0, 83, 1, '2026-06-03 22:55:43', '2026-06-11 23:24:45');
INSERT INTO `user` VALUES (58, '2021001057', 'user057', '$2a$10$N.zmdr9k7uOCQb376NoUnuTJ8iAt6Z5EHsM8lE9lBOsl7iKTVKIUi', '用户057', 'https://static.swapcampus.local/avatar/user057.png', '13800000057', 'user057@bjfu.edu.cn', 0, 90, 1, '2026-05-21 22:55:43', '2026-06-11 23:24:48');
INSERT INTO `user` VALUES (59, '2021001058', 'user058', '$2a$10$N.zmdr9k7uOCQb376NoUnuTJ8iAt6Z5EHsM8lE9lBOsl7iKTVKIUi', '用户058', 'https://static.swapcampus.local/avatar/user058.png', '13800000058', 'user058@bjfu.edu.cn', 0, 97, 2, '2026-05-08 22:55:43', '2026-06-11 23:24:51');
INSERT INTO `user` VALUES (60, '2021001059', 'user059', '$2a$10$N.zmdr9k7uOCQb376NoUnuTJ8iAt6Z5EHsM8lE9lBOsl7iKTVKIUi', '用户059', 'https://static.swapcampus.local/avatar/user059.png', '13800000059', 'user059@bjfu.edu.cn', 0, 63, 1, '2026-04-25 22:55:43', '2026-06-11 23:24:54');
INSERT INTO `user` VALUES (61, '2021001060', 'user060', '$2a$10$N.zmdr9k7uOCQb376NoUnuTJ8iAt6Z5EHsM8lE9lBOsl7iKTVKIUi', '用户060', 'https://static.swapcampus.local/avatar/user060.png', '13800000060', 'user060@bjfu.edu.cn', 0, 70, 1, '2026-04-12 22:55:43', '2026-06-11 23:24:56');
INSERT INTO `user` VALUES (62, '2021001061', 'user061', '$2a$10$N.zmdr9k7uOCQb376NoUnuTJ8iAt6Z5EHsM8lE9lBOsl7iKTVKIUi', '用户061', 'https://static.swapcampus.local/avatar/user061.png', '13800000061', 'user061@bjfu.edu.cn', 0, 77, 1, '2026-03-30 22:55:43', '2026-06-11 23:25:00');
INSERT INTO `user` VALUES (63, '2021001062', 'user062', '$2a$10$N.zmdr9k7uOCQb376NoUnuTJ8iAt6Z5EHsM8lE9lBOsl7iKTVKIUi', '用户062', 'https://static.swapcampus.local/avatar/user062.png', '13800000062', 'user062@bjfu.edu.cn', 0, 84, 1, '2026-03-17 22:55:43', '2026-06-11 23:25:02');
INSERT INTO `user` VALUES (64, '2021001063', 'user063', '$2a$10$N.zmdr9k7uOCQb376NoUnuTJ8iAt6Z5EHsM8lE9lBOsl7iKTVKIUi', '用户063', 'https://static.swapcampus.local/avatar/user063.png', '13800000063', 'user063@bjfu.edu.cn', 0, 91, 1, '2026-03-04 22:55:43', '2026-06-11 23:25:08');
INSERT INTO `user` VALUES (65, '2021001064', 'user064', '$2a$10$N.zmdr9k7uOCQb376NoUnuTJ8iAt6Z5EHsM8lE9lBOsl7iKTVKIUi', '用户064', 'https://static.swapcampus.local/avatar/user064.png', '13800000064', 'user064@bjfu.edu.cn', 0, 98, 1, '2026-02-19 22:55:43', '2026-06-11 23:25:10');
INSERT INTO `user` VALUES (66, '2021001065', 'user065', '$2a$10$N.zmdr9k7uOCQb376NoUnuTJ8iAt6Z5EHsM8lE9lBOsl7iKTVKIUi', '用户065', 'https://static.swapcampus.local/avatar/user065.png', '13800000065', 'user065@bjfu.edu.cn', 0, 64, 1, '2026-02-06 22:55:43', '2026-06-11 23:25:12');
INSERT INTO `user` VALUES (67, '2021001066', 'user066', '$2a$10$N.zmdr9k7uOCQb376NoUnuTJ8iAt6Z5EHsM8lE9lBOsl7iKTVKIUi', '用户066', 'https://static.swapcampus.local/avatar/user066.png', '13800000066', 'user066@bjfu.edu.cn', 0, 71, 1, '2026-01-24 22:55:43', '2026-06-11 23:25:13');
INSERT INTO `user` VALUES (68, '2021001067', 'user067', '$2a$10$N.zmdr9k7uOCQb376NoUnuTJ8iAt6Z5EHsM8lE9lBOsl7iKTVKIUi', '用户067', 'https://static.swapcampus.local/avatar/user067.png', '13800000067', 'user067@bjfu.edu.cn', 0, 78, 1, '2026-01-11 22:55:43', '2026-06-11 23:25:15');
INSERT INTO `user` VALUES (69, '2021001068', 'user068', '$2a$10$N.zmdr9k7uOCQb376NoUnuTJ8iAt6Z5EHsM8lE9lBOsl7iKTVKIUi', '用户068', 'https://static.swapcampus.local/avatar/user068.png', '13800000068', 'user068@bjfu.edu.cn', 0, 85, 1, '2025-12-29 22:55:43', '2026-06-11 23:25:17');
INSERT INTO `user` VALUES (70, '2021001069', 'user069', '$2a$10$N.zmdr9k7uOCQb376NoUnuTJ8iAt6Z5EHsM8lE9lBOsl7iKTVKIUi', '用户069', 'https://static.swapcampus.local/avatar/user069.png', '13800000069', 'user069@bjfu.edu.cn', 0, 92, 1, '2025-12-16 22:55:43', '2026-06-11 23:25:19');
INSERT INTO `user` VALUES (71, '2021001070', 'user070', '$2a$10$N.zmdr9k7uOCQb376NoUnuTJ8iAt6Z5EHsM8lE9lBOsl7iKTVKIUi', '用户070', 'https://static.swapcampus.local/avatar/user070.png', '13800000070', 'user070@bjfu.edu.cn', 0, 99, 1, '2026-06-01 22:55:43', '2026-06-11 23:25:21');
INSERT INTO `user` VALUES (72, '2021001071', 'user071', '$2a$10$N.zmdr9k7uOCQb376NoUnuTJ8iAt6Z5EHsM8lE9lBOsl7iKTVKIUi', '用户071', 'https://static.swapcampus.local/avatar/user071.png', '13800000071', 'user071@bjfu.edu.cn', 0, 65, 1, '2026-05-19 22:55:43', '2026-06-11 23:25:23');
INSERT INTO `user` VALUES (73, '2021001072', 'user072', '$2a$10$N.zmdr9k7uOCQb376NoUnuTJ8iAt6Z5EHsM8lE9lBOsl7iKTVKIUi', '用户072', 'https://static.swapcampus.local/avatar/user072.png', '13800000072', 'user072@bjfu.edu.cn', 0, 72, 1, '2026-05-06 22:55:43', '2026-06-11 23:25:25');
INSERT INTO `user` VALUES (74, '2021001073', 'user073', '$2a$10$N.zmdr9k7uOCQb376NoUnuTJ8iAt6Z5EHsM8lE9lBOsl7iKTVKIUi', '用户073', 'https://static.swapcampus.local/avatar/user073.png', '13800000073', 'user073@bjfu.edu.cn', 0, 79, 1, '2026-04-23 22:55:43', '2026-06-11 23:25:31');
INSERT INTO `user` VALUES (75, '2021001074', 'user074', '$2a$10$N.zmdr9k7uOCQb376NoUnuTJ8iAt6Z5EHsM8lE9lBOsl7iKTVKIUi', '用户074', 'https://static.swapcampus.local/avatar/user074.png', '13800000074', 'user074@bjfu.edu.cn', 0, 86, 0, '2026-04-10 22:55:43', '2026-06-11 23:25:33');
INSERT INTO `user` VALUES (76, '2021001075', 'user075', '$2a$10$N.zmdr9k7uOCQb376NoUnuTJ8iAt6Z5EHsM8lE9lBOsl7iKTVKIUi', '用户075', 'https://static.swapcampus.local/avatar/user075.png', '13800000075', 'user075@bjfu.edu.cn', 0, 93, 1, '2026-03-28 22:55:43', '2026-06-11 23:25:35');
INSERT INTO `user` VALUES (77, '2021001076', 'user076', '$2a$10$N.zmdr9k7uOCQb376NoUnuTJ8iAt6Z5EHsM8lE9lBOsl7iKTVKIUi', '用户076', 'https://static.swapcampus.local/avatar/user076.png', '13800000076', 'user076@bjfu.edu.cn', 0, 100, 1, '2026-03-15 22:55:43', '2026-06-11 23:25:37');
INSERT INTO `user` VALUES (78, '2021001077', 'user077', '$2a$10$N.zmdr9k7uOCQb376NoUnuTJ8iAt6Z5EHsM8lE9lBOsl7iKTVKIUi', '用户077', 'https://static.swapcampus.local/avatar/user077.png', '13800000077', 'user077@bjfu.edu.cn', 0, 66, 1, '2026-03-02 22:55:43', '2026-06-11 23:25:38');
INSERT INTO `user` VALUES (79, '2021001078', 'user078', '$2a$10$N.zmdr9k7uOCQb376NoUnuTJ8iAt6Z5EHsM8lE9lBOsl7iKTVKIUi', '用户078', 'https://static.swapcampus.local/avatar/user078.png', '13800000078', 'user078@bjfu.edu.cn', 0, 73, 1, '2026-02-17 22:55:43', '2026-06-11 23:25:41');
INSERT INTO `user` VALUES (80, '2021001079', 'user079', '$2a$10$N.zmdr9k7uOCQb376NoUnuTJ8iAt6Z5EHsM8lE9lBOsl7iKTVKIUi', '用户079', 'https://static.swapcampus.local/avatar/user079.png', '13800000079', 'user079@bjfu.edu.cn', 0, 80, 1, '2026-02-04 22:55:43', '2026-06-11 23:25:42');
INSERT INTO `user` VALUES (81, '2021001080', 'user080', '$2a$10$N.zmdr9k7uOCQb376NoUnuTJ8iAt6Z5EHsM8lE9lBOsl7iKTVKIUi', '用户080', 'https://static.swapcampus.local/avatar/user080.png', '13800000080', 'user080@bjfu.edu.cn', 0, 87, 1, '2026-01-22 22:55:43', '2026-06-11 23:25:45');
INSERT INTO `user` VALUES (82, '2021001081', 'user081', '$2a$10$N.zmdr9k7uOCQb376NoUnuTJ8iAt6Z5EHsM8lE9lBOsl7iKTVKIUi', '用户081', 'https://static.swapcampus.local/avatar/user081.png', '13800000081', 'user081@bjfu.edu.cn', 0, 94, 1, '2026-01-09 22:55:43', '2026-06-11 23:25:49');
INSERT INTO `user` VALUES (83, '2021001082', 'user082', '$2a$10$N.zmdr9k7uOCQb376NoUnuTJ8iAt6Z5EHsM8lE9lBOsl7iKTVKIUi', '用户082', 'https://static.swapcampus.local/avatar/user082.png', '13800000082', 'user082@bjfu.edu.cn', 0, 60, 1, '2025-12-27 22:55:43', '2026-06-11 23:25:52');
INSERT INTO `user` VALUES (84, '2021001083', 'user083', '$2a$10$N.zmdr9k7uOCQb376NoUnuTJ8iAt6Z5EHsM8lE9lBOsl7iKTVKIUi', '用户083', 'https://static.swapcampus.local/avatar/user083.png', '13800000083', 'user083@bjfu.edu.cn', 0, 67, 1, '2025-12-14 22:55:43', '2026-06-11 23:25:55');
INSERT INTO `user` VALUES (85, '2021001084', 'user084', '$2a$10$N.zmdr9k7uOCQb376NoUnuTJ8iAt6Z5EHsM8lE9lBOsl7iKTVKIUi', '用户084', 'https://static.swapcampus.local/avatar/user084.png', '13800000084', 'user084@bjfu.edu.cn', 0, 74, 1, '2026-05-30 22:55:43', '2026-06-11 23:25:57');
INSERT INTO `user` VALUES (86, '2021001085', 'user085', '$2a$10$N.zmdr9k7uOCQb376NoUnuTJ8iAt6Z5EHsM8lE9lBOsl7iKTVKIUi', '用户085', 'https://static.swapcampus.local/avatar/user085.png', '13800000085', 'user085@bjfu.edu.cn', 0, 81, 1, '2026-05-17 22:55:43', '2026-06-11 23:25:59');
INSERT INTO `user` VALUES (87, '2021001086', 'user086', '$2a$10$N.zmdr9k7uOCQb376NoUnuTJ8iAt6Z5EHsM8lE9lBOsl7iKTVKIUi', '用户086', 'https://static.swapcampus.local/avatar/user086.png', '13800000086', 'user086@bjfu.edu.cn', 0, 88, 1, '2026-05-04 22:55:43', '2026-06-11 23:26:00');
INSERT INTO `user` VALUES (88, '2021001087', 'user087', '$2a$10$N.zmdr9k7uOCQb376NoUnuTJ8iAt6Z5EHsM8lE9lBOsl7iKTVKIUi', '用户087', 'https://static.swapcampus.local/avatar/user087.png', '13800000087', 'user087@bjfu.edu.cn', 0, 95, 2, '2026-04-21 22:55:43', '2026-06-11 23:26:02');
INSERT INTO `user` VALUES (89, '2021001088', 'user088', '$2a$10$N.zmdr9k7uOCQb376NoUnuTJ8iAt6Z5EHsM8lE9lBOsl7iKTVKIUi', '用户088', 'https://static.swapcampus.local/avatar/user088.png', '13800000088', 'user088@bjfu.edu.cn', 0, 61, 1, '2026-04-08 22:55:43', '2026-06-11 23:26:04');
INSERT INTO `user` VALUES (90, '2021001089', 'user089', '$2a$10$N.zmdr9k7uOCQb376NoUnuTJ8iAt6Z5EHsM8lE9lBOsl7iKTVKIUi', '用户089', 'https://static.swapcampus.local/avatar/user089.png', '13800000089', 'user089@bjfu.edu.cn', 0, 68, 1, '2026-03-26 22:55:43', '2026-06-11 23:26:08');
INSERT INTO `user` VALUES (91, '2021001090', 'user090', '$2a$10$N.zmdr9k7uOCQb376NoUnuTJ8iAt6Z5EHsM8lE9lBOsl7iKTVKIUi', '用户090', 'https://static.swapcampus.local/avatar/user090.png', '13800000090', 'user090@bjfu.edu.cn', 0, 75, 1, '2026-03-13 22:55:43', '2026-06-11 23:26:10');
INSERT INTO `user` VALUES (92, '2021001091', 'user091', '$2a$10$N.zmdr9k7uOCQb376NoUnuTJ8iAt6Z5EHsM8lE9lBOsl7iKTVKIUi', '用户091', 'https://static.swapcampus.local/avatar/user091.png', '13800000091', 'user091@bjfu.edu.cn', 0, 82, 1, '2026-02-28 22:55:43', '2026-06-11 23:26:12');
INSERT INTO `user` VALUES (93, '2021001092', 'user092', '$2a$10$N.zmdr9k7uOCQb376NoUnuTJ8iAt6Z5EHsM8lE9lBOsl7iKTVKIUi', '用户092', 'https://static.swapcampus.local/avatar/user092.png', '13800000092', 'user092@bjfu.edu.cn', 0, 89, 1, '2026-02-15 22:55:43', '2026-06-11 23:26:14');
INSERT INTO `user` VALUES (94, '2021001093', 'user093', '$2a$10$N.zmdr9k7uOCQb376NoUnuTJ8iAt6Z5EHsM8lE9lBOsl7iKTVKIUi', '用户093', 'https://static.swapcampus.local/avatar/user093.png', '13800000093', 'user093@bjfu.edu.cn', 0, 96, 1, '2026-02-02 22:55:43', '2026-06-11 23:26:15');
INSERT INTO `user` VALUES (95, '2021001094', 'user094', '$2a$10$N.zmdr9k7uOCQb376NoUnuTJ8iAt6Z5EHsM8lE9lBOsl7iKTVKIUi', '用户094', 'https://static.swapcampus.local/avatar/user094.png', '13800000094', 'user094@bjfu.edu.cn', 0, 62, 1, '2026-01-20 22:55:43', '2026-06-11 23:26:17');
INSERT INTO `user` VALUES (96, '2021001095', 'user095', '$2a$10$N.zmdr9k7uOCQb376NoUnuTJ8iAt6Z5EHsM8lE9lBOsl7iKTVKIUi', '用户095', 'https://static.swapcampus.local/avatar/user095.png', '13800000095', 'user095@bjfu.edu.cn', 0, 69, 1, '2026-01-07 22:55:43', '2026-06-11 23:26:19');
INSERT INTO `user` VALUES (97, '2021001096', 'user096', '$2a$10$N.zmdr9k7uOCQb376NoUnuTJ8iAt6Z5EHsM8lE9lBOsl7iKTVKIUi', '用户096', 'https://static.swapcampus.local/avatar/user096.png', '13800000096', 'user096@bjfu.edu.cn', 0, 76, 1, '2025-12-25 22:55:43', '2026-06-11 23:26:20');
INSERT INTO `user` VALUES (98, '2021001097', 'user097', '$2a$10$N.zmdr9k7uOCQb376NoUnuTJ8iAt6Z5EHsM8lE9lBOsl7iKTVKIUi', '用户097', 'https://static.swapcampus.local/avatar/user097.png', '13800000097', 'user097@bjfu.edu.cn', 0, 83, 1, '2026-06-10 22:55:43', '2026-06-11 23:26:22');
INSERT INTO `user` VALUES (99, '2021001098', 'user098', '$2a$10$N.zmdr9k7uOCQb376NoUnuTJ8iAt6Z5EHsM8lE9lBOsl7iKTVKIUi', '用户098', 'https://static.swapcampus.local/avatar/user098.png', '13800000098', 'user098@bjfu.edu.cn', 0, 90, 1, '2026-05-28 22:55:43', '2026-06-11 23:26:25');
INSERT INTO `user` VALUES (100, '2021001099', 'user099', '$2a$10$N.zmdr9k7uOCQb376NoUnuTJ8iAt6Z5EHsM8lE9lBOsl7iKTVKIUi', '用户099', 'https://static.swapcampus.local/avatar/user099.png', '13800000099', 'user099@bjfu.edu.cn', 0, 97, 1, '2026-05-15 22:55:43', '2026-06-11 23:26:32');
INSERT INTO `user` VALUES (101, '2021001100', 'user100', '$2a$10$N.zmdr9k7uOCQb376NoUnuTJ8iAt6Z5EHsM8lE9lBOsl7iKTVKIUi', '用户100', 'https://static.swapcampus.local/avatar/user100.png', '13800000100', 'user100@bjfu.edu.cn', 0, 63, 1, '2026-05-02 22:55:43', '2026-06-11 23:26:34');

-- ----------------------------
-- Table structure for wallet
-- ----------------------------
DROP TABLE IF EXISTS `wallet`;
CREATE TABLE `wallet`  (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `user_id` bigint NOT NULL,
  `balance` decimal(10, 2) NOT NULL DEFAULT 0.00 COMMENT '余额',
  `points` int NOT NULL DEFAULT 0 COMMENT '积分',
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `user_id`(`user_id` ASC) USING BTREE,
  CONSTRAINT `wallet_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `user` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 741 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '用户钱包表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of wallet
-- ----------------------------
INSERT INTO `wallet` VALUES (1, 2, 0.00, 100, '2026-06-11 21:05:34', '2026-06-11 21:05:34');
INSERT INTO `wallet` VALUES (2, 3, 100.00, 200, '2026-06-11 21:05:34', '2026-06-11 21:05:34');
INSERT INTO `wallet` VALUES (3, 4, 50.00, 50, '2026-06-11 21:05:34', '2026-06-11 21:05:34');
INSERT INTO `wallet` VALUES (4, 5, 35.00, 85, '2026-06-11 21:15:19', '2026-06-11 21:15:19');
INSERT INTO `wallet` VALUES (5, 6, 38.00, 92, '2026-06-11 21:15:19', '2026-06-11 21:15:19');
INSERT INTO `wallet` VALUES (6, 7, 41.00, 99, '2026-06-11 21:15:19', '2026-06-11 21:15:19');
INSERT INTO `wallet` VALUES (7, 8, 44.00, 106, '2026-06-11 21:15:19', '2026-06-11 21:15:19');
INSERT INTO `wallet` VALUES (8, 9, 47.00, 113, '2026-06-11 21:15:19', '2026-06-11 21:15:19');
INSERT INTO `wallet` VALUES (9, 10, 50.00, 120, '2026-06-11 21:15:19', '2026-06-11 21:15:19');
INSERT INTO `wallet` VALUES (10, 11, 53.00, 127, '2026-06-11 21:15:19', '2026-06-11 21:15:19');
INSERT INTO `wallet` VALUES (11, 12, 56.00, 134, '2026-06-11 21:15:19', '2026-06-11 21:15:19');
INSERT INTO `wallet` VALUES (12, 13, 242.05, 297, '2026-01-19 22:55:43', '2026-06-11 23:06:46');
INSERT INTO `wallet` VALUES (13, 14, 259.40, 316, '2026-01-08 22:55:43', '2026-06-11 23:06:57');
INSERT INTO `wallet` VALUES (14, 15, 276.75, 335, '2026-06-06 22:55:43', '2026-06-11 23:07:01');
INSERT INTO `wallet` VALUES (15, 16, 294.10, 354, '2026-05-26 22:55:43', '2026-06-11 23:07:04');
INSERT INTO `wallet` VALUES (16, 17, 311.45, 373, '2026-05-15 22:55:43', '2026-06-11 23:07:06');
INSERT INTO `wallet` VALUES (17, 18, 328.80, 392, '2026-05-04 22:55:43', '2026-06-11 23:07:10');
INSERT INTO `wallet` VALUES (18, 19, 346.15, 411, '2026-04-23 22:55:43', '2026-06-11 23:07:13');
INSERT INTO `wallet` VALUES (19, 20, 360.00, 430, '2026-04-12 22:55:43', '2026-06-11 23:20:02');
INSERT INTO `wallet` VALUES (20, 21, 377.35, 449, '2026-04-01 22:55:43', '2026-06-11 23:20:33');
INSERT INTO `wallet` VALUES (21, 22, 394.70, 468, '2026-03-21 22:55:43', '2026-06-11 23:20:34');
INSERT INTO `wallet` VALUES (22, 23, 412.05, 487, '2026-03-10 22:55:43', '2026-06-11 23:20:35');
INSERT INTO `wallet` VALUES (23, 24, 429.40, 506, '2026-02-27 22:55:43', '2026-06-11 23:20:36');
INSERT INTO `wallet` VALUES (24, 25, 446.75, 525, '2026-02-16 22:55:43', '2026-06-11 23:20:05');
INSERT INTO `wallet` VALUES (25, 26, 464.10, 544, '2026-02-05 22:55:43', '2026-06-11 23:20:37');
INSERT INTO `wallet` VALUES (26, 27, 481.45, 563, '2026-01-25 22:55:43', '2026-06-11 23:20:39');
INSERT INTO `wallet` VALUES (27, 28, 498.80, 582, '2026-01-14 22:55:43', '2026-06-11 23:20:40');
INSERT INTO `wallet` VALUES (28, 29, 516.15, 601, '2026-01-03 22:55:43', '2026-06-11 23:20:42');
INSERT INTO `wallet` VALUES (29, 30, 30.00, 620, '2026-06-01 22:55:43', '2026-06-11 23:19:54');
INSERT INTO `wallet` VALUES (30, 31, 47.35, 639, '2026-05-21 22:55:43', '2026-06-11 23:20:47');
INSERT INTO `wallet` VALUES (31, 32, 64.70, 658, '2026-05-10 22:55:43', '2026-06-11 23:20:48');
INSERT INTO `wallet` VALUES (32, 33, 82.05, 677, '2026-04-29 22:55:43', '2026-06-11 23:20:50');
INSERT INTO `wallet` VALUES (33, 34, 99.40, 696, '2026-04-18 22:55:43', '2026-06-11 23:20:51');
INSERT INTO `wallet` VALUES (34, 35, 116.75, 715, '2026-04-07 22:55:43', '2026-06-11 23:20:52');
INSERT INTO `wallet` VALUES (35, 36, 134.10, 734, '2026-03-27 22:55:43', '2026-06-11 23:20:53');
INSERT INTO `wallet` VALUES (36, 37, 151.45, 753, '2026-03-16 22:55:43', '2026-06-11 23:20:55');
INSERT INTO `wallet` VALUES (37, 38, 168.80, 772, '2026-03-05 22:55:43', '2026-06-11 23:20:07');
INSERT INTO `wallet` VALUES (38, 39, 186.15, 791, '2026-02-22 22:55:43', '2026-06-11 23:20:25');
INSERT INTO `wallet` VALUES (39, 40, 200.00, 810, '2026-02-11 22:55:43', '2026-06-11 23:20:23');
INSERT INTO `wallet` VALUES (40, 41, 217.35, 829, '2026-01-31 22:55:43', '2026-06-11 23:11:58');
INSERT INTO `wallet` VALUES (41, 42, 234.70, 848, '2026-01-20 22:55:43', '2026-06-11 23:20:20');
INSERT INTO `wallet` VALUES (42, 43, 252.05, 867, '2026-01-09 22:55:43', '2026-06-11 23:11:53');
INSERT INTO `wallet` VALUES (43, 44, 269.40, 886, '2026-06-07 22:55:43', '2026-06-11 23:12:01');
INSERT INTO `wallet` VALUES (44, 45, 286.75, 905, '2026-05-27 22:55:43', '2026-06-11 23:12:03');
INSERT INTO `wallet` VALUES (45, 46, 304.10, 924, '2026-05-16 22:55:43', '2026-06-11 23:12:07');
INSERT INTO `wallet` VALUES (46, 47, 321.45, 943, '2026-05-05 22:55:43', '2026-06-11 23:12:11');
INSERT INTO `wallet` VALUES (47, 48, 338.80, 962, '2026-04-24 22:55:43', '2026-06-11 23:12:14');
INSERT INTO `wallet` VALUES (48, 49, 356.15, 981, '2026-04-13 22:55:43', '2026-06-11 23:12:18');
INSERT INTO `wallet` VALUES (49, 50, 370.00, 1000, '2026-04-02 22:55:43', '2026-06-11 23:12:21');
INSERT INTO `wallet` VALUES (50, 51, 387.35, 1019, '2026-03-22 22:55:43', '2026-06-11 23:12:26');
INSERT INTO `wallet` VALUES (51, 52, 404.70, 1038, '2026-03-11 22:55:43', '2026-06-11 23:12:29');
INSERT INTO `wallet` VALUES (52, 53, 422.05, 57, '2026-02-28 22:55:43', '2026-06-11 23:12:32');
INSERT INTO `wallet` VALUES (53, 54, 439.40, 76, '2026-02-17 22:55:43', '2026-06-11 23:12:35');
INSERT INTO `wallet` VALUES (54, 55, 456.75, 95, '2026-02-06 22:55:43', '2026-06-11 23:12:38');
INSERT INTO `wallet` VALUES (55, 56, 474.10, 114, '2026-01-26 22:55:43', '2026-06-11 23:12:41');
INSERT INTO `wallet` VALUES (56, 57, 491.45, 133, '2026-01-15 22:55:43', '2026-06-11 23:12:50');
INSERT INTO `wallet` VALUES (57, 58, 508.80, 152, '2026-01-04 22:55:43', '2026-06-11 23:12:53');
INSERT INTO `wallet` VALUES (58, 59, 26.15, 171, '2026-06-02 22:55:43', '2026-06-11 23:19:57');
INSERT INTO `wallet` VALUES (59, 60, 40.00, 190, '2026-05-22 22:55:43', '2026-06-11 23:12:58');
INSERT INTO `wallet` VALUES (60, 61, 57.35, 209, '2026-05-11 22:55:43', '2026-06-11 23:13:01');
INSERT INTO `wallet` VALUES (61, 62, 74.70, 228, '2026-04-30 22:55:43', '2026-06-11 23:13:05');
INSERT INTO `wallet` VALUES (62, 63, 92.05, 247, '2026-04-19 22:55:43', '2026-06-11 23:17:36');
INSERT INTO `wallet` VALUES (63, 64, 109.40, 266, '2026-04-08 22:55:43', '2026-06-11 23:17:40');
INSERT INTO `wallet` VALUES (64, 65, 126.75, 285, '2026-03-28 22:55:43', '2026-06-11 23:17:44');
INSERT INTO `wallet` VALUES (65, 66, 144.10, 304, '2026-03-17 22:55:43', '2026-06-11 23:17:47');
INSERT INTO `wallet` VALUES (66, 67, 161.45, 323, '2026-03-06 22:55:43', '2026-06-11 23:17:50');
INSERT INTO `wallet` VALUES (67, 68, 178.80, 342, '2026-02-23 22:55:43', '2026-06-11 23:17:53');
INSERT INTO `wallet` VALUES (68, 69, 196.15, 361, '2026-02-12 22:55:43', '2026-06-11 23:17:56');
INSERT INTO `wallet` VALUES (69, 70, 210.00, 380, '2026-02-01 22:55:43', '2026-06-11 23:17:59');
INSERT INTO `wallet` VALUES (70, 71, 227.35, 399, '2026-01-21 22:55:43', '2026-06-11 23:18:02');
INSERT INTO `wallet` VALUES (71, 72, 244.70, 418, '2026-01-10 22:55:43', '2026-06-11 23:18:05');
INSERT INTO `wallet` VALUES (72, 73, 262.05, 437, '2026-06-08 22:55:43', '2026-06-11 23:18:07');
INSERT INTO `wallet` VALUES (73, 74, 279.40, 456, '2026-05-28 22:55:43', '2026-06-11 23:18:17');
INSERT INTO `wallet` VALUES (74, 75, 296.75, 475, '2026-05-17 22:55:43', '2026-06-11 23:20:31');
INSERT INTO `wallet` VALUES (75, 76, 314.10, 494, '2026-05-06 22:55:43', '2026-06-11 23:18:22');
INSERT INTO `wallet` VALUES (76, 77, 331.45, 513, '2026-04-25 22:55:43', '2026-06-11 23:18:25');
INSERT INTO `wallet` VALUES (77, 78, 348.80, 532, '2026-04-14 22:55:43', '2026-06-11 23:18:28');
INSERT INTO `wallet` VALUES (78, 79, 366.15, 551, '2026-04-03 22:55:43', '2026-06-11 23:18:34');
INSERT INTO `wallet` VALUES (79, 80, 380.00, 570, '2026-03-23 22:55:43', '2026-06-11 23:18:36');
INSERT INTO `wallet` VALUES (80, 81, 397.35, 589, '2026-03-12 22:55:43', '2026-06-11 23:18:42');
INSERT INTO `wallet` VALUES (81, 82, 414.70, 608, '2026-03-01 22:55:43', '2026-06-11 23:18:45');
INSERT INTO `wallet` VALUES (82, 83, 432.05, 627, '2026-02-18 22:55:43', '2026-06-11 23:18:50');
INSERT INTO `wallet` VALUES (83, 84, 449.40, 646, '2026-02-07 22:55:43', '2026-06-11 23:18:56');
INSERT INTO `wallet` VALUES (84, 85, 466.75, 665, '2026-01-27 22:55:43', '2026-06-11 23:18:58');
INSERT INTO `wallet` VALUES (85, 86, 484.10, 684, '2026-01-16 22:55:43', '2026-06-11 23:19:00');
INSERT INTO `wallet` VALUES (86, 87, 501.45, 703, '2026-01-05 22:55:43', '2026-06-11 23:19:03');
INSERT INTO `wallet` VALUES (87, 88, 518.80, 722, '2026-06-03 22:55:43', '2026-06-11 23:20:00');
INSERT INTO `wallet` VALUES (88, 89, 36.15, 741, '2026-05-23 22:55:43', '2026-06-11 23:19:06');
INSERT INTO `wallet` VALUES (89, 90, 50.00, 760, '2026-05-12 22:55:43', '2026-06-11 23:19:33');
INSERT INTO `wallet` VALUES (90, 91, 67.35, 779, '2026-05-01 22:55:43', '2026-06-11 23:19:35');
INSERT INTO `wallet` VALUES (91, 92, 84.70, 798, '2026-04-20 22:55:43', '2026-06-11 23:19:36');
INSERT INTO `wallet` VALUES (92, 93, 102.05, 817, '2026-04-09 22:55:43', '2026-06-11 23:19:38');
INSERT INTO `wallet` VALUES (93, 94, 119.40, 836, '2026-03-29 22:55:43', '2026-06-11 23:19:39');
INSERT INTO `wallet` VALUES (94, 95, 136.75, 855, '2026-03-18 22:55:43', '2026-06-11 23:19:41');
INSERT INTO `wallet` VALUES (95, 96, 154.10, 874, '2026-03-07 22:55:43', '2026-06-11 23:19:43');
INSERT INTO `wallet` VALUES (96, 97, 171.45, 893, '2026-02-24 22:55:43', '2026-06-11 23:19:45');
INSERT INTO `wallet` VALUES (97, 98, 188.80, 912, '2026-02-13 22:55:43', '2026-06-11 23:19:46');
INSERT INTO `wallet` VALUES (98, 99, 206.15, 931, '2026-02-02 22:55:43', '2026-06-11 23:19:48');
INSERT INTO `wallet` VALUES (99, 100, 220.00, 950, '2026-01-22 22:55:43', '2026-06-11 23:19:49');
INSERT INTO `wallet` VALUES (100, 101, 237.35, 969, '2026-01-11 22:55:43', '2026-06-11 23:19:51');

SET FOREIGN_KEY_CHECKS = 1;
