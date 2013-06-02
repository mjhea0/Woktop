class DropboxFilesController < ApplicationController
include DropboxFilesHelper
  def removeFiles
    fileids = params[:fileids].split(',')
    uid = params[:uid]
    user = current_user
    
    theDropbox = DropboxUser.find_by_uid_and_user_id(uid, user.id)
  
    dropboxSession = DropboxSession.new(APP_KEY, APP_SECRET)
    access_token = dropboxSession.set_access_token(theDropbox.access_token_key, theDropbox.access_token_secret)
  
    dropboxClient = DropboxClient.new(dropboxSession, ACCESS_TYPE)
    
    theDeleted = Array.new
    
    fileids.each do |fileID|
      theFile = theDropbox.dropbox_files.find_by_id(fileID)
      
      if dropboxClient.file_delete(theFile[:file_path].gsub('%20', ' ' ))
        if theFile.destroy
          theDeleted.push(fileID)
        end
      end
    end
    
    render :json => theDeleted.to_json
  end
  
  def getFile
    fileID = params[:fileid]
    uid = params[:uid]
    user = current_user
    
    theDropbox = DropboxUser.find_by_uid_and_user_id(uid, user.id)
  
    dropboxSession = create_dropbox_session(uid, user.id)
  
    dropboxClient = DropboxClient.new(dropboxSession, ACCESS_TYPE)
    
    theFile = theDropbox.dropbox_files.find_by_id(fileID)
    returnedFile = dropboxClient.get_file(theFile[:file_path].gsub('%20', ' ' ))
    send_data(returnedFile, :filename => theFile[:name])
  end

  def getFiles
    uid = params[:uid]
    user = current_user

    dropboxSession = create_dropbox_session(uid, user.id)
  
    dropboxClient = DropboxClient.new(dropboxSession, ACCESS_TYPE)

    path = params['path'].gsub('%20', ' ')

    metadata = dropboxClient.metadata(path)

  end

  def getRoot
    uid = params[:uid]

    path = '/'
    
    user = current_user

    theDropbox = DropboxUser.find_by_uid_and_user_id(uid, user.id)

    dropboxSession = create_dropbox_session(uid, user.id)
    
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

      @root_file = theDropbox.dropbox_files.create(
        size: getTheSize(@getFiles['size']),
        file_path: getThePath(@getFiles['path']),
        name: getTheName(@getFiles['path']),
        directory: true,
        fileType: "Folder"
      )
      
      @getFiles['contents'].each do |theContents|
        theSize = getTheSize(theContents['size'])
        thePath = getThePath(theContents['path'])
        theName = getTheName(theContents['path'])
        theType = getTheType(theContents['icon'])
        isDir = theContents['is_dir']
        
        newFile = theDropbox.dropbox_files.create(
          :size => theSize,
          :file_path => thePath,
          :directory => theContents['is_dir'],
          :rev => theContents['rev'],
          :fileType => theType,
          :name => theName,
          :parent => @root_file
        )
      end
      
      theDropbox.update_attributes(:root_hash => @getFiles['hash'])
      
      @getAccount = dropboxClient.account_info()

      theDropbox.update_attributes(
        :country => @getAccount['country'],
        :display_name => @getAccount['display_name'],
        :quota_normal => @getAccount['quota_info']['normal'],
        :quota_shared => @getAccount['quota_info']['shared'],
        :quota_total => @getAccount['quota_info']['quota'],
        :referral_link => @getAccount['referral_link']
      )
    end
    
    session[:new_dropbox] = nil

    @root_file = theDropbox.dropbox_files.first unless @root_file

    render :json => @root_file.children
  end
end
