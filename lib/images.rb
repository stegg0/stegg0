##################################################
# Images                                         #
#------------------------------------------------#
# This library allows us to utilize the Flickr   #
# library to select sets of 9 random interesting #
# images and download them into the image        #
# directory for use with our program.            #
##################################################

require_relative 'flickr'
require 'RMagick'
require 'fileutils'

module Images

  # FUNCTION: Get images from Flickr
  def getImages
    # If the images directory does not exist
    if (!File.directory?('./images'))
      # Create the images directory
      FileUtils.mkdir('./images/')
    end

    # Counter for image file names
    counter = 1

    # Pulls 9 random images from Flickr
    Flickr.interesting_images.each do |url|
      # Remove .jpg from string
      image = url.gsub!(".jpg", "_b.jpg")

      # Create file name to save image out to
      jpgName = "./images/" + counter.to_s() + ".jpg"

      # Download and save the image
      writeOut = open(jpgName, "wb")
      writeOut.write(open(image).read)
      writeOut.close

      # Convert the JPG to PNG
      thumb = Magick::Image.read(jpgName).first
      thumb.format = "PNG"
      pngName = "./images/" + counter.to_s() + ".png"
      thumb.write(pngName)

      # Remove the JPG
      FileUtils.rm(jpgName)

      # Increment the counter
      counter+=1
    end
  end

  # FUNCTION: Resize images to modify from the original
  def resizeImages
    # For each of the 9 images
    for counter in (1..9)
      pngName = "./images/" + counter.to_s() + ".png"
      image = Magick::Image.read(pngName).first

      # Create a random number from 0.01 to 0.1
      random = rand(0.01..0.1)

      # Make the new image larger by the random number percent
      value = 1 + random
      thumb = image.scale(value)
      thumb.write(pngName)
    end
  end

  # FUNCTION: Get number of pixels in image
  def numberOfPixels(image)
    # Suck in the image
    image = Magick::Image.read(image).first

    # Get the number of rows and columns
    columns = image.columns
    rows = image.rows

    # Calculate the number of pixels
    pixels = columns * rows

    # Return the number of pixels
    return pixels
  end

  # FUNCTION: Delete images
  def deleteImages
    # If the images directory exists
    if (File.directory?('./images'))
      # Remove the images directory
      FileUtils.rm_rf('./images/')
    end

    # Create the images directory
    FileUtils.mkdir('./images/')
  end
end
