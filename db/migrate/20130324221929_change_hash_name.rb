class ChangeHashName < ActiveRecord::Migration
  def up
  end
  
  def change
    rename_column :dropbox_files, :hash, :fileHash
  end

  def down
  end
end
