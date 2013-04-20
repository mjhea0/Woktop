class DropboxFilesController < ApplicationController
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
      
      if dropboxClient.file_delete(theFile[:path].gsub('%20', ' ' ))
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
  
    dropboxSession = DropboxSession.new(APP_KEY, APP_SECRET)
    access_token = dropboxSession.set_access_token(theDropbox.access_token_key, theDropbox.access_token_secret)
  
    dropboxClient = DropboxClient.new(dropboxSession, ACCESS_TYPE)
    
    theFile = theDropbox.dropbox_files.find_by_id(fileID)
    returnedFile = dropboxClient.get_file(theFile[:path].gsub('%20', ' ' ))
    send_data(returnedFile, :filename => theFile[:name])
  end
end
