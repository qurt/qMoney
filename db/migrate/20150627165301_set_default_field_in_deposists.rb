class SetDefaultFieldInDeposists < ActiveRecord::Migration
  def change
    change_column :deposits, :percentage, :decimal, :default => 0
  end
end
