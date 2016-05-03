class AddColumnOperationDateToNotebooks < ActiveRecord::Migration
  def change
    add_column :notebooks, :operation_date, :datetime
  end
end
