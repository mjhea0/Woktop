# == Schema Information
#
# Table name: drive_users
#
#  id           :integer          not null, primary key
#  display_name :string(255)
#  quota_total  :float
#  quota_used   :float
#  quota_trash  :float
#  root_id      :string(255)
#  picture      :string(255)
#  name         :string(255)
#  access_token :string(255)
#  uid          :integer
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  user_id      :integer
#

class DriveUser < ActiveRecord::Base
  attr_accessible :access_token, :display_name, :name, :picture, :quota_total, :quota_trash, :quota_used, :root_id, :uid

  belongs_to :user
  has_many :drive_files
end
