class CreateOperations < ActiveRecord::Migration
  def change
    create_table :operations do |t|
      t.decimal :value
      t.boolean :type
      t.string :description
      t.integer :account_id

      t.timestamps
    end
  end
end
