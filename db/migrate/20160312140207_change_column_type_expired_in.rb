class ChangeColumnTypeExpiredIn < ActiveRecord::Migration
  def change
    change_column :sessions, :expired_in, :decimal
  end
end
