class RemoveColumnFromMoneyboxes < ActiveRecord::Migration
  def change
    remove_column :moneyboxes, :summary, :decimal
    remove_column :moneyboxes, :value, :decimal
    remove_column :moneyboxes, :name, :decimal
  end
end
