require "rails_helper"

RSpec.describe ProductsController, type: :controller do
  describe "GET #index" do
    let!(:product1) { create(:product, name: "苹果手机", category: "电子", status: :active, price: 5000) }
    let!(:product2) { create(:product, name: "香蕉", category: "水果", status: :inactive, price: 10) }

    it "returns all products with pagination meta" do
      get :index
      expect(response).to have_http_status(:ok)
      json = JSON.parse(response.body)
      expect(json["data"].length).to eq(2)
      expect(json["meta"]).to include("current_page", "total_pages", "total_count")
    end

    it "filters by search keyword" do
      get :index, params: { name: "苹果" }
      json = JSON.parse(response.body)
      expect(json["data"].length).to eq(1)
      expect(json["data"].first["name"]).to eq("苹果手机")
    end

    it "filters by category" do
      get :index, params: { category: "水果" }
      json = JSON.parse(response.body)
      expect(json["data"].length).to eq(1)
      expect(json["data"].first["category"]).to eq("水果")
    end

    it "filters by status" do
      get :index, params: { status: "inactive" }
      json = JSON.parse(response.body)
      expect(json["data"].length).to eq(1)
      expect(json["data"].first["status"]).to eq("inactive")
    end
  end

  describe "GET #show" do
    let!(:product) { create(:product) }

    it "returns the product" do
      get :show, params: { id: product.id }
      expect(response).to have_http_status(:ok)
      json = JSON.parse(response.body)
      expect(json["data"]["id"]).to eq(product.id)
    end

    it "returns 404 for non-existent product" do
      get :show, params: { id: 99999 }
      expect(response).to have_http_status(:not_found)
      json = JSON.parse(response.body)
      expect(json["errors"]).to include("产品不存在")
    end
  end

  describe "POST #create" do
    it "creates a product with valid params" do
      expect {
        post :create, params: { product: attributes_for(:product) }
      }.to change(Product, :count).by(1)
      expect(response).to have_http_status(:created)
    end

    it "returns errors with invalid params" do
      post :create, params: { product: { name: "" } }
      expect(response).to have_http_status(:unprocessable_entity)
      json = JSON.parse(response.body)
      expect(json["errors"]).to be_present
    end
  end

  describe "PATCH #update" do
    let!(:product) { create(:product) }

    it "updates the product" do
      patch :update, params: { id: product.id, product: { name: "新名称" } }
      expect(response).to have_http_status(:ok)
      expect(product.reload.name).to eq("新名称")
    end

    it "returns errors with invalid params" do
      patch :update, params: { id: product.id, product: { price: -1 } }
      expect(response).to have_http_status(:unprocessable_entity)
    end
  end

  describe "DELETE #destroy" do
    let!(:product) { create(:product) }

    it "deletes the product" do
      expect {
        delete :destroy, params: { id: product.id }
      }.to change(Product, :count).by(-1)
      expect(response).to have_http_status(:no_content)
    end
  end
end
