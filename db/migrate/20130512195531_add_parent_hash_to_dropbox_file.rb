class AddParentHashToDropboxFile < ActiveRecord::Migration
  def change
    add_column :dropbox_files, :parent_hash, :string
  end
end
