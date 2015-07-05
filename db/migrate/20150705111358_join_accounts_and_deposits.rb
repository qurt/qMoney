class JoinAccountsAndDeposits < ActiveRecord::Migration
  def change
    add_column :accounts, :deposit, :boolean, :default => false
    add_column :accounts, :percentage, :decimal, :default => 0
    drop_table :deposits
  end
end
