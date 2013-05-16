class AddAncestryToDropboxFile < ActiveRecord::Migration
  def change
    add_column :dropbox_files, :ancestry, :string
    add_index :dropbox_files, :ancestry
  end
end
