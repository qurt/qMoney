class CreateTableOperationsTags < ActiveRecord::Migration
  def change
    create_table :operations_tags do |t|
      t.belongs_to :operation, index: true
      t.belongs_to :tag, index: true
    end
  end
end
