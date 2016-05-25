class AddColumnArchiveToAccounts < ActiveRecord::Migration
  def change
    add_column :accounts, :archive, :boolean, :dafault => false
  end
end
