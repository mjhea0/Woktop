class AddUserToDrive < ActiveRecord::Migration
  def change
    add_column :drive_users, :user_id, :integer
  end
end
