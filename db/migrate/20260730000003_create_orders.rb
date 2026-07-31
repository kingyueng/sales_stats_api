class CreateOrders < ActiveRecord::Migration[7.1]
  def change
    create_table :orders do |t|
      t.references :customer, null: false, foreign_key: true, comment: "客户"
      t.date :delivery_date, null: false, comment: "交付日期"
      t.decimal :total_amount, precision: 12, scale: 2, default: 0, null: false, comment: "订单总额"
      t.integer :total_qty, default: 0, null: false, comment: "订单总数量"

      t.timestamps
    end

    add_index :orders, :delivery_date
  end
end
