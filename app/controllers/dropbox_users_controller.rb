class DropboxUsersController < ApplicationController
  def authorize
    @user = current_user
    @dropbox_users = @user.dropbox_users
    foundDropbox = false
    
    @dropbox_users.each do |theUser|
      if params[:uid] == theUser.uid.to_s()
        foundDropbox = true
      end
    end
    
    if !foundDropbox
      dropboxSession = DropboxSession.deserialize(session[:dropbox_session])
      @access_token = dropboxSession.get_access_token
      
      dropboxClient = DropboxClient.new(dropboxSession, ACCESS_TYPE)

      newDropbox = @user.dropbox_users.build(
        :access_token => @access_token,
        :country => dropboxClient.account_info['country'],
        :display_name => dropboxClient.account_info['display_name'],
        :quota_normal => dropboxClient.account_info['quota_info']['normal'],
        :quota_shared => dropboxClient.account_info['quota_info']['shared'],
        :quota_total => dropboxClient.account_info['quota_info']['quota'],
        :referral_link => dropboxClient.account_info['referral_link'],
        :uid => dropboxClient.account_info['uid'])

      if newDropbox.save
        session[:dropbox_session] = nil
        flash[:success] = "Dropbox added!"
      end
    else
      flash[:error] = "Dropbox already added..."
    end
    
    redirect_to profile_url
  end
end
