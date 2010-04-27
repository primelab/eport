require "iconv"

class EportResultPlainText
  STRING_SEPARATOR    = "\r\n"
  
  KEY_VALUE_SEPARATOR = "="
  
  attr_reader :code, :omsg, :cmsg, :pmsg, :card, :pin
  
  def initialize(body = nil)
    @code = nil
    @omsg = nil
    @cmsg = nil
    @pmsg = nil
    @card = nil
    @pin  = nil
    
    unless body.nil?
      parse(body)
    else
      raise ArgumentError, "Parameter named \"body\" must be not nil"
    end
  end
  
  private
  def parse(body)
    strings = body.strip.split(STRING_SEPARATOR)
    strings[1..-1].each do |string|
      key, value = string.split(KEY_VALUE_SEPARATOR)
      case key
        when "code"
          @code = value
        when "omsg"
          @omsg = value
        when "cmsg"
          ic = Iconv.new('UTF-8', 'WINDOWS-1251')
          @cmsg = ic.iconv(value)
        when "pmsg"
          @pmsg = value
        when "card"
          @card = value
        when "pin"
          @pin = value
      end
    end
  end
end