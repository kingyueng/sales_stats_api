class Order < ApplicationRecord
  belongs_to :customer
  has_many :order_items, dependent: :destroy
  has_many :products, through: :order_items

  validates :delivery_date, presence: true

  def update_total
    update_columns(
      total_amount: order_items.sum("qty * price"),
      total_qty: order_items.sum(:qty)
    )
  end
end
