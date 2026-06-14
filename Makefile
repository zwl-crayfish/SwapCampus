.PHONY: up down restart logs clean

# 启动所有服务
up:
	docker-compose up -d

# 停止所有服务
down:
	docker-compose down

# 重启所有服务
restart:
	docker-compose down && docker-compose up -d

# 查看日志
logs:
	docker-compose logs -f

# 清理
clean:
	docker-compose down -v

# 启动开发环境 (仅数据库和中间件)
dev-infra:
	docker-compose up -d mysql redis minio

# 启动后端
dev-backend:
	cd backend && ./mvnw spring-boot:run

# 启动前端
dev-frontend:
	cd frontend && npm run dev
