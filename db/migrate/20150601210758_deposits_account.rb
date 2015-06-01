class DepositsAccount < ActiveRecord::Migration
  def change
    add_column :accounts, :deposit, :boolean, default: false
    add_column :accounts, :percentage, :decimal, precision: 10, scale: 2
  end
end
