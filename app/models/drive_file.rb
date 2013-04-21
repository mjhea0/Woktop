class DriveFile < ActiveRecord::Base
  attr_accessible :description, :download_link, :drive_user_id, :fileType, :file_id, :name, :path, :size
  
  belongs_to :drive_user
end
