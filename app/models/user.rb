# == Schema Information
#
# Table name: users
#
#  id              :integer          not null, primary key
#  email           :string(255)
#  password_digest :string(255)
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  first_name      :string(255)
#  last_name       :string(255)
#

class User < ActiveRecord::Base
  attr_accessible :email, :password, :password_confirmation, :first_name, :last_name
  validates_uniqueness_of :email
  
  has_secure_password
  
  before_save { |user| user.email = email.downcase }

  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i

  validates :email,
    presence: true,
    format: { with: VALID_EMAIL_REGEX },
    uniqueness: { case_sensitive: false }

  validates :password,
    presence: true,
    length: { minimum: 6 }

  validates :password_confirmation,
    presence: true
   
  validates :first_name,
    length: { minimum: 2, maximum: 40 },
    :allow_blank => true
    
  validates :last_name,
    length: { minimum: 2, maximum: 40 },
    :allow_blank => true
    
  def full_name
    if "#{first_name} #{last_name}" != " "
      "#{first_name} #{last_name}"
    else
      return false
    end
  end
end
