class DriveUser < ActiveRecord::Base
  attr_accessible :access_token, :display_name, :name, :picture, :quota_total, :quota_trash, :quota_used, :root_id, :uid

  belongs_to :user
  has_many :drive_files
end
