class OrderItem < ApplicationRecord
  belongs_to :order
  belongs_to :product

  validates :qty, presence: true, numericality: { greater_than: 0, only_integer: true }
  validates :price, presence: true, numericality: { greater_than: 0 }

  after_commit :update_order_total

  private

  def update_order_total
    return if persisted? && !saved_changes.slice("qty", "price").any?

    order.update_total
  end
end
