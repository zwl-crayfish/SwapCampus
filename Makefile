.PHONY: up down restart logs clean \
        dev-infra dev-backend dev-frontend \
        build build-backend build-frontend \
        push push-backend push-frontend \
        k8s-deploy k8s-destroy k8s-status

# ============================================
# Docker Compose — 本地部署
# ============================================

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

# 清理（含数据卷）
clean:
	docker-compose down -v

# ============================================
# 开发环境
# ============================================

# 启动开发环境（仅数据库和中间件）
dev-infra:
	docker-compose up -d mysql redis minio

# 启动后端（本地 Maven）
dev-backend:
	cd backend && ./mvnw spring-boot:run

# 启动前端（本地 Vite）
dev-frontend:
	cd frontend && npm run dev

# ============================================
# Docker 镜像构建
# ============================================

# 构建所有镜像
build: build-backend build-frontend

# 构建后端镜像
build-backend:
	docker build -t swapcampus/backend:latest ./backend

# 构建前端镜像
build-frontend:
	docker build -t swapcampus/frontend:latest ./frontend

# ============================================
# Docker 镜像推送（需先登录 ghcr.io）
# ============================================

REGISTRY ?= ghcr.io/zwl-crayfish

# 推送所有镜像
push: push-backend push-frontend

# 推送后端镜像
push-backend: build-backend
	docker tag swapcampus/backend:latest $(REGISTRY)/swapcampus-backend:latest
	docker push $(REGISTRY)/swapcampus-backend:latest

# 推送前端镜像
push-frontend: build-frontend
	docker tag swapcampus/frontend:latest $(REGISTRY)/swapcampus-frontend:latest
	docker push $(REGISTRY)/swapcampus-frontend:latest

# ============================================
# Kubernetes — 集群部署
# ============================================

# 一键部署到 K8s
k8s-deploy:
	kubectl apply -k infra/k8s/

# 销毁 K8s 资源
k8s-destroy:
	kubectl delete -k infra/k8s/

# 查看部署状态
k8s-status:
	kubectl get all -n swapcampus
	kubectl get ingress -n swapcampus
	kubectl get pvc -n swapcampus
