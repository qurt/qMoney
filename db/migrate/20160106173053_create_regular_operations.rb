class CreateRegularOperations < ActiveRecord::Migration
  def change
    create_table :regular_operations do |t|
      t.string :title
      t.integer :type
      t.decimal :value
      t.string :description
      t.integer :account_id
      t.integer :category_id
      t.string :operation_date

      t.timestamps null: false
    end
  end
end
