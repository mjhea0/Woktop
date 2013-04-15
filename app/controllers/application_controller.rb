class ApplicationController < ActionController::Base
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
end