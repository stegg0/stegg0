################################################
# Main                                         #
#----------------------------------------------#
# The main routine for our Stegg0 application. #
################################################

require './lib/images'
require './lib/stegg'
require './lib/aescrypt'
require './lib/imageshack'
require './lib/imgur'
require './lib/ftp'

include Images
include Stegg
include AESCrypt
include Imageshack
include Imgur
include Ftp



# Variables
iv = nil
cipher_type = "AES-256-CBC"
ftpServer = "ftp.drivehq.com"
ftpUser = "stegg0"
ftpPass = "stegg0"
ftpDir = "\\stegg0"



# Get the shared secret password
print("ENTER THE SHARED SECRET KEY: ")
input = gets
password = input.split.join("\n")

# Convert the password into a sufficiently long key
key = AESCrypt.getKey(password)



# Counter for image file names
counter = 1
# Get the image repository type
puts("\n--------------------------------------\n")
puts("IM Selection...")
puts("* comment")
puts("* read")
puts("* quit")
puts("* ")

# While the user does not enter "quit" followed by a return character
while (input != "quit")
    # Print a text prompt
    print("SELECT> ")
  # Get user input
    input = gets.chomp

  # If the user enters "quit" followed by a return character
    if input == "quit" then

        puts("Quitting...")
        exit
    end
    if input == "comment" then

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
              # Get the current image name
              pngName = "./images/" + counter.to_s() + ".png"
              nodePng = "node.png"
              downloadPath = "./images/node.png"
              # TODO: We need to come up with a good way to make sure the data will fit in the image or split it up over multiple images
              
              # Steggo the data in the image and get the random image name returned
              random_image = Stegg.imageSteg(input, key, pngName)
              random_image = "./images/"+random_image
              # put the image and data on cloud
              imageshack_link =  Imageshack.uploadImage(random_image)
              puts("imageshack: "+imageshack_link[0].to_s)
              imgur_array = Imgur.uploadImagur(random_image)
              imgur_link = imgur_array[0]
              puts("imageur: "+imgur_link[0].to_s)
              #delete_hash = imgur_array[1]      
              #Imgur.deleteImagur(delete_hash[0])   
        #get old node png and append to end of data
        fileExists = Ftp.ftpDownload(ftpServer, ftpUser, ftpPass, ftpDir, downloadPath, nodePng)
        nodeData = ""
        # if file exists then download it and get the url list
        if fileExists == 1 then
            
            nodeData = Stegg.imageDeSteg(key, downloadPath)
            puts("Image Data: #{nodeData}")  
            end
        #if node file does not exists then just create it with the new url list
        #save both link locations to end of txt file
              comment_links = imageshack_link[0].to_s+"\t"+imgur_link[0].to_s+"\n"
              newNodeData = nodeData+comment_links
              puts(newNodeData)
              counter = counter+1
              nodePngTemp = "./images/" + counter.to_s() + ".png"
              node_image = Stegg.imageSteg(newNodeData, key, nodePngTemp)
              node_image = "./images/"+node_image
        #upload the new node file
        Ftp.ftpUpload(ftpServer, ftpUser, ftpPass, ftpDir, node_image, nodePng)
              
              
    end
    if input == "read" then
        # Print a text prompt
        print("Please Wait...\n ")
        nodePng = "node.png"
        downloadPath = "./images/node.png"
        #get old node png and append to end of data
        fileExists = Ftp.ftpDownload(ftpServer, ftpUser, ftpPass, ftpDir, downloadPath, nodePng)
        nodeData = ""
        # if file exists then download it and get the url list
        if fileExists == 1 then
            
            nodeData = Stegg.imageDeSteg(key, downloadPath)
            puts("Image Data: #{nodeData}")  
        end
        #if node file does not exists then just create it with the new url list
              # Desteggo the data from the image
        # data = Stegg.imageDeSteg(key, "./images/" + random_image)
        #     puts("Image Data: #{data}")         

  end
    
    puts("\n--------------------------------------\n")
    puts("IM Selection...")
    puts("* comment")
    puts("* read")
    puts("* quit")
    puts("* ")
end
