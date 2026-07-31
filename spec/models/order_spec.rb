require "rails_helper"

RSpec.describe Order, type: :model do
  describe "associations" do
    it { is_expected.to belong_to(:customer) }
    it { is_expected.to have_many(:order_items).dependent(:destroy) }
    it { is_expected.to have_many(:products).through(:order_items) }
  end

  describe "validations" do
    it { is_expected.to validate_presence_of(:delivery_date) }
  end

  describe "#update_total" do
    let(:order) { create(:order) }
    let(:product) { create(:product) }

    it "syncs total_amount and total_qty from order_items" do
      create(:order_item, order: order, product: product, qty: 3, price: 100)
      create(:order_item, order: order, product: product, qty: 2, price: 50)
      order.update_total
      expect(order.total_amount).to eq(400)
      expect(order.total_qty).to eq(5)
    end

    it "resets to 0 when no order_items" do
      order.update_total
      expect(order.total_amount).to eq(0)
      expect(order.total_qty).to eq(0)
    end
  end

  describe "factory" do
    it "has a valid factory" do
      order = build(:order)
      expect(order).to be_valid
    end
  end
end
