require "rails_helper"

RSpec.describe ReportsController, type: :controller do
  let(:customer) { create(:customer) }
  let(:product) { create(:product, price: 100) }

  describe "GET #monthly_sales" do
    before do
      order1 = create(:order, customer: customer, delivery_date: Date.new(2026, 7, 15))
      order2 = create(:order, customer: customer, delivery_date: Date.new(2026, 7, 20))
      create(:order_item, order: order1, product: product, qty: 2, price: 100)
      create(:order_item, order: order2, product: product, qty: 3, price: 100)
    end

    it "returns daily sales data for the given month" do
      get :monthly_sales, params: { year: 2026, month: 7 }
      expect(response).to have_http_status(:ok)
      json = JSON.parse(response.body)
      expect(json["data"]).to be_an(Array)
      expect(json["meta"]["year"]).to eq(2026)
      expect(json["meta"]["month"]).to eq(7)
      expect(json["data"].first).to include("date", "total_amount", "order_count", "total_qty")
    end

    it "returns empty data for month with no orders" do
      get :monthly_sales, params: { year: 2025, month: 1 }
      expect(response).to have_http_status(:ok)
      json = JSON.parse(response.body)
      expect(json["data"]).to be_empty
    end
  end

  describe "GET #top_products" do
    before do
      order_a = create(:order, customer: customer, delivery_date: Date.new(2026, 7, 10))
      order_b = create(:order, customer: customer, delivery_date: Date.new(2026, 7, 15))
      create(:order_item, order: order_a, product: create(:product, name: "产品A", price: 100), qty: 10, price: 100)
      create(:order_item, order: order_b, product: create(:product, name: "产品B", price: 200), qty: 2, price: 200)
    end

    it "returns top products ranked by total_amount desc" do
      get :top_products, params: { year: 2026, month: 7, limit: 10 }
      expect(response).to have_http_status(:ok)
      json = JSON.parse(response.body)
      expect(json["data"].length).to eq(2)
      expect(json["data"].first["name"]).to eq("产品A")
      expect(json["data"].first["total_amount"].to_f).to eq(1000.0)
    end

    it "respects limit parameter" do
      get :top_products, params: { year: 2026, month: 7, limit: 1 }
      json = JSON.parse(response.body)
      expect(json["data"].length).to eq(1)
    end
  end
end
