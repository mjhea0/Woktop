class ChangeIconToType < ActiveRecord::Migration
  def up
    remove_column :dropbox_files, :icon
    add_column :dropbox_files, :type, :string
  end

  def down
  end
end
