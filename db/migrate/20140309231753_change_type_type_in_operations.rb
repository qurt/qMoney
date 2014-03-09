class ChangeTypeTypeInOperations < ActiveRecord::Migration
  def change
    change_column :operations, :type, :integer
  end
end
