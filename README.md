# Sales Stats API

销售统计 API 服务，基于 Rails 8 API 模式。

## 环境要求

- Docker
- Docker Compose v2

## 快速开始

```bash
# 进入项目文件夹
cd sales_stats_api

# 一键启动
./start.sh
```

## API 接口

| 方法 | 路径 | 说明 |
|------|------|------|
| GET | /products | 产品列表（分页、搜索、过滤） |
| POST | /products | 创建产品 |
| GET | /products/:id | 产品详情 |
| PATCH | /products/:id | 更新产品 |
| DELETE | /products/:id | 删除产品 |
| GET | /reports/monthly_sales | 月销售报表 |
| GET | /reports/top_products | 热门产品排行 |

### 产品列表参数

```
GET /products?page=1&per=20&name=xxx&category=xxx&status=0
```

### 报表参数

```
GET /reports/monthly_sales?year=2026&month=7
GET /reports/top_products?year=2026&month=7&limit=10
```
