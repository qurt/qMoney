class AddOperationDateToOperations < ActiveRecord::Migration
  def change
    add_column :operations, :operation_date, :datetime
  end
end
