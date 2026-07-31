class CreateProducts < ActiveRecord::Migration[7.1]
  def change
    create_table :products do |t|
      t.string :name, null: false, comment: "产品名称"
      t.string :category, null: false, comment: "产品类别"
      t.decimal :price, precision: 10, scale: 2, null: false, comment: "单价"
      t.integer :status, default: 0, null: false, comment: "状态"

      t.timestamps
    end

    add_index :products, :name
    add_index :products, :category
    add_index :products, :status
  end
end
