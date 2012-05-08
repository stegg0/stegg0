##################################################
# FTP                                            #
#------------------------------------------------#
# This library allows us to utilize ftp          #
##################################################

require 'rest_client'
require 'net/http'
require 'rubygems'
require 'xmlsimple'
require 'net/ftp'


module Ftp

    # FUNCTION: upload ftp file
    def ftpUpload(ftpServer, ftpUser, ftpPass, ftpDir, ftpLocalFile, ftpRemoteFile)
        
        ftp = Net::FTP.new
        
        ftp.connect(ftpServer,21)
        
        ftp.login(ftpUser,ftpPass)
        
        ftp.chdir(ftpDir)
        
        ftp.putbinaryfile(ftpLocalFile, ftpRemoteFile)
        
        ftp.close
        return 1
    end  
    # FUNCTION: download ftp file
    def ftpDownload(ftpServer, ftpUser, ftpPass, ftpDir, ftpLocalFile, ftpRemoteFile)
        
        ftp = Net::FTP.new
        
        ftp.connect(ftpServer,21)
        
        ftp.login(ftpUser,ftpPass)
        
        ftp.chdir(ftpDir)
        files = ftp.list(ftpRemoteFile)
        if(files[0])
        ftp.getbinaryfile(ftpRemoteFile, ftpLocalFile)
        
        ftp.close
        return 1
        else
            ftp.close
            return 0
        end
            
    end

end
