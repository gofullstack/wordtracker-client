require 'xmlrpc/client'
require 'rubygems'
require 'active_support'

$:.unshift(File.dirname(__FILE__)) unless
  $:.include?(File.dirname(__FILE__)) || $:.include?(File.expand_path(File.dirname(__FILE__)))

module Wordtracker
  include ActiveSupport
  VERSION = '0.0.1'
  
  # Error class
  class FaultException < XMLRPC::FaultException; end

  class Client < XMLRPC::Client

    def initialize(id = "guest", options = {})
      options.symbolize_keys!
      # Use the dummy API if no ID is provided
      @id = id
      url = @id == "guest" ? "test.xmlrpc.wordtracker.com" :
        "xmlrpc.wordtracker.com"
      super(url, "/")
    end

    # See if the service responds
    def ping
      send("ping")
    end
    
    # Get a list of related keyphrases and their occurences when searching
    def get_lateral_keyphrases(options = {})
      options.symbolize_keys!
      send("get_lateral_keyphrases", 
           options[:keyphrases] || [],
           !!options[:include_plurals],
           options[:adult_filter] || "off",
           options[:max] || 0,
           options[:timeout] || 0)
    end
    
    # Get a list of popularities for all keywords
    def get_all_words_popularity(options = {})
      options.symbolize_keys!
      send("get_all_words_popularity", 
           options[:keyphrases] || [],
           options[:case] || "case_distinct",
           !!options[:include_misspellings],
           !!options[:include_plurals],
           options[:adult_filter] || "off",
           options[:max] || 0,
           options[:timeout] || 0)
    end

    private 
      # Send a call to the service using the id
      def send(*args)
        args = args.insert(1, @id) # Add the id in the arguments
        meth = args[0] # Method is the 1st argument
        begin
          self.call(*args)
        rescue XMLRPC::FaultException => e
          raise Wordtracker::FaultException.new(0, "RPC error calling #{meth}")
        end
      end
  end
end
