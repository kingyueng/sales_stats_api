class CreateCustomers < ActiveRecord::Migration[7.1]
  def change
    create_table :customers do |t|
      t.string :name, null: false, comment: "客户名称"
      t.string :area, null: false, comment: "区域"
      t.string :level, null: false, comment: "客户等级"

      t.timestamps
    end

    add_index :customers, :name
    add_index :customers, :area
    add_index :customers, :level
  end
end
