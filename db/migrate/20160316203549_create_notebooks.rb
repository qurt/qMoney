class CreateNotebooks < ActiveRecord::Migration
  def change
    create_table :notebooks do |t|
      t.decimal :value
      t.string :description

      t.timestamps null: false
    end
  end
end
