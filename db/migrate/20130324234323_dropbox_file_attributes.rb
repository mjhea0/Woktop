class DropboxFileAttributes < ActiveRecord::Migration
  def up
    remove_column :dropbox_files, :bytes
    add_column :dropbox_files, :size, :string
  end

  def down
  end
end
