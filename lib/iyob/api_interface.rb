# Provides a 1-1 correspondance of the SMITE API methods to ruby methods
# Because naming conventions are different etc..., I'm choosing to have this
# done in a special interface class.
#
# TODO: Look into delegates here...
#
# base url for api access is: http://api.smitegame.com/smiteapi.svc/
# response formats are all appended to the url in the proper place.
# possible options are: "Json" or "Xml" (i think)
#
# TODO: Write tests!!!!

require 'mechanize'
require 'digest'

module Iyob
  module ApiInterface

    API_END_POINT = 'http://api.smitegame.com/smiteapi.svc'
    QUEUES = {
      conquest_5v5: 423,
      novice: 424,
      conquest: 426,
      practice: 427,
      challenge: 429,
      ranked: 430,
      joust: 431,
      domination: 433,
      match_of_the_day: 434,
      arena: 435,
      arena_challenge: 438,
      domination_challenge: 439,
      joust_queued: 440,
      renaissance_joust_challenge: 441,
      conquest_team_ranked: 442,
      assault: 445,
      assault_challenge: 446,
      joust_ranked_solo: 449,
      joust_ranked_3v3: 450
    }

    # We will be adding all these as class methods to the particular client.
    # This may not be the correct choice.
    def self.included(base)
      base.extend self
    end

    # returns a timestamp in the format that the API expects
    # @param [Integer] timestamp The integer UTC representation of the time
    def format_timestamp(raw_timestamp)
      Time.at(raw_timestamp).getutc.strftime("%Y%m%d%H%M%S")
    end
    # creates a method signature of in the appropriate format.
    def create_signature(dev_id, api_method, auth_key, formatted_timestamp)
      # ts = Time.at(timestamp).strftime("%Y%m%d%H%M%S")
      raw_sig = "#{dev_id}#{api_method}#{auth_key}#{formatted_timestamp}"
      Digest::MD5.hexdigest(raw_sig)
    end

    # Constructs a url for all the non-create session methods
    def construct_url(method, format, dev_id, signature, session_id, formatted_timestamp)
      "#{API_END_POINT}/#{method}#{format}/#{dev_id}/#{signature}/#{session_id}/#{formatted_timestamp}"
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
    def getplayer(dev_id, auth_key, session_id, player_name, format: "Json")
      ts = format_timestamp(Time.now.getutc.to_i)
      signature = create_signature(dev_id, 'getplayer', auth_key, ts)

      url = construct_url("getplayer", format, dev_id, signature, session_id, ts)
      m = Mechanize.new
      m.get("#{url}/#{player_name}").body
    end

    # Gets match details
    # getmatchdetails[ResponseFormat]/{devId}/{signature}/{sessionId}/{timestamp}/{mapId}
    def getmatchdetails(dev_id, auth_key, session_id, match_id, format: "Json")
      ts = format_timestamp(Time.now.getutc.to_i)
      signature = create_signature(dev_id, "getmatchdetails", auth_key, ts)

      url = construct_url("getmatchdetails", format, dev_id, signature, session_id, ts)
      Mechanize.new.get("#{url}/#{match_id}").body
    end

    # Gets match history
    # getmatchhistory[ResponseFormat]/{devId}/{signature}/{sessionId}/{timestamp}/{playerName}
    def getmatchhistory(dev_id, auth_key, session_id, player_name, format: "Json")
      ts = format_timestamp(Time.now.getutc.to_i)
      signature = create_signature(dev_id, 'getmatchhistory', auth_key, ts)

      url = construct_url("getmatchhistory", format, dev_id, signature, session_id, ts)
      Mechanize.new.get("#{url}/#{player_name}").body
    end

    # Provides information on your API usage.
    # getdataused[ResponseFormat]/{developerId}/{signature}/{sessionId}/{timestamp}
    def getdataused(dev_id, auth_key, session_id, format: "Json")
      # TODO: Fix all this bs repetition with the timestamp creation. It should
      # be pushed somewhere else. perhaps in the create_signature method?
      ts = format_timestamp(Time.now.getutc.to_i)
      signature = create_signature(dev_id, 'getdataused', auth_key, ts)
  
      url = construct_url("getdataused", format, dev_id, signature, session_id, ts)
      Mechanize.new.get("#{url}").body
    end

    def getqueuestats(dev_id, auth_key, session_id, player_name, queue, format: "Json")
      ts = format_timestamp(Time.now.getutc.to_i)
      signature = create_signature(dev_id, 'getqueuestats', auth_key, ts)
  
      url = construct_url("getqueuestats", format, dev_id, signature, session_id, ts)
      Mechanize.new.get("#{url}/#{player_name}/#{QUEUES[queue]}").body
    end


  end
end

