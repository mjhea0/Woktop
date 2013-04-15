class ChangeTypeToFileType < ActiveRecord::Migration
  def up
    remove_column :dropbox_files, :type
    add_column :dropbox_files, :fileType, :string
  end

  def down
  end
end
