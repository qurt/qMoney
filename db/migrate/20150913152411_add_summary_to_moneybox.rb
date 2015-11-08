class AddSummaryToMoneybox < ActiveRecord::Migration
  def change
    add_column :moneyboxes, :summary, :decimal
  end
end
