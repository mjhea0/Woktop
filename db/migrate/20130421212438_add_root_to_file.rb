class AddRootToFile < ActiveRecord::Migration
  def change
    add_column :dropbox_files, :folder_hash, :string
  end
end
