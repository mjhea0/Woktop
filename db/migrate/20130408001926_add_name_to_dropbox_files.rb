class AddNameToDropboxFiles < ActiveRecord::Migration
  def change
    add_column :dropbox_files, :name, :string
  end
end
