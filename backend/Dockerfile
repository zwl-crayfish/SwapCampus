# ============================================
# SwapCampus 后端 — 多阶段 Docker 构建
# ============================================

# ---- Stage 1: 编译 ----
FROM eclipse-temurin:17-jdk-alpine AS build

# Alpine 需要手动安装 mvnw 依赖的 curl 和 unzip
RUN apk add --no-cache curl unzip

WORKDIR /app

# 先复制依赖描述文件，利用 Docker 层缓存加速
COPY mvnw pom.xml ./
COPY .mvn .mvn

# 下载依赖（单独一层，源码未变时复用缓存）
RUN chmod +x mvnw && ./mvnw dependency:resolve -q

# 复制源码
COPY src src

# 编译打包（跳过测试，测试在 CI 中已跑过）
RUN ./mvnw package -DskipTests -q

# ---- Stage 2: 运行 ----
FROM eclipse-temurin:17-jre-alpine AS runtime

WORKDIR /app

# 创建非 root 用户
RUN addgroup -g 1000 appgroup && \
    adduser -u 1000 -G appgroup -D appuser

# 从编译阶段复制 JAR
COPY --from=build /app/target/swapcampus-1.0.0.jar app.jar

# 切换到非 root 用户
USER appuser

EXPOSE 8080

# JVM 调优参数可通过环境变量覆盖
ENTRYPOINT ["java", "-jar", "app.jar"]
