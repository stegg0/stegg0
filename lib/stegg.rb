###############################################
# Stegg                                       #
#---------------------------------------------#
# This library handles the embedding of data  #
# into the pixels of an image file.           #
###############################################

module Stegg
  
  # FUNCTION: Convert a string to a binary value
  def convertStringToBinary(str)
    # Use the unpack function to decode the string
    binary = str.unpack('b*')
    return binary
  end

  # FUNCTION: Convert binary to a string
  def convertBinaryToString(binary)
    # Use the pack function to encode the binary
    str = binary.pack('b*')
    return str
  end

  # FUNCTION: Get number of bits in a binary value
  def getBits(binary)
    length = binary[0].length
    return length
  end

  # FUNCTION: Set the RGB value
  def embed(image, data)
    # Get the number of bits in the data
    # For images 1-9
    # Get the height and width of the image
    # Determine the total number of pixels
    # If the data is bigger than what we can store in the 9 images
    # Figure out which kind of bit it is
    #switch (bit)
    #  case '1':
        # If the color is not an odd number
        # Increase it
    #  case '0':
        # If the color is not an even number
        # Decrease it
    # Fetch 9 more images and repeat
  end

end
