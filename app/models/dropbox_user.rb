class DropboxUser < ActiveRecord::Base
  attr_accessible :access_token, :country, :display_name, :quota_normal, :quota_shared, :quota_total, :referral_link, :uid, :user_id
  
  belongs_to :user
  
  validates :user_id,
    :uniqueness => { :scope => :uid },
    presence: true
    
  validates :access_token,
    presence: true
  
  validates :country,
    presence: true
   
  validates :referral_link,
    presence: true
    
  validates :uid,
    presence: true
end
