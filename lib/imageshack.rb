##################################################
# Imageshack                                     #
#------------------------------------------------#
# This library allows us to utilize the          #
# Imageshack API                                 #
# key 1: 026AGIJQa567d68c76cc6067cabd078f61ec54f7#
# key 1: 34BDMNWX485f1b96280800b6a28f25cc146ee139#
# key 2: 058HOSTUf6d97e1dcae18619fdd8ea475f917a4e#
# key 3: 7FIKMNTYd9f41d7796cd8c92ae96cabd3a7cb03d#
# key 4: 034HJMPW46902fee8e13862cce2c14bf7ac0df83#
# key 5: 25DMPRTW1ebeb27c11f266b9758923507ba8d08d#
##################################################

require 'rest_client'
require 'net/http'
require 'rubygems'
require 'xmlsimple'

module Imageshack

  # FUNCTION: Upload Image to Imageshack
  def uploadImage(image_path)
      response = RestClient.post('http://www.imageshack.us/upload_api.php', 
                    :fileupload => File.new(image_path),
                    :key => "25DMPRTW1ebeb27c11f266b9758923507ba8d08d")
      #puts(response.to_str)
      case response.code
          when 200
      xml_data = response.to_str
      data = XmlSimple.xml_in(xml_data)
      #puts(data)
      image_link = data["links"][0]["image_link"]
      return (image_link)
          else
          return 0 
          end
  end

end
