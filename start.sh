#!/bin/bash
set -e

cleanup() {
    echo ""
    echo -e "${YELLOW}出错了，正在停止容器...${NC}"
    docker compose stop 2>/dev/null
}
trap cleanup ERR

# 颜色定义
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

echo -e "${GREEN}========================================${NC}"
echo -e "${GREEN}  Sales Stats API - Docker 部署脚本${NC}"
echo -e "${GREEN}========================================${NC}"
echo ""

# 环境要求检查
echo -e "${YELLOW}[1/6] 检查环境要求...${NC}"

if command -v docker &> /dev/null; then
    echo -e "  ✅ docker: $(command -v docker)"
else
    echo -e "  ${RED}❌ docker 未安装，请先安装${NC}"
    exit 1
fi

# 检查 Docker Compose 版本（支持 v2 和 v1）
if docker compose version &> /dev/null; then
    echo -e "  ✅ docker compose: $(docker compose version --short 2>/dev/null || echo '已安装')"
else
    echo -e "  ${RED}❌ docker compose 不可用${NC}"
    exit 1
fi

# 检查端口占用
echo ""
echo -e "${YELLOW}[2/6] 检查端口占用...${NC}"
if lsof -i :3000 &> /dev/null 2>&1; then
    echo -e "  ${RED}⚠️  端口 3000 已被占用，请先释放端口${NC}"
    echo -e "  占用进程："
    lsof -i :3000
    exit 1
else
    echo -e "  ✅ 端口 3000 可用"
fi

if lsof -i :5432 &> /dev/null 2>&1; then
    echo -e "  ${YELLOW}⚠️  端口 5432 已被占用（可能是本地 PostgreSQL），Docker PostgreSQL 将使用该端口${NC}"
else
    echo -e "  ✅ 端口 5432 可用"
fi

# 启动容器
echo ""
echo -e "${YELLOW}[3/7] 启动容器...${NC}"
docker compose up -d

# 安装依赖
echo ""
echo -e "${YELLOW}[4/7] 安装 gem 依赖...${NC}"
docker compose exec app bundle install

# 等待数据库就绪
echo ""
echo -e "${YELLOW}[5/7] 等待数据库就绪...${NC}"
until docker compose exec -T db pg_isready -U postgres &> /dev/null; do
    echo "  等待 PostgreSQL 启动..."
    sleep 2
done
echo -e "  ✅ 数据库已就绪"

# 数据库初始化
echo ""
echo -e "${YELLOW}[6/7] 数据库初始化...${NC}"
docker compose exec app rails db:create db:migrate

# 启动 Rails Server
echo ""
echo -e "${YELLOW}[7/7] 启动 Rails Server...${NC}"
docker compose exec -d app bash -c "rm -f tmp/pids/server.pid && rails server -b 0.0.0.0"

# 验证
echo ""
echo -e "${GREEN}========================================${NC}"
echo -e "${GREEN}  ✅ 启动完成！${NC}"
echo -e "${GREEN}========================================${NC}"
echo ""
echo -e "访问地址: ${GREEN}http://localhost:3000${NC}"
echo ""
echo -e "${YELLOW}常用命令：${NC}"
echo -e "  docker compose logs -f app       - 查看日志"
echo -e "  docker compose exec app rails c  - Rails 控制台"
echo -e "  docker compose exec app rspec    - 运行测试"
echo -e "  docker compose stop              - 停止服务"
echo -e "  docker compose down              - 停止并删除容器(慎用)"
echo -e "  docker compose ps                - 查看服务状态"
echo ""
