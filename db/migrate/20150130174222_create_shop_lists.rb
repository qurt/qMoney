class CreateShopLists < ActiveRecord::Migration
  def change
    create_table :shop_lists do |t|
      t.string :name
      t.boolean :active
      t.decimal :value

      t.timestamps
    end
  end
end
