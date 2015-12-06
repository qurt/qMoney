class CreateSessions < ActiveRecord::Migration
  def change
    create_table :sessions do |t|
      t.integer :user_id
      t.string :token
      t.integer :expired_in

      t.timestamps null: false
    end
  end
end
