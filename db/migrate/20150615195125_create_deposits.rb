class CreateDeposits < ActiveRecord::Migration
  def change
    create_table :deposits do |t|
      t.integer :account_id
      t.decimal :percentage

      t.timestamps null: false
    end
  end
end
