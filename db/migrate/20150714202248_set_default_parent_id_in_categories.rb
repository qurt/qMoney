class SetDefaultParentIdInCategories < ActiveRecord::Migration
  def change
    change_column :categories, :parent_id, :integer, :default => nil
  end
end
