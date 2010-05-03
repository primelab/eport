require "net/http"
require "net/https"


class Request
  attr_accessor :point, :private_key_path, :host, :path, :additional_headers, :body

  def initialize(&block)
    yield self if block_given?

    @headers = {
      "Content-Type"   => "text/plain; charset=Windows-1251",
      "Content-Length" => @body.size.to_s,
      "X-Eport-Auth"   => "point=#{@point}; sign=\"#{signature(@body)}\"; encoding=\"hex\""
    }.merge(additional_headers || {})
  end
  
  def confirm
    http = Net::HTTP.new(@host, 443)
    http.use_ssl = true
    http.verify_mode = OpenSSL::SSL::VERIFY_NONE
    puts @headers.inspect
    resp, data = http.post(@path, @body, @headers)
    data
  end
  
  private
  
  def signature(text = nil, kind = "hex")
    if text.nil?
      raise ArgumentError, "Parameter named \"body\" must be not nil"
    end
    
    if @private_key_path.nil? || @private_key_path.empty?
      raise ArgumentError, "No private key provided"
    end
    
    signature = `echo -n '#{text}' | openssl dgst -md5 -sign #{@private_key_path} -hex`.strip
  end
  
end
