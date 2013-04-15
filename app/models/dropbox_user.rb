# == Schema Information
#
# Table name: dropbox_users
#
#  id                  :integer          not null, primary key
#  user_id             :integer
#  referral_link       :string(255)
#  display_name        :string(255)
#  uid                 :integer
#  country             :string(255)
#  quota_normal        :float
#  quota_shared        :float
#  quota_total         :float
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#  access_token_key    :string(255)
#  access_token_secret :string(255)
#  name                :string(255)
#  root_hash           :string(255)
#

class DropboxUser < ActiveRecord::Base
  attr_accessible :access_token_key, :access_token_secret, :country, :display_name, :quota_normal, :quota_shared, :quota_total, :referral_link, :uid, :user_id, :name, :root_hash
  
  belongs_to :user
  has_many :dropbox_files
  
  validates :user_id,
    :uniqueness => { :scope => :uid },
    presence: true
    
  validates :name,
    length: { minimum: 2, maximum: 30 },
    :allow_blank => true
    
  validates :access_token_key,
    presence: true
   
  validates :access_token_secret,
    presence: true
  
  validates :country,
    presence: true
   
  validates :referral_link,
    presence: true
    
  validates :uid,
    presence: true
end
