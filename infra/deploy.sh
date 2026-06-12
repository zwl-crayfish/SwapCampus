#!/bin/bash
# ============================================
# SwapCampus K8s 部署脚本
# ============================================
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
PROJECT_DIR="$(dirname "$SCRIPT_DIR")"
K8S_DIR="$PROJECT_DIR/infra/k8s"

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

log()  { echo -e "${GREEN}[INFO]${NC} $*"; }
warn() { echo -e "${YELLOW}[WARN]${NC} $*"; }
err()  { echo -e "${RED}[ERROR]${NC} $*"; }

# ---------------------
# 前置检查
# ---------------------
check_prereqs() {
  log "检查前置条件..."

  if ! command -v kubectl &>/dev/null; then
    err "未安装 kubectl，请先安装: https://kubernetes.io/docs/tasks/tools/"
    exit 1
  fi

  if ! kubectl cluster-info &>/dev/null; then
    err "无法连接 Kubernetes 集群，请检查 kubeconfig"
    exit 1
  fi

  log "kubectl 已就绪，集群连接正常"
}

# ---------------------
# 创建 Schema ConfigMap
# ---------------------
create_schema_configmap() {
  local schema_file="$PROJECT_DIR/db/schema.sql"

  if [[ ! -f "$schema_file" ]]; then
    err "找不到 schema.sql: $schema_file"
    exit 1
  fi

  local seed_file="$PROJECT_DIR/db/seed.sql"

  log "创建数据库 schema ConfigMap..."
  kubectl create configmap db-schema \
    --from-file=schema.sql="$schema_file" \
    --from-file=seed.sql="$seed_file" \
    --namespace=swapcampus \
    --dry-run=client -o yaml | kubectl apply -f -
}

# ---------------------
# 部署
# ---------------------
deploy() {
  log "开始部署 SwapCampus 到 Kubernetes..."

  # 1. 创建 schema configmap
  create_schema_configmap

  # 2. 部署所有资源（Kustomize）
  log "应用 Kustomize 配置..."
  kubectl apply -k "$K8S_DIR"

  log "等待关键 Pod 就绪..."

  # 3. 等待 MySQL
  kubectl wait --for=condition=ready pod -l app=mysql -n swapcampus --timeout=120s || true

  # 4. 运行数据库初始化 Job
  log "执行数据库初始化..."
  kubectl delete job db-init -n swapcampus --ignore-not-found=true
  kubectl create -f "$K8S_DIR/db-init-job.yaml"
  kubectl wait --for=condition=complete job/db-init -n swapcampus --timeout=120s || true

  # 5. 等待后端和前端
  kubectl wait --for=condition=ready pod -l app=backend -n swapcampus --timeout=180s || true
  kubectl wait --for=condition=ready pod -l app=frontend -n swapcampus --timeout=60s || true

  log "部署完成！"
  kubectl get all -n swapcampus
  echo ""
  log "查看 Ingress 地址: kubectl get ingress -n swapcampus"
}

# ---------------------
# 销毁
# ---------------------
destroy() {
  warn "即将删除 SwapCampus 所有 K8s 资源（PV/PVC 不会自动删除）"
  read -rp "确认删除? (yes/no): " confirm
  if [[ "$confirm" != "yes" ]]; then
    log "已取消"
    exit 0
  fi

  kubectl delete -k "$K8S_DIR" || true
  kubectl delete configmap db-schema -n swapcampus || true
  log "资源已删除"
}

# ---------------------
# Main
# ---------------------
case "${1:-deploy}" in
  deploy)
    check_prereqs
    deploy
    ;;
  destroy|delete|down)
    check_prereqs
    destroy
    ;;
  status)
    kubectl get all -n swapcampus
    kubectl get ingress -n swapcampus
    kubectl get pvc -n swapcampus
    ;;
  *)
    echo "用法: $0 {deploy|destroy|status}"
    exit 1
    ;;
esac
