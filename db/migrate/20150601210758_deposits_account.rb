class DepositsAccount < ActiveRecord::Migration
  def change
    add_column :accounts, :deposit, :boolean, default: false
  end
end
