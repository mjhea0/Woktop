class AddOriginToDropboxFiles < ActiveRecord::Migration
  def change
    add_column :dropbox_files, :origin, :integer
  end
end
