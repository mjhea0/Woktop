class CreateDropboxFiles < ActiveRecord::Migration
  def change
    create_table :dropbox_files do |t|
      t.integer :uid
      t.float :bytes
      t.string :path
      t.boolean :directory
      t.string :rev
      t.string :hash
      t.string :icon

      t.timestamps
    end
  end
end
