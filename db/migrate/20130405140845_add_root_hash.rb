class AddRootHash < ActiveRecord::Migration
  def up
    add_column :dropbox_users, :root_hash, :string
  end

  def down
  end
end
