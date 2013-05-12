# == Schema Information
#
# Table name: dropbox_files
#
#  id              :integer          not null, primary key
#  dropbox_user_id :integer
#  path            :string(255)
#  directory       :boolean
#  rev             :string(255)
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  size            :string(255)
#  name            :string(255)
#  fileType        :string(255)
#  parent_hash     :string(255)
#  folderHash      :string(255)
#

class DropboxFile < ActiveRecord::Base
  attr_accessible :size, :directory, :fileType, :path, :rev, :dropbox_user_id, :name, :folderHash, :parent_hash
  
  belongs_to :dropbox_user
end
