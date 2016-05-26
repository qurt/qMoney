class AddColumnLimitToAccount < ActiveRecord::Migration
  def change
    add_column :accounts, :limit, :decimal, :default => 0
  end
end
