class ChangeHashToFolderHash < ActiveRecord::Migration
  def up
  	remove_column :dropbox_files, :hash
    add_column :dropbox_files, :folderHash, :string
  end

  def down
  end
end
