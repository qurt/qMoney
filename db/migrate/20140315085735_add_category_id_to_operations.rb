class AddCategoryIdToOperations < ActiveRecord::Migration
  def change
    add_column :operations, :category_id, :integer
  end
end
