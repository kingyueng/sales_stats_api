class ReportsController < ApplicationController
  # GET /reports/monthly_sales?year=2026&month=7
  def monthly_sales
    year = params[:year].to_i
    month = params[:month].to_i

    start_date = Date.new(year, month, 1)
    end_date = start_date.end_of_month

    sales = Order.where(delivery_date: start_date..end_date)
                 .group(Arel.sql("DATE_TRUNC('day', delivery_date)"))
                 .order(Arel.sql("DATE_TRUNC('day', delivery_date)"))
                 .select(
                   Arel.sql("DATE_TRUNC('day', delivery_date) AS date"),
                   "SUM(total_amount) AS total_amount",
                   "COUNT(id) AS order_count",
                   "SUM(total_qty) AS total_qty"
                 )

    render json: { data: sales, meta: { year: year, month: month } }
  end

  # GET /reports/top_products?limit=10&year=2026&month=7
  def top_products
    limit = (params[:limit] || 10).to_i
    year = params[:year].to_i
    month = params[:month].to_i

    start_date = Date.new(year, month, 1)
    end_date = start_date.end_of_month

    products = Product.joins(order_items: :order)
                      .where(orders: { delivery_date: start_date..end_date })
                      .group("products.id", "products.name")
                      .order("total_amount DESC")
                      .limit(limit)
                      .select(
                        "products.id",
                        "products.name",
                        "SUM(order_items.qty * order_items.price) AS total_amount",
                        "SUM(order_items.qty) AS total_qty",
                        "COUNT(DISTINCT orders.id) AS order_count"
                      )

    render json: { data: products, meta: { year: year, month: month, limit: limit } }
  end
end
