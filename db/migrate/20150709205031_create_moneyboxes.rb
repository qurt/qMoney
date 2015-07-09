class CreateMoneyboxes < ActiveRecord::Migration
  def change
    create_table :moneyboxes do |t|
      t.decimal :summary
      t.decimal :current
      t.decimal :percentage
      t.string :name

      t.timestamps null: false
    end
  end
end
