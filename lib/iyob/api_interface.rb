# Provides a 1-1 correspondance of the SMITE API methods to ruby methods
# Because naming conventions are different etc..., I'm choosing to have this
# done in a special interface class.
#
# TODO: Look into delegates here...
#
# base url for api access is: http://api.smitegame.com/smiteapi.svc/
# response formats are all appended to the url in the proper place.
# possible options are: "Json" or "Xml" (i think)
require 'mechanize'
require 'digest'

module Iyob
  module ApiInterface

    API_END_POINT = 'http://api.smitegame.com/smiteapi.svc'

    # We will be adding all these as class methods to the particular client.
    # This may not be the correct choice.
    def self.included(base)
      base.extend self
    end

    # returns a timestamp in the format that the API expects
    # @param [Integer] timestamp The integer (UTC) representation of the time
    def format_timestamp(timestamp)
      Time.at(timestamp).getutc.strftime("%Y%m%d%H%M%S")
    end
    # creates a method signature of in the appropriate format.
    def create_signature(dev_id, api_method, auth_key, timestamp)
      # ts = Time.at(timestamp).strftime("%Y%m%d%H%M%S")
      raw_sig = "#{dev_id}#{api_method}#{auth_key}#{timestamp}"
      Digest::MD5.hexdigest(raw_sig)
    end

    # Constructs a url for all the non-create session methods
    def construct_url(dev_id, auth_key, format, session_id, timestamp)
    end

    # Creates a session
    # createsession[ResponseFormat]/{devId}/{signature}/{timestamp}
    def createsession(dev_id, auth_key, format: "Json")
      ts = format_timestamp(Time.now.getutc.to_i)
      
      signature = create_signature(dev_id, 'createsession', auth_key, ts)

      url = "#{API_END_POINT}/createsession#{format}/#{dev_id}/#{signature}/#{ts}"
      puts "url: #{url}"
      
      m = Mechanize.new
      m.get(url).body
    end

    # Gets items
    # getitems[ResponseFormat]/{devId}/{signature}/{sessionId}/{timestamp}/{languageCode}
    # a. LanguageCode is an integer. Currently supported languages are 1 - English and 3 - French.
    def getitems
    end

    # Gets player info.
    # getplayer[ResponseFormat]/{devId}/{signature}/{sessionId}/{timestamp}/{playerName}
    def getplayer
    end

    # Gets match details
    # getmatchdetails[ResponseFormat]/{devId}/{signature}/{sessionId}/{timestamp}/{mapId}
    def getmatchdetails
    end

    # Gets match history
    # getmatchhistory[ResponseFormat]/{devId}/{signature}/{sessionId}/{timestamp}/{playerName}
    def getmatchistory
    end


  end
end

