class AddNameFieldToDropboxUser < ActiveRecord::Migration
  def change
    add_column :dropbox_users, :name, :string
  end
end
