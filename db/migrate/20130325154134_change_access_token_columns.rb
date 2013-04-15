class ChangeAccessTokenColumns < ActiveRecord::Migration
  def up
    add_column :dropbox_users, :access_token_key, :string
    add_column :dropbox_users, :access_token_secret, :string
    remove_column :dropbox_users, :access_token
  end

  def down
  end
end
