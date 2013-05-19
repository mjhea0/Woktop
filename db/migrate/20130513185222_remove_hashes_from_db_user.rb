class RemoveHashesFromDbUser < ActiveRecord::Migration
  def up
  	remove_column :dropbox_files, :folderHash
  	remove_column :dropbox_files, :parent_hash
  end

  def down
  end
end
