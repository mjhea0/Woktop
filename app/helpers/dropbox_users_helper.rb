module DropboxUsersHelper
  def getTheSize(str)
    if str == "0 bytes"
      theSize = "-"
    else
      theSize = str.gsub(/\s+/, "")
    end
    
    return theSize
  end
  
  def getThePath(str)
    return str.gsub(' ', '%20')
  end
  
  def getTheName(str)
    return str.slice(str.rindex('/')..str.length+1).gsub('/', '')
  end
  
  def getTheType(str)
    if (str.include? "folder")
      theType = "Folder"
    elsif (str.include? "music") || (str.include? "sound") || (str.include? "audio")
      theType = "Audio file"
    elsif (str.include? "package")
      theType = "Package"
    elsif (str.include? "excel")
      theType = "Microsoft Excel"
    elsif (str.include? "powerpoint")
      theType = "Microsoft Powerpoint"
    elsif (str.include? "word")
      theType = "Microsoft Word"
    elsif (str.include? "acrobat") || (str.include? "pdf")
      theType = "PDF file"
    elsif (str.include? "page_white_c") || (str.include? "actionscript") || (str.include? "php") || (str.include? "ruby") || (str.include? "page_white_h") || (str.include? "gear") || (str.include? "tux") || (str.include? "visualstudio")
      theType = "Code file"
    elsif (str.include? "flash")
      theType = "Flash file"
    elsif (str.include? "dvd")
      theType = "DVD file"
    elsif (str.include? "paint") || (str.include? "picture") || (str.include? "vector") || (str.include? "image")
      theType = "Image file"
    elsif (str.include? "text") || (str.include? "page_white")
      theType = "Text file"
    elsif (str.include? "zip")
      theType = "ZIP archive"
    else
      theType = "Unknown file"
    end
    
    return theType
  end
end
