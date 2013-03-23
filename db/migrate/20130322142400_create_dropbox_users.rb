class CreateDropboxUsers < ActiveRecord::Migration
  def change
    create_table :dropbox_users do |t|
      t.integer :user_id
      t.string :access_token
      t.string :referral_link
      t.string :display_name
      t.integer :uid
      t.string :country
      t.float :quota_normal
      t.float :quota_shared
      t.float :quota_total

      t.timestamps
    end
  end
end
