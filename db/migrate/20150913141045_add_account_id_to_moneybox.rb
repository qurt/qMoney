class AddAccountIdToMoneybox < ActiveRecord::Migration
  def change
    add_column :moneyboxes, :account_id, :integer
  end
end
