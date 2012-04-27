###############################################
# Stegg                                       #
#---------------------------------------------#
# This library handles the embedding of data  #
# into the pixels of an image file.           #
###############################################

require './lib/images'
require 'RMagick'

include Images

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
  def embed(data, image)
    # Suck in the image
    original_image = Magick::Image.read(image).first

    # Get the number of bits in the data
    data_bits = data.length

    # Get the number of pixels in the current image
    pixels = Images.numberOfPixels(image)

    # Get the number of bits that can be utilized in the image
    # 3 bits (RGB) per pixel
    image_bits = pixels * 3

    # Make sure we don't have more data than the image can handle
    if (data_bits <= image_bits)
      # Create a new empty image to modify
      new_image = Magick::Image.new(original_image.columns, original_image.rows)

      # For each pixel in the original image
      # For 8-bit QuantumDepth the QuantumRange is 255
      # For 16-bit QuantumDepth the QuantumRange is 65535
      # For 32-bit QuantumDepth the QuantumRange is 4294967295
      original_image.each_pixel do |pixel, col, row|
        # Set data to empty
        data1 = ""
        data2 = ""
        data3 = ""

        # If the data is not empty
        # Grab the first character of data
        if (data.length > 0)
          data1 = data[0]
          data.slice!(0)
          
          # If the data is even and the red pixel is odd
          if ((data1%2 == "0") && (pixel.red%2 == 1))
            puts("Change red to even")
          end

          # If the data is odd and the red pixel is even
          if ((data1%2 == "1") && (pixel.red%2 == 0))
            puts("Change red to odd")
          end
        end

        # If the data is not empty
        # Grab the second character of data
        if (data.length > 0)
          data2 = data[0]
          data.slice!(0)

          # If the data is even and the green pixel is odd
          if ((data2%2 == "0") && (pixel.green%2 == 1))
            puts("Change green to even")
          end
        
          # If the data is odd and the green pixel is even
          if ((data2%2 == "1") && (pixel.green%2 == 0))
            puts("Change green to odd")
          end
        end

        # If the data is not empty
        # Grab the third character of data
        if (data.length > 0)
          data3 = data[0]
          data.slice!(0)

          # If the data is even and the blue pixel is odd
          if ((data3%2 == "0") && (pixel.blue%2 == 1))
            puts("Change blue to even")
          end
        
          # If the data is odd and the blue pixel is even
          if ((data3%2 == "1") && (pixel.blue%2 == 0))
            puts("Change blue to odd")
          end
        end

        #puts "Pixel at: #{col}x#{row}:
        #\tR: #{pixel.red}, G: #{pixel.green}, B: #{pixel.blue}"
      end

      # Write out the new image
      new_image.write("./images/1-steg.png")
    end

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
    # Return the number of bits used 
  end

end
