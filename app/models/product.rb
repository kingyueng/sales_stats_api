class Product < ApplicationRecord
  has_many :order_items, dependent: :restrict_with_error
  has_many :orders, through: :order_items

  enum :status, { active: 0, inactive: 1 }

  validates :name, presence: true
  validates :category, presence: true
  validates :price, presence: true, numericality: { greater_than: 0 }
end
