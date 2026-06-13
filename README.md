# SwapCampus 校园闲置物品交易平台

> Campus Second-hand Trading Platform — 北京林业大学《软件工程（课程设计）》课程项目 T-02

## 项目简介

SwapCampus 是一个面向高校师生的校园闲置物品交易平台，旨在提高校内资源流转率，为同学提供安全、便捷的交易体验。

### 核心功能

| 模块 | 功能 |
|------|------|
| 🔐 用户体系 | 学号实名认证 / JWT鉴权 / 信用积分 / 个人主页 |
| 🛍️ 商品发布 | 多图上传 / 分类标签 / 成色标注 / 价格设置 |
| 🔍 商品检索 | 分类浏览 / 关键词搜索 / 高级筛选排序 |
| 📦 交易流程 | 下单 / 面交确认 / 邮件柜 / 双方确认收货 / 评价 |
| 💬 站内通讯 | 实时聊天 (WebSocket STOMP) / 图文消息 |
| 🛡️ 后台管理 | 用户管理 / 商品审核 / 举报处理 / 数据看板 |

### 技术栈

| 层级 | 技术 |
|------|------|
| **前端** | Vue 3 + Element Plus + Axios + Pinia + SockJS |
| **后端** | Spring Boot 3.2 + MyBatis-Plus + Spring Security |
| **数据库** | MySQL 8 + Redis |
| **对象存储** | MinIO |
| **即时通讯** | WebSocket (STOMP) |
| **鉴权** | JWT (Spring Security) |
| **容器化** | Docker + Docker Compose |

## 项目结构

```
SwapCampus/
├── backend/                  # Spring Boot 后端
│   ├── src/main/java/com/swapcampus/
│   │   ├── config/           # 配置类 (MinIO, WebSocket, CORS, MyBatis-Plus)
│   │   ├── controller/       # 控制器
│   │   │   ├── AuthController.java       # 认证 (登录/注册)
│   │   │   ├── GoodsController.java      # 商品管理
│   │   │   ├── OrderController.java      # 订单管理
│   │   │   ├── ChatController.java       # 即时通讯 (WebSocket + REST)
│   │   │   ├── UserController.java       # 用户信息
│   │   │   ├── AdminController.java      # 后台管理
│   │   │   └── CategoryController.java   # 商品分类
│   │   ├── dto/              # 数据传输对象
│   │   ├── entity/           # 实体类 (User, Goods, Order, Message, etc.)
│   │   ├── exception/        # 全局异常处理
│   │   ├── repository/       # MyBatis-Plus Mapper 接口
│   │   ├── security/         # JWT Token + Spring Security 配置
│   │   └── service/          # 业务逻辑层
│   ├── Dockerfile
│   └── pom.xml
├── frontend/                 # Vue 3 前端
│   ├── src/
│   │   ├── api/              # API 请求模块 (axios)
│   │   ├── components/       # 公共组件 (MainLayout)
│   │   ├── router/           # Vue Router 路由配置
│   │   ├── store/            # Pinia 状态管理 (user)
│   │   └── views/            # 12 个页面视图
│   │       ├── Home.vue      # 首页/商品列表
│   │       ├── GoodsDetail.vue  # 商品详情
│   │       ├── Login.vue     # 登录
│   │       ├── Register.vue  # 注册
│   │       ├── Publish.vue   # 发布/编辑商品
│   │       ├── Chat.vue      # 即时聊天
│   │       ├── Orders.vue    # 订单管理
│   │       ├── Profile.vue   # 个人中心
│   │       ├── MyGoods.vue   # 我的发布
│   │       ├── Favorites.vue # 我的收藏
│   │       └── Admin.vue     # 后台管理
│   ├── Dockerfile
│   ├── nginx.conf
│   └── package.json
├── db/
│   └── schema.sql            # 完整建表DDL + 种子数据 (11张表)
├── docker-compose.yml        # Docker 一键部署 (MySQL + Redis + MinIO + 前后端)
├── Makefile                  # 快捷命令
└── .gitignore
```

## 快速启动

### 前置依赖

- Docker Desktop 24+
- JDK 17+ & Node.js 20+ (本地开发)

### 一键部署 (Docker)

```bash
make up
```

### 本地开发

```bash
# 1. 启动开发环境中间件 (MySQL, Redis, MinIO)
make dev-infra

# 2. 启动后端
make dev-backend

# 3. 启动前端
make dev-frontend
```

访问地址:
- 前端: http://localhost:3000
- 后端 API: http://localhost:8080
- MinIO Console: http://localhost:9001 (minioadmin / minioadmin)

### 测试账号

| 角色 | 用户名 | 密码 |
|------|--------|------|
| 管理员 | admin | admin123 |
| 普通用户 | zhangsan | 123456 |

## API 接口

| 前缀 | 权限 | 说明 |
|------|------|------|
| `POST /api/auth/login` | 公开 | 用户登录 |
| `POST /api/auth/register` | 公开 | 用户注册 |
| `GET /api/goods/list` | 公开 | 商品列表/搜索 |
| `GET /api/goods/detail/{uuid}` | 公开 | 商品详情 |
| `GET /api/category` | 公开 | 分类列表 |
| `POST /api/goods/publish` | 需登录 | 发布商品 |
| `PUT /api/goods/{uuid}` | 需登录 | 编辑商品 |
| `POST /api/orders` | 需登录 | 创建订单 |
| `GET /api/orders/buyer` | 需登录 | 我的购买 |
| `GET /api/orders/seller` | 需登录 | 我的销售 |
| `GET /api/chat/conversation/{id}` | 需登录 | 聊天记录 |
| `GET /api/admin/dashboard` | 管理员 | 仪表盘数据 |
| `GET /api/admin/users` | 管理员 | 用户管理 |
| `/ws/chat` | 需登录 | WebSocket 端点 |

## 数据库

项目使用 MySQL 8，包含 11 张数据表：

`user` · `category` · `goods` · `goods_image` · `orders` · `favorite` · `wallet` · `message` · `report` · `notification`

完整 DDL 与种子数据见 [db/schema.sql](db/schema.sql)

## 团队

- 北京林业大学 · 信息学院
- 《软件工程（课程设计）》2026春 · T-02 SwapCampus

## 许可证

MIT License
