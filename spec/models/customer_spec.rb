require "rails_helper"

RSpec.describe Customer, type: :model do
  describe "associations" do
    it { is_expected.to have_many(:orders).dependent(:restrict_with_error) }
  end

  describe "validations" do
    it { is_expected.to validate_presence_of(:name) }
    it { is_expected.to validate_presence_of(:area) }
    it { is_expected.to validate_presence_of(:level) }
  end

  describe "factory" do
    it "has a valid factory" do
      customer = build(:customer)
      expect(customer).to be_valid
    end
  end
end
