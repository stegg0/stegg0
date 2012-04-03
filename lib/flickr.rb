############################################
# Flickr                                   #
#------------------------------------------#
# This library allows us to grab links to  #
# interesting images on Flickr.  Thanks to #
# drawohara.com for the code.              #
############################################

require 'open-uri'

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
