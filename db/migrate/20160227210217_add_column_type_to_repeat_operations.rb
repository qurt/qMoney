class AddColumnTypeToRepeatOperations < ActiveRecord::Migration
  def change
    add_column :repeat_operations, :type, :integer
  end
end
