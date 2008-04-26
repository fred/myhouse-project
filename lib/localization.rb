require 'iconv'

module RForum; module Localization
  
  LOCALIZED_STRINGS = {}

  def l(*a) RForum::Localization.l(*a) end

  def self.l(symbol, *arguments)
    language = RForum::CONFIG[:default_language]

    symbol = symbol.to_sym if symbol.is_a? String

    # translation of an LString is simply a call to to_s
    return symbol.to_s if symbol.is_a? LString
  
    # translation of an array
    if symbol.is_a? Array 
      raise ArgumentError.new("Cannot translate an empty array") if symbol.empty?
      raise ArgumentError.new("Symbol is an array, arguments must be empty") unless arguments.empty?
      arguments = symbol
      symbol = arguments.shift
    end
  
    translation = (LOCALIZED_STRINGS[language][symbol] or
      LOCALIZED_STRINGS['en'][symbol] or
        symbol.to_s)
    begin
      return translation % arguments
    rescue => e
      raise ArgumentError.new("Translation value #{translation.inspect} " + 
          "with arguments #{arguments.inspect} caused error '#{e.message}'")
    end
  end

  def valid_language?(language)
    LOCALIZED_STRINGS.has_key? language
  end

  def self.load_localized_strings
    # Load language files
    Dir[RAILS_ROOT + '/lang/*.yaml'].each do |filename|
      filename =~ /([a-z]+)\.yaml$/
      hash = YAML::load(File.read(filename))
      file_charset = hash['file_charset'] || 'utf-8'

      # convert string keys to symbols
      symbol_hash = Hash.new
      Iconv.open(RForum::CONFIG[:web_charset], file_charset) do |i|
        hash.each do |key, value|
          symbol_hash[key.to_sym] = i.iconv(value)
          if symbol_hash[key.to_sym].empty?
            symbol_hash[key.to_sym] = nil
          end
        end
      end
        
      LOCALIZED_STRINGS[$1] = symbol_hash
    end
  end

  class LString
  
    include RForum::Localization
    
    def initialize(symbol, arguments)
      @symbol, @arguments = symbol, arguments
    end

    def to_s
      l(@symbol, @arguments)
    end
  end
  
end; end
