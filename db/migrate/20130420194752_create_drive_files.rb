class CreateDriveFiles < ActiveRecord::Migration
  def change
    create_table :drive_files do |t|
      t.integer :drive_user_id
      t.string :file_id
      t.string :download_link
      t.string :name
      t.string :fileType
      t.string :description
      t.float :size
      t.string :path

      t.timestamps
    end
  end
end
