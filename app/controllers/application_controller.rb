class ApplicationController < ActionController::Base
  include ApplicationHelper
  require 'dropbox_sdk'

  APP_KEY = ENV["DROPBOX_APP_KEY"]
  APP_SECRET = ENV["DROPBOX_APP_SECRET"]
  ACCESS_TYPE = :dropbox

  
  protect_from_forgery
    
  private
    def current_user
      @current_user ||= User.find(session[:user_id]) if session[:user_id]
    end
    helper_method :current_user
    
    def authorize
      redirect_to login_url if current_user.nil?
    end

    def create_dropbox_session(uid, user_id)
      dropbox_user = DropboxUser.find_by_uid_and_user_id(uid, user_id)
      dropbox_session = DropboxSession.new(APP_KEY, APP_SECRET)
      access_token = dropbox_session.set_access_token(dropbox_user.access_token_key, dropbox_user.access_token_secret)
      return dropbox_session
    end
end