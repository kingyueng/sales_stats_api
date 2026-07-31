require "rails_helper"

RSpec.describe Product, type: :model do
  describe "associations" do
    it { is_expected.to have_many(:order_items).dependent(:restrict_with_error) }
    it { is_expected.to have_many(:orders).through(:order_items) }
  end

  describe "enums" do
    it { is_expected.to define_enum_for(:status).with_values(active: 0, inactive: 1) }
  end

  describe "validations" do
    it { is_expected.to validate_presence_of(:name) }
    it { is_expected.to validate_presence_of(:category) }
    it { is_expected.to validate_presence_of(:price) }
    it { is_expected.to validate_numericality_of(:price).is_greater_than(0) }
  end

  describe "factory" do
    it "has a valid factory" do
      product = build(:product)
      expect(product).to be_valid
    end

    it "inactive trait works" do
      product = build(:product, :inactive)
      expect(product.status).to eq("inactive")
    end
  end
end
