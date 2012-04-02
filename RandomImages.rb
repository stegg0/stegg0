require 'open-uri'
require 'uri'
require 'RMagick'

module Flickr
  InterestingImages = []

  def interesting_image
    if InterestingImages.empty?
      4.times do |i|
        begin
          html = open('http://www.flickr.com/explore/interesting/7days/'){|fd| fd.read}
          uris = URI.extract(html, 'http')
          uris.select do |uri|
            next unless uri =~ /\.jpg$/
            InterestingImages.push(uri.gsub(%r/_m/, ''))
          end
          break
        rescue
          raise if i==3
          sleep(rand)
        end
      end
    end

    InterestingImages.shift
  end

  def interesting_images
    [interesting_image, *InterestingImages]
  ensure
    InterestingImages.clear
  end

  extend(Flickr)
end

# Counter for image file names
counter = 1

# Pulls 9 random images from Flickr
Flickr.interesting_images.each do |url|
  # Remove .jpg from string
  image = url.gsub!(".jpg", "_b.jpg")

  # Create file name to save image out to
  jpgName = counter.to_s() + ".jpg"

  # Download and save the image
  writeOut = open(jpgName, "wb")
  writeOut.write(open(image).read)
  writeOut.close

  # Convert the JPG to PNG
  thumb = Magick::Image.read(jpgName).first
  thumb.format = "PNG"
  pngName = counter.to_s() + ".png"
  thumb.write(pngName)

  # Remove the JPG
  FileUtils.rm(jpgName)

  # Increment the counter
  counter+=1
end

