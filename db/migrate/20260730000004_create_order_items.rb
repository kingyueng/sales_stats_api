class CreateOrderItems < ActiveRecord::Migration[7.1]
  def change
    create_table :order_items do |t|
      t.references :order, null: false, foreign_key: true, comment: "订单"
      t.references :product, null: false, foreign_key: true, comment: "产品"
      t.integer :qty, null: false, comment: "数量"
      t.decimal :price, precision: 10, scale: 2, null: false, comment: "单价"

      t.timestamps
    end
  end
end
