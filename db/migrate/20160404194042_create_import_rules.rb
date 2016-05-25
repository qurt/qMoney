class CreateImportRules < ActiveRecord::Migration
  def change
    create_table :import_rules do |t|
      t.string :type
      t.integer :value
      t.string :rule

      t.timestamps null: false
    end
  end
end
