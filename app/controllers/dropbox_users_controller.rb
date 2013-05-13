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
        flash[:error] = "Hmm, there were some errors..."
      end
    else
      flash[:error] = "Dropbox already added..."
    end
    
    redirect_to profile_url
  end
  
  def getRoot
    uid = params[:uid]
    
    if params[:path]
      path = params[:path]
    else
      path = "/"
    end
    
    user = current_user

    theDropbox = DropboxUser.find_by_uid_and_user_id(uid, user.id)
    
    dropboxSession = DropboxSession.new(APP_KEY, APP_SECRET)
    access_token = dropboxSession.set_access_token(theDropbox.access_token_key, theDropbox.access_token_secret)
    
    dropboxClient = DropboxClient.new(dropboxSession, ACCESS_TYPE)
    
    if theDropbox.root_hash.nil? || theDropbox.root_hash.blank?
      @getFiles = dropboxClient.metadata(path)
    else
      begin
        @getFiles = dropboxClient.metadata(path, 25000, true, theDropbox.root_hash)
      rescue DropboxNotModified
      end
    end
    
    if !@getFiles.nil?
      theDropbox.dropbox_files.destroy_all
      
      @getFiles['contents'].each do |theContents|
        theSize = getTheSize(theContents['size'])
        thePath = getThePath(theContents['path'])
        theName = getTheName(theContents['path'])
        theType = getTheType(theContents['icon'])
        isDir = theContents['is_dir']
        
        newFile = theDropbox.dropbox_files.create(
          :size => theSize,
          :path => thePath,
          :directory => theContents['is_dir'],
          :rev => theContents['rev'],
          :fileType => theType,
          :name => theName)
      end
      
      theDropbox.update_attributes(:root_hash => @getFiles['hash'])
      
      @getAccount = dropboxClient.account_info()

      theDropbox.update_attributes(
        :country => @getAccount['country'],
        :display_name => @getAccount['display_name'],
        :quota_normal => @getAccount['quota_info']['normal'],
        :quota_shared => @getAccount['quota_info']['shared'],
        :quota_total => @getAccount['quota_info']['quota'],
        :referral_link => @getAccount['referral_link'])
    end
    
    session[:new_dropbox] = nil
    
    render :json => theDropbox.dropbox_files.to_json
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