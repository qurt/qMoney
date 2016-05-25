class ChangeImportRulesTable < ActiveRecord::Migration
  def change
    remove_column :import_rules, :type
    remove_column :import_rules, :value
    remove_column :import_rules, :rule
    add_column :import_rules, :import_column, :string
    add_column :import_rules, :import_value, :string
    add_column :import_rules, :operation_column, :string
    add_column :import_rules, :operation_value, :string
  end
end
