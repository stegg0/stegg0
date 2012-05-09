################################################
# Main                                         #
#----------------------------------------------#
# The main routine for our Stegg0 application. #
################################################

require './lib/images'
require './lib/stegg'
require './lib/imageshack'
require './lib/imgur'
require './lib/ftp'
require 'net/http'
require 'fileutils'
require 'net/https'
require 'uri'

include Images
include Stegg
include Imageshack
include Imgur
include Ftp




def message
  
# - to do: we need to create a config file 
# Variables for ftp server
ftpServer = "stegg0.com"
ftpUser = "stegg0"
ftpPass = "stegg0"
ftpDir = "\\stegg0"
    
# Counter for image file names
counter = 1
    
# Get the image repository type
puts("\n--------------------------------------\n")
puts("Message Selection...")
puts("* c -> comment")
puts("* r -> read")
puts("* b -> back")
puts("* q -> quit")
puts("*")
puts("--------------------------------------\n")
# Print a text prompt
print("SELECT> ")
# Get user input
input = gets.chomp
    
# While the user does not enter "q" followed by a return character
while (input != "q")


  # If the user enters "q" followed by a return character
    if input == "q" then

        puts("Quitting...")
        FileUtils.rm_rf("images/", secure: true)
        exit
    end
    # if 'b' return to main menu
    if input == "b" then
        
        puts("Main Menu...")
        FileUtils.rm_rf("images/", secure: true)
        return
    end
    # if 'c' then comment is selected
    if input == "c" then
        # Get the shared secret password
        print("ENTER THE SHARED SECRET KEY> ")
        input = gets
        password = input.chomp
        # Get a username
        print("ENTER A USERNAME> ")
        username  = gets.chomp
        print("ENTER A CHANNEL NAME> ")
        channel  = gets.chomp
        # Print initialization
        puts("Initializing.  Please wait...")
        
        # Initialize the input variable
        input = ""
        
        # Start by downloading some images
        Images.getImages
        
        # Resize the images by a random value to make them different from the original
        Images.resizeImages
        
        # Print a text prompt
        print("TEXT> ")
              
        # Get user input
        input = gets.chomp
        print("Stegg0ing Please Wait...\n")
        # Get the current image name
        pngName = "./images/" + counter.to_s() + ".png"
        nodePng = channel+".png"
        downloadPath = "./images/"+channel
        # TODO: We need to come up with a good way to make sure the data will fit in the image or split it up over multiple images
              
        # Steggo the data in the image and get the random image name returned
        random_image = Stegg.imageSteg(input, password, pngName)
        random_image = "./images/"+random_image
        # put the image and data on cloud
        imageshack_link =  Imageshack.uploadImage(random_image)
        #puts("Imageshack: "+imageshack_link[0].to_s)
        imgur_array = Imgur.uploadImagur(random_image)
        imgur_link = imgur_array[0]
        #puts("Imageur: "+imgur_link[0].to_s)
        #delete_hash = imgur_array[1]      
        #Imgur.deleteImagur(delete_hash[0])   
        #get old node png and append to end of data
        fileExists = Ftp.ftpDownload(ftpServer, ftpUser, ftpPass, ftpDir, downloadPath, nodePng)
        nodeData = ""
        # if file exists then download it and get the url list
        if fileExists == 1 then
            
            nodeData = Stegg.imageDeSteg(password, downloadPath)
            #puts("Image Data: #{nodeData}")  
        end
        #if node file does not exists then just create it with the new url list
        #save both link locations to end of txt file
        comment_links = imageshack_link[0].to_s+"\t"+imgur_link[0].to_s+"\t"+username+"\n"
        newNodeData = nodeData+comment_links
        #puts(newNodeData)
        counter = counter+1
        nodePngTemp = "./images/" + counter.to_s() + ".png"
        node_image = Stegg.imageSteg(newNodeData, password, nodePngTemp)
        node_image = "./images/"+node_image
        #upload the new node file
        Ftp.ftpUpload(ftpServer, ftpUser, ftpPass, ftpDir, node_image, nodePng)
              
              
    end
    #if 'r' then read from data channel
    if input == "r" then
        # Get the shared secret password
        print("ENTER THE SHARED SECRET KEY> ")
        input = gets
        password = input.chomp
        # Print a text prompt
        print("ENTER A CHANNEL NAME> ")
        channel  = gets.chomp
        print("DeStegg0ing Please Wait...\n")
        # If the images directory does not exist
        if (!File.directory?('./images'))
            # Create the images directory
            FileUtils.mkdir('./images/')
        end
        nodePng = channel+".png"
        downloadPath = "./images/"+channel
        #get old node png and append to end of data
        fileExists = Ftp.ftpDownload(ftpServer, ftpUser, ftpPass, ftpDir, downloadPath, nodePng)
        nodeData = ""
        # if file exists then download it and get the url list
        if fileExists == 1 then
            nodeData = Stegg.imageDeSteg(password, downloadPath)
            nodeArray = nodeData.split(/\n/)
            # for each line in the node file split on the tab and get data
            nodeArray.each do |line|
                urlArray = line.split(/\t/)
                #puts("Imageshack: "+ urlArray[0])
                #puts("Imgur: "+ urlArray[1])
                temp_username = urlArray[2]
                # Desteggo the data from the image
                imageCount = 1
                imagePath = "./images/" + imageCount.to_s() + ".png"
                # imagesshack url
                url = urlArray[0].to_s
                uri = URI.parse(url)
                http = Net::HTTP.new(uri.host, uri.port)
                http.use_ssl = true if uri.scheme == "https"
                http.verify_mode = OpenSSL::SSL::VERIFY_NONE
                http.start {
                    http.request_get(uri.path) {|res|
                        File.open(imagePath,'wb') { |f|
                            f.write(res.body)
                        }
                    }
                }
                fileExists = File.exist? imagePath
                #if imageshack had the file then destegg
                    if fileExists == true then
                        data = Stegg.imageDeSteg(password, imagePath)
                        puts(temp_username+"> #{data}")  
                        imageCount = imageCount+1
                    end
                #if imageshack did not have the file then get the redundant file from imgur
                    if fileExists == false then
                        url = urlArray[1].to_s
                        uri = URI.parse(url)
                        http = Net::HTTP.new(uri.host, uri.port)
                        http.use_ssl = true if uri.scheme == "https"
                        http.verify_mode = OpenSSL::SSL::VERIFY_NONE
                        http.start {
                            http.request_get(uri.path) {|res|
                                File.open(imagePath,'wb') { |f|
                                    f.write(res.body)
                                }
                            }
                        }
                        fileExists = File.exist? imagePath
                        if fileExists == true then
                            data = Stegg.imageDeSteg(password, imagePath)
                            puts(temp_username+"> #{data}")  
                            imageCount = imageCount+1
                        end
                        if fileExists == false then
                            puts("No file? Something is Screwed up!")
                        end
                    end
                end 
        end

  end
    #end while loop
    puts("\n--------------------------------------\n")
    puts("Message Selection...")
    puts("* c -> comment")
    puts("* r -> read")
    puts("* b -> back")
    puts("* q -> quit")
    puts("*")
    puts("--------------------------------------\n")
    # Print a text prompt
    print("SELECT> ")
    # Get user input
    input = gets.chomp
end
#end of def message
end



################################################
# Main                                         #
#----------------------------------------------#
#                                              #
################################################

puts("\n--------------------------------------\n")
puts("Main Menu Selection...")
puts("* m -> message")
puts("* d -> drop")# - to do add data drop functionality
puts("* q -> quit")
puts("*")
puts("--------------------------------------\n")
# Print a text prompt
print("SELECT> ")
# Get user input
input = gets.chomp
# While the user does not enter "quit" followed by a return character
while (input != "q")

    
    # If the user enters "quit" followed by a return character
    if input == "q" then
        
        puts("Quitting...")
        FileUtils.rm_rf("images/", secure: true)
        exit
    end
    if input == "m" then
        
        puts("Messaging...")
        message
    end
    if input == "d" then
        
        puts("# - to do add data drop functionality")
        exit
    end
    puts("\n--------------------------------------\n")
    puts("Main Menu Selection...")
    puts("* m -> message")
    puts("* d -> drop")# - to do add data drop functionality
    puts("* q -> quit")
    puts("*")
    puts("--------------------------------------\n")
    # Print a text prompt
    print("SELECT> ")
    # Get user input
    input = gets.chomp
end

# end main

