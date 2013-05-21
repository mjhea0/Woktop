class DropboxUsersController < ApplicationController
  include DropboxUsersHelper
  
  def authorize
    user = current_user
    dropbox_users = user.dropbox_users
    foundDropbox = false
    
    dropbox_users.each do |theUser|
      if params[:uid] == theUser.uid.to_s()
        foundDropbox = true
      end
    end
    
    if !foundDropbox
      dropboxSession = DropboxSession.deserialize(session[:dropbox_session])
      access_token = dropboxSession.get_access_token
      
      dropboxClient = DropboxClient.new(dropboxSession, ACCESS_TYPE)
      
      myAccount = dropboxClient.account_info()

      newDropbox = user.dropbox_users.build(
        :access_token_key => access_token.instance_variable_get("@key"),
        :access_token_secret => access_token.instance_variable_get("@secret"),
        :country => myAccount['country'],
        :display_name => myAccount['display_name'],
        :quota_normal => myAccount['quota_info']['normal'],
        :quota_shared => myAccount['quota_info']['shared'],
        :quota_total => myAccount['quota_info']['quota'],
        :referral_link => myAccount['referral_link'],
        :uid => myAccount['uid'])

      if newDropbox.save
        session[:new_dropbox] = myAccount['uid']
        session[:dropbox_session] = nil
        flash[:success] = "Dropbox added!"
      else
        flash[:alert] = "Hmm, there were some errors..."
      end
    else
      flash[:alert] = "Dropbox already added..."
    end
    
    redirect_to profile_url
  end
  
  
  def getAccount
    uid = params[:uid]
    user = current_user
    
    @getAccount = DropboxUser.select("uid, name, country, display_name, quota_normal, quota_shared, quota_total, referral_link").find_by_uid_and_user_id(uid, user.id)
    
    render :json => @getAccount.to_json
  end
  
  def updateAccount
    if !params[:uid].nil?
      uid = params[:uid]
    else
      uid = params[:dropbox_user][:uid]
    end
    
    user = current_user
    theAccount = DropboxUser.find_by_uid_and_user_id(uid, user.id)
    
    if params[:dropbox_user].blank?
      if theAccount.update_attributes(:name => params[:name])
        session[:new_dropbox] = nil
        render :json => params[:name].to_json
      end
    else
      if theAccount.update_attributes(params[:dropbox_user])
        redirect_to profile_url
      end
    end
  end
  
  def removeAccount
    uid = params[:uid]
    user = current_user;
    
    theAccount = DropboxUser.find_by_uid_and_user_id(uid, user.id)
    
    if theAccount.destroy && theAccount.dropbox_files.destroy_all
      render :json => uid.to_json
    end
  end
end