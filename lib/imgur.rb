##################################################
# Imgur                                          #
#------------------------------------------------#
# This library allows us to utilize the          #
# Imgur      API                                 #
# key: d82636dc23e1520c9b074fd4c1bbd451          #
##################################################

require 'rest_client'
require 'net/http'
require 'rubygems'
require 'xmlsimple'

module Imgur

  # FUNCTION: Upload Image to Imgur
  def uploadImagur(image_path)
      response = RestClient.post('http://api.imgur.com/2/upload.xml', 
                    :image => File.new(image_path),
                    :key => "d82636dc23e1520c9b074fd4c1bbd451")
      #puts(response.to_str)
      case response.code
          when 200
      xml_data = response.to_str
      data = XmlSimple.xml_in(xml_data)
      #puts(data)
      image_link = data["links"][0]["original"]
      delete_hash = data["image"][0]["deletehash"]
      #puts(image_link)
      #puts(delete_hash)
      image_array = [image_link, delete_hash]
      return (image_array)
          else
          return 0
          end
  end
    
    # FUNCTION: Delet image on Imgur with delete hash
    def deleteImagur(delete_hash)
        response = RestClient.get('http://api.imgur.com/2/delete/'+delete_hash)
        case response.code
            when 200
            return 1
            else
            return 0
        end
    end

end
