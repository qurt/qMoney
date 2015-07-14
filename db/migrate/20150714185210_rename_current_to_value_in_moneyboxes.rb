class RenameCurrentToValueInMoneyboxes < ActiveRecord::Migration
  def change
    rename_column :moneyboxes, :current, :value
  end
end
