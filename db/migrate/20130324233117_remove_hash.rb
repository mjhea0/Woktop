class RemoveHash < ActiveRecord::Migration
  def up
    remove_column :dropbox_files, :fileHash
  end

  def down
  end
end
