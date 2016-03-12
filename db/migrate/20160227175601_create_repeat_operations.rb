class CreateRepeatOperations < ActiveRecord::Migration
  def change
    create_table :repeat_operations do |t|
      t.decimal :value
      t.string :description
      t.integer :account_id
      t.integer :category_id
      t.integer :duration

      t.timestamps null: false
    end
  end
end
