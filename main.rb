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

include Images
include Stegg
include AESCrypt
include Imageshack
include Imgur


# Variables
iv = nil
cipher_type = "AES-256-CBC"

# Print initialization
puts("Initializing.  Please wait...")

# Initialize the input variable
input = ""

# Start by downloading some images
Images.getImages

# Resize the images by a random value to make them different from the original
Images.resizeImages

# Counter for image file names
counter = 1

# Print testing imageshack
#puts("\n\nImageshack Test.  Please wait...")
#puts(Imageshack.uploadImage("images/1.png"))

# Print testing imgur
#puts("\n\nImgur Test.  Please wait...")
#imgur_array = Imgur.uploadImage("images/1.png")
#img_link = imgur_array[0]
#delete_hash = imgur_array[1]

#Imgur.deleteImage(delete_hash[0])

#exit


# Get the shared secret password
print("ENTER THE SHARED SECRET KEY: ")
input = gets
password = input.split.join("\n")

# Convert the password into a sufficiently long key
key = AESCrypt.getKey(password)

# Get the image repository type
puts("Repository Types...")
puts("* imageshack")
puts("* ftp")
print("ENTER REPOSITORY TYPE: ")
input = gets
repository = input.split.join("\n")


# While the user does not enter "quit" followed by a return character
while (input != "quit\n")
  # Print a text prompt
  print("TEXT> ")

  # Get user input
  input = gets

  # Evaluate the user input
  case input

  # If the user enters "quit" followed by a return character
  when "quit\n"
    puts("Quitting...")

  # Otherwise do the normal steggo thing
  else
    # Get the current image name
    pngName = "./images/" + counter.to_s() + ".png"

    # TODO: We need to come up with a good way to make sure the data will fit in the image or split it up over multiple images

    # Steggo the data in the image and get the random image name returned
    random_image = Stegg.imageSteg(input, key, pngName)
      
    # Desteggo the data from the image
    data = Stegg.imageDeSteg(key, "./images/" + random_image)
    puts("Image Data: #{data}")
  end
end
