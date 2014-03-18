class AddTransferToProducts < ActiveRecord::Migration
  def change
    add_column :operations, :transfer, :integer
  end
end
