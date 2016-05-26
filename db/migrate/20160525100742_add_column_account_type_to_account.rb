class AddColumnAccountTypeToAccount < ActiveRecord::Migration
  def change
    add_column :accounts, :account_type, :integer, :default => 0
  end
end
