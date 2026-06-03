-- ============================================
-- SwapCampus 校园闲置物品交易平台
-- 数据库初始化脚本 (MySQL 8)
-- ============================================

DROP DATABASE IF EXISTS `swapcampus`;
CREATE DATABASE `swapcampus` DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE `swapcampus`;

-- -------------------------------------------
-- 用户基础表
-- -------------------------------------------
CREATE TABLE `user` (
    `id`            BIGINT PRIMARY KEY AUTO_INCREMENT  COMMENT '用户ID',
    `student_id`    VARCHAR(20) NOT NULL UNIQUE         COMMENT '学号',
    `username`      VARCHAR(64) NOT NULL UNIQUE         COMMENT '用户名',
    `password`      VARCHAR(255) NOT NULL               COMMENT '密码(BCrypt加密)',
    `real_name`     VARCHAR(64) NOT NULL                COMMENT '真实姓名',
    `avatar_url`    VARCHAR(512) DEFAULT NULL           COMMENT '头像URL',
    `phone`         VARCHAR(20) DEFAULT NULL            COMMENT '手机号',
    `email`         VARCHAR(128) DEFAULT NULL           COMMENT '邮箱',
    `role`          TINYINT     NOT NULL DEFAULT 0      COMMENT '角色: 0普通用户, 1管理员',
    `credit_score`  INT         NOT NULL DEFAULT 80     COMMENT '信用分(0-100)',
    `status`        TINYINT     NOT NULL DEFAULT 1      COMMENT '状态: 0禁用, 1正常, 2待审核',
    `created_at`    DATETIME    NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '注册时间',
    `updated_at`    DATETIME    NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    INDEX `idx_student_id` (`student_id`),
    INDEX `idx_username` (`username`),
    INDEX `idx_status` (`status`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='用户表';

-- -------------------------------------------
-- 商品分类表
-- -------------------------------------------
CREATE TABLE `category` (
    `id`            BIGINT PRIMARY KEY AUTO_INCREMENT  COMMENT '分类ID',
    `name`          VARCHAR(64) NOT NULL                COMMENT '分类名称',
    `icon`          VARCHAR(255) DEFAULT NULL           COMMENT '分类图标',
    `sort_order`    INT NOT NULL DEFAULT 0              COMMENT '排序',
    `status`        TINYINT NOT NULL DEFAULT 1          COMMENT '状态: 0禁用, 1启用',
    `created_at`    DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='商品分类表';

-- -------------------------------------------
-- 商品表
-- -------------------------------------------
CREATE TABLE `goods` (
    `id`              BIGINT PRIMARY KEY AUTO_INCREMENT  COMMENT '商品ID',
    `uuid`            VARCHAR(36)  NOT NULL UNIQUE        COMMENT '商品唯一标识',
    `seller_id`       BIGINT       NOT NULL               COMMENT '卖家ID',
    `category_id`     BIGINT       DEFAULT NULL           COMMENT '分类ID',
    `title`           VARCHAR(255) NOT NULL               COMMENT '商品标题',
    `description`     TEXT         DEFAULT NULL           COMMENT '商品描述',
    `price`           DECIMAL(10,2) NOT NULL              COMMENT '售价',
    `original_price`  DECIMAL(10,2) DEFAULT NULL          COMMENT '原价',
    `condition_level` TINYINT      NOT NULL DEFAULT 5     COMMENT '成色: 1-10, 10全新',
    `is_bargain`      TINYINT      NOT NULL DEFAULT 0     COMMENT '是否接受议价',
    `trade_method`    VARCHAR(32)  NOT NULL DEFAULT 'FACE' COMMENT '交易方式: FACE面交, LOCKER邮件柜, BOTH',
    `campus_location` VARCHAR(128) DEFAULT NULL           COMMENT '交易地点(校区)',
    `view_count`      INT          NOT NULL DEFAULT 0     COMMENT '浏览量',
    `favorite_count`  INT          NOT NULL DEFAULT 0     COMMENT '收藏数',
    `status`          TINYINT      NOT NULL DEFAULT 1     COMMENT '状态: -1已删除, 0下架, 1在售, 2已售出, 3审核中',
    `created_at`      DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP,
    `updated_at`      DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (`seller_id`) REFERENCES `user`(`id`),
    FOREIGN KEY (`category_id`) REFERENCES `category`(`id`),
    INDEX `idx_uuid` (`uuid`),
    INDEX `idx_seller` (`seller_id`),
    INDEX `idx_category` (`category_id`),
    INDEX `idx_status` (`status`),
    INDEX `idx_title` (`title`),
    FULLTEXT INDEX `ft_title_desc` (`title`, `description`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='商品表';

-- -------------------------------------------
-- 商品图片表
-- -------------------------------------------
CREATE TABLE `goods_image` (
    `id`          BIGINT PRIMARY KEY AUTO_INCREMENT,
    `goods_uuid`  VARCHAR(36)  NOT NULL COMMENT '商品UUID',
    `url`         VARCHAR(512) NOT NULL COMMENT '图片URL(MinIO)',
    `sort_order`  INT NOT NULL DEFAULT 0 COMMENT '排序',
    `created_at`  DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (`goods_uuid`) REFERENCES `goods`(`uuid`),
    INDEX `idx_goods_uuid` (`goods_uuid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='商品图片表';

-- -------------------------------------------
-- 订单/交易表
-- -------------------------------------------
CREATE TABLE `orders` (
    `id`              BIGINT PRIMARY KEY AUTO_INCREMENT,
    `uuid`            VARCHAR(36)  NOT NULL UNIQUE       COMMENT '订单号',
    `goods_uuid`      VARCHAR(36)  NOT NULL              COMMENT '商品UUID',
    `buyer_id`        BIGINT       NOT NULL              COMMENT '买家ID',
    `seller_id`       BIGINT       NOT NULL              COMMENT '卖家ID',
    `amount`          DECIMAL(10,2) NOT NULL             COMMENT '成交金额',
    `trade_method`    VARCHAR(32)  NOT NULL              COMMENT '交易方式',
    `meet_location`   VARCHAR(256) DEFAULT NULL          COMMENT '面交地点',
    `meet_time`       DATETIME     DEFAULT NULL          COMMENT '面交时间',
    `buyer_confirm`   TINYINT      NOT NULL DEFAULT 0    COMMENT '买家确认: 0未确认, 1已确认',
    `seller_confirm`  TINYINT      NOT NULL DEFAULT 0    COMMENT '卖家确认: 0未确认, 1已确认',
    `status`          TINYINT      NOT NULL DEFAULT 0    COMMENT '状态: -1已取消, 0待确认, 1进行中, 2已完成, 3退货中',
    `buyer_rating`    TINYINT      DEFAULT NULL          COMMENT '买家评分(1-5)',
    `buyer_review`    TEXT         DEFAULT NULL          COMMENT '买家评价',
    `completed_at`    DATETIME     DEFAULT NULL          COMMENT '完成时间',
    `created_at`      DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP,
    `updated_at`      DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (`goods_uuid`) REFERENCES `goods`(`uuid`),
    FOREIGN KEY (`buyer_id`)  REFERENCES `user`(`id`),
    FOREIGN KEY (`seller_id`) REFERENCES `user`(`id`),
    INDEX `idx_uuid` (`uuid`),
    INDEX `idx_buyer` (`buyer_id`),
    INDEX `idx_seller` (`seller_id`),
    INDEX `idx_status` (`status`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='订单表';

-- -------------------------------------------
-- 收藏表
-- -------------------------------------------
CREATE TABLE `favorite` (
    `id`          BIGINT PRIMARY KEY AUTO_INCREMENT,
    `user_id`     BIGINT    NOT NULL,
    `goods_uuid`  VARCHAR(36) NOT NULL,
    `created_at`  DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (`user_id`)    REFERENCES `user`(`id`),
    FOREIGN KEY (`goods_uuid`) REFERENCES `goods`(`uuid`),
    UNIQUE KEY `uk_user_goods` (`user_id`, `goods_uuid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='收藏表';

-- -------------------------------------------
-- 用户积分/钱包表
-- -------------------------------------------
CREATE TABLE `wallet` (
    `id`          BIGINT PRIMARY KEY AUTO_INCREMENT,
    `user_id`     BIGINT NOT NULL UNIQUE,
    `balance`     DECIMAL(10,2) NOT NULL DEFAULT 0.00 COMMENT '余额',
    `points`      INT NOT NULL DEFAULT 0              COMMENT '积分',
    `created_at`  DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    `updated_at`  DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (`user_id`) REFERENCES `user`(`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='用户钱包表';

-- -------------------------------------------
-- 即时通讯消息表
-- -------------------------------------------
CREATE TABLE `message` (
    `id`            BIGINT PRIMARY KEY AUTO_INCREMENT,
    `uuid`          VARCHAR(36) NOT NULL UNIQUE       COMMENT '消息UUID',
    `sender_id`     BIGINT     NOT NULL               COMMENT '发送者ID',
    `receiver_id`   BIGINT     NOT NULL               COMMENT '接收者ID',
    `goods_uuid`    VARCHAR(36) DEFAULT NULL          COMMENT '关联商品UUID',
    `content`       TEXT       NOT NULL               COMMENT '消息内容',
    `msg_type`      VARCHAR(16) NOT NULL DEFAULT 'TEXT' COMMENT '消息类型: TEXT, IMAGE, SYSTEM',
    `is_read`       TINYINT    NOT NULL DEFAULT 0     COMMENT '是否已读',
    `created_at`    DATETIME   NOT NULL DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (`sender_id`)   REFERENCES `user`(`id`),
    FOREIGN KEY (`receiver_id`) REFERENCES `user`(`id`),
    INDEX `idx_sender` (`sender_id`),
    INDEX `idx_receiver` (`receiver_id`),
    INDEX `idx_goods` (`goods_uuid`),
    INDEX `idx_created` (`created_at`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='消息表';

-- -------------------------------------------
-- 举报表
-- -------------------------------------------
CREATE TABLE `report` (
    `id`            BIGINT PRIMARY KEY AUTO_INCREMENT,
    `reporter_id`   BIGINT       NOT NULL             COMMENT '举报人ID',
    `goods_uuid`    VARCHAR(36)  DEFAULT NULL         COMMENT '被举报商品UUID',
    `reported_user_id` BIGINT    DEFAULT NULL         COMMENT '被举报用户ID',
    `reason`        VARCHAR(64)  NOT NULL             COMMENT '举报原因',
    `description`   TEXT         DEFAULT NULL         COMMENT '举报描述',
    `status`        TINYINT      NOT NULL DEFAULT 0   COMMENT '状态: 0待处理, 1已处理, 2已驳回',
    `handler_id`    BIGINT       DEFAULT NULL         COMMENT '处理人ID',
    `handle_remark` TEXT         DEFAULT NULL         COMMENT '处理备注',
    `created_at`    DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP,
    `handled_at`    DATETIME     DEFAULT NULL,
    FOREIGN KEY (`reporter_id`) REFERENCES `user`(`id`),
    INDEX `idx_status` (`status`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='举报表';

-- -------------------------------------------
-- 系统通知表
-- -------------------------------------------
CREATE TABLE `notification` (
    `id`          BIGINT PRIMARY KEY AUTO_INCREMENT,
    `user_id`     BIGINT       NOT NULL,
    `title`       VARCHAR(255) NOT NULL,
    `content`     TEXT         NOT NULL,
    `is_read`     TINYINT      NOT NULL DEFAULT 0,
    `created_at`  DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (`user_id`) REFERENCES `user`(`id`),
    INDEX `idx_user_read` (`user_id`, `is_read`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='通知表';

-- ============================================
-- 初始数据
-- ============================================

-- 商品分类种子数据
INSERT INTO `category` (`name`, `icon`, `sort_order`) VALUES
('教材教辅', 'book', 1),
('电子数码', 'device', 2),
('生活用品', 'daily', 3),
('运动户外', 'sport', 4),
('服饰美妆', 'fashion', 5),
('图书音像', 'music', 6),
('其他闲置', 'other', 7);

-- 管理员账号
INSERT INTO `user` (`student_id`, `username`, `password`, `real_name`, `role`, `status`) VALUES
('admin001', 'admin', '$2a$10$N.zmdr9k7uOCQb376NoUnuTJ8iAt6Z5EHsM8lE9lBOsl7iKTVKIUi', '系统管理员', 1, 1);

-- 测试用户
INSERT INTO `user` (`student_id`, `username`, `password`, `real_name`, `phone`, `email`, `role`, `credit_score`, `status`) VALUES
('2021001001', 'zhangsan', '$2a$10$N.zmdr9k7uOCQb376NoUnuTJ8iAt6Z5EHsM8lE9lBOsl7iKTVKIUi', '张三', '13800001001', 'zhangsan@bjfu.edu.cn', 0, 85, 1),
('2021001002', 'lisi',    '$2a$10$N.zmdr9k7uOCQb376NoUnuTJ8iAt6Z5EHsM8lE9lBOsl7iKTVKIUi', '李四', '13800001002', 'lisi@bjfu.edu.cn',    0, 90, 1),
('2021001003', 'wangwu',  '$2a$10$N.zmdr9k7uOCQb376NoUnuTJ8iAt6Z5EHsM8lE9lBOsl7iKTVKIUi', '王五', '13800001003', 'wangwu@bjfu.edu.cn',  0, 75, 1);

-- 测试钱包
INSERT INTO `wallet` (`user_id`, `balance`, `points`) VALUES (2, 0.00, 100), (3, 100.00, 200), (4, 50.00, 50);
