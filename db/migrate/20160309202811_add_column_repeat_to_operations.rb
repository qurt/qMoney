class AddColumnRepeatToOperations < ActiveRecord::Migration
  def change
    add_column :operations, :repeat, :boolean
  end
end
