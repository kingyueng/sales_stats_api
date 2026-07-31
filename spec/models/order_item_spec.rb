require "rails_helper"

RSpec.describe OrderItem, type: :model do
  describe "associations" do
    it { is_expected.to belong_to(:order) }
    it { is_expected.to belong_to(:product) }
  end

  describe "validations" do
    it { is_expected.to validate_presence_of(:qty) }
    it { is_expected.to validate_numericality_of(:qty).is_greater_than(0).only_integer }
    it { is_expected.to validate_presence_of(:price) }
    it { is_expected.to validate_numericality_of(:price).is_greater_than(0) }
  end

  describe "callbacks" do
    let(:order) { create(:order) }
    let(:product) { create(:product) }

    it "updates order total after create" do
      create(:order_item, order: order, product: product, qty: 5, price: 100)
      expect(order.reload.total_amount).to eq(500)
      expect(order.total_qty).to eq(5)
    end

    it "updates order total after update" do
      item = create(:order_item, order: order, product: product, qty: 5, price: 100)
      item.update!(qty: 10)
      expect(order.reload.total_amount).to eq(1000)
      expect(order.total_qty).to eq(10)
    end

    it "updates order total after destroy" do
      create(:order_item, order: order, product: product, qty: 5, price: 100)
      create(:order_item, order: order, product: product, qty: 3, price: 50)
      order.order_items.first.destroy!
      expect(order.reload.total_amount).to eq(150)
      expect(order.total_qty).to eq(3)
    end

    it "skips update when qty and price unchanged" do
      item = create(:order_item, order: order, product: product, qty: 5, price: 100)
      expect(order).not_to receive(:update_total)
      item.update!(qty: 5, price: 100)
    end
  end

  describe "factory" do
    it "has a valid factory" do
      order_item = build(:order_item)
      expect(order_item).to be_valid
    end
  end
end
