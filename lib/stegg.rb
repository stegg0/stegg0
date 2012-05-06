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
    str = [binary].pack('b*')
    return str
  end

  # FUNCTION: Get number of bits in a binary value
  def getBits(binary)
    length = binary[0].length
    return length
  end

  # FUNCTION: Set the RGB value
  def imageSteg(data, image)
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

      # Initialize the new_pixels array
      @new_pixels = []

      # For each pixel in the original image
      # For 8-bit QuantumDepth the QuantumRange is 255
      # For 16-bit QuantumDepth the QuantumRange is 65535
      # For 32-bit QuantumDepth the QuantumRange is 4294967295
      original_image.each_pixel do |pixel, col, row|
        # Set data to empty
        data1 = ""
        data2 = ""
        data3 = ""

        # Set colors to their current value
        red = pixel.red
        green = pixel.green
        blue = pixel.blue

        # If the data is not empty
        # Grab the first character of data
        if (data.length > 0)
          data1 = data[0]
          data.slice!(0)
          
          # If the data is even and the red pixel is odd
          if ((data1%2 == "0") && (red%2 == 1))
            # Change the red to even
            #puts("Change red to even")
            red = red - 1
          end

          # If the data is odd and the red pixel is even
          if ((data1%2 == "1") && (red%2 == 0))
            # Change the red to odd
            #puts("Change red to odd")
            red = red + 1
          end
        end

        # If the data is not empty
        # Grab the second character of data
        if (data.length > 0)
          data2 = data[0]
          data.slice!(0)

          # If the data is even and the green pixel is odd
          if ((data2%2 == "0") && (green%2 == 1))
            # Change the green to even
            #puts("Change green to even")
            green = green - 1
          end
        
          # If the data is odd and the green pixel is even
          if ((data2%2 == "1") && (green%2 == 0))
            # Change the green to odd
            #puts("Change green to odd")
            green = green + 1
          end
        end

        # If the data is not empty
        # Grab the third character of data
        if (data.length > 0)
          data3 = data[0]
          data.slice!(0)

          # If the data is even and the blue pixel is odd
          if ((data3%2 == "0") && (blue%2 == 1))
            # Change the blue to even
            #puts("Change blue to even")
            blue = blue - 1
          end
        
          # If the data is odd and the blue pixel is even
          if ((data3%2 == "1") && (blue%2 == 0))
            # Change the blue to odd
            #puts("Change blue to odd")
            blue = blue + 1
          end
        end

        # Save the pixel to the pixel array
        @new_pixels << Magick::Pixel.new(red, green, blue, 0)
        #new_image.store_pixels(col, row, 1, 1, new_pixel)

        #puts "Pixel at: #{col}x#{row}:
        #\tR: #{new_pixel.red}, G: #{new_pixel.green}, B: #{new_pixel.blue}"
      end

      # Write out the new pixel array
      new_image.store_pixels(0, 0, new_image.columns, new_image.rows, @new_pixels)

      # Create a random image name
      image_name = Array.new(10){rand(36).to_s(36)}.join

      # Write out the new image
      new_image.write("./images/#{image_name}.png")

      # Return the image name we wrote to
      return "#{image_name}.png"
    end
  end

  # FUNCTION: Extract the data
  def imageDeSteg(key, image)
    # Suck in the image
    original_image = Magick::Image.read(image).first

    # Initialize the bits array
    bits = []

    # For each pixel in the image
    original_image.each_pixel do |pixel, col, row|
       # Set colors to their current value
       red = pixel.red
       green = pixel.green
       blue = pixel.blue

       # If the red value for the pixel is odd
       if (red%2 == 1)
         bits << 1
       else
         bits << 0
       end

       # If the green value for the pixel is odd
       if (green%2 == 1)
         bits << 1
       else
         bits << 0
       end

       # If the blue value for the pixel is odd
       if (blue%2 == 1)
         bits << 1
       else
         bits << 0
       end
    end

    # Initialize the encrypted_length_bits
    encrypted_length_bits = ""

    # For the first 128 characters in the array
    for counter in (0..127)
      # Append the value to the encrypted_length_bits
      encrypted_length_bits = encrypted_length_bits + bits[counter].to_s()
    end

    # Convert the binary encrypted length bits to a string
    encrypted_length = Stegg.convertBinaryToString(encrypted_length_bits)

    # Variables
    iv = nil
    cipher_type = "AES-256-CBC"

    # Decrypt the encrypted length
    length = AESCrypt.decrypt(encrypted_length, key, iv, cipher_type)

    # Initialize the encrypted_data_bits
    encrypted_data_bits = ""

    # Data starts at 128 and goes through the length
    last_bit = 127 + length.to_i()
 
    # For character 128 through the last bit
    for counter in (128..last_bit)
      # Append the value to the encrypted_data_bits
      encrypted_data_bits = encrypted_data_bits + bits[counter].to_s()
    end

    # Convert the binary encrypted data bits to a string
    encrypted_data = Stegg.convertBinaryToString(encrypted_data_bits)

    # Decrypte the encrypted data
    data = AESCrypt.decrypt(encrypted_data, key, iv, cipher_type)

    # Return the data
    return data
  end

end
