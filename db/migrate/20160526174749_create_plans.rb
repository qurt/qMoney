class CreatePlans < ActiveRecord::Migration
  def change
    create_table :plans do |t|
      t.integer :month
      t.integer :year
      t.integer :category_id
      t.decimal :value
      t.integer :operation_type
      t.decimal :total

      t.timestamps null: false
    end
  end
end
