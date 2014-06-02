class ChangeAccountDecimalScale < ActiveRecord::Migration
  def change
    change_column :accounts, :value, :decimal, precision: 10, scale: 2
  end
end
