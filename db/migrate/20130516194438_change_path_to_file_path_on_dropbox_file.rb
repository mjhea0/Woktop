class ChangePathToFilePathOnDropboxFile < ActiveRecord::Migration
  def up
  	rename_column :dropbox_files, :path, :file_path
  end

  def down
  	rename_column :dropbox_files, :file_path, :path
  end
end
