class AddHashToDropboxFile < ActiveRecord::Migration
  def change
    add_column :dropbox_files, :hash, :string
  end
end