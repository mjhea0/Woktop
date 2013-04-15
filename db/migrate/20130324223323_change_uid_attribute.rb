class ChangeUidAttribute < ActiveRecord::Migration
  def up
  end
  
  def change
    rename_column :dropbox_files, :uid, :dropbox_user_id
  end

  def down
  end
end
