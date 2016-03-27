class DeleteColumnRepeatFromOperations < ActiveRecord::Migration
  def change
    remove_column :operations, :repeat
    drop_table :regular_operations
    drop_table :repeat_operations
  end
end
