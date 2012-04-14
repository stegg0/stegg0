################################################
# Main                                         #
#----------------------------------------------#
# The main routine for our Stegg0 application. #
################################################

require './lib/images'
require './lib/stegg'

include Images
include Stegg

#Images.getImages
#Images.resizeImages
#Images.deleteImages
#text = "It works!!!"
#binary = Stegg.convertStringToBinary(text)
#binaryArray = File.open("data.txt", "r").read
#puts(Stegg.getBits(binary))

#puts(binary)

#str = Stegg.convertBinaryToString(binary)

#puts(str)

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

# Get the shared secret key
print("ENTER THE SHARED SECRET KEY: ")
input = gets
key = input.split.join("\n")

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
    # TODO: Encrypt the input with the key
    encrypted_input = input

    # Convert the encrypted input to a binary value
    binary = Stegg.convertStringToBinary(encrypted_input)

    # Get the number of bits for the binary value
    data_bits = Stegg.getBits(binary)

    # Get the current image name
    pngName = "./images/" + counter.to_s() + ".png"

    # Get the number of pixels in the current image
    pixels = Images.numberOfPixels(pngName)

    # Get the number of bits that can be utilized in the image
    # 3 bits (RGB) per pixel
    image_bits = pixels * 3

    puts(image_bits)
    
  end
end
