require 'iconv'
require 'yaml'
require 'request'

class Eport
  attr_writer :ep_point, :ep_key, :ep_host

  def initialize(&block)
    @ep_point = nil
    @ep_key   = nil
    @ep_host  = nil   # Will be depricated in later versions, be careful!

    # Take configuration from eport.yml located in Rails config folder
    if defined?(RAILS_ROOT)
      config_file_path = File.join(RAILS_ROOT, 'config', 'eport.yml')
      @config   = YAML.load(IO.read(config_file))
      @ep_point = @config[:eport][:point]
      @ep_key   = @config[:eport][:private_key_path]
      @ep_host  = @config[:eport][:host]
    
    # or fetch options from given block.
    elsif block_given?
      yield self
    
    # In other case library will not work.
    else
      raise StandardError, "If you using eport gem outside Rails you must specify configuration options through block"
    end
  end
  
  def get_catalog
    req = Request.new do |r|
      r.point = @config[:eport][:point]
      r.private_key_path = "#{RAILS_ROOT}/#{@config[:eport][:private_key_path]}"

      r.host = @config[:eport][:host]
      r.path = "/cp/dir"
      r.body = ""
    end

    data = req.confirm
    cp   = CatalogParser.new
    cp.new_catalog(data)    
  end  
  
  def get_balance
   req = Request.new do |r|
     r.point = @ep_point
     r.private_key_path = @ep_key
     r.host  = @ep_host
     r.path  = "/cp/bal"
     r.body  = ""
   end

   ic = Iconv.new('UTF-8', 'WINDOWS-1251')
   ic.iconv(req.confirm)    
  end
  
  def refill_operation(operation_name, operation_id, product_id, value, account)
    req = Request.new do |r|
      r.point = @ep_point
      r.private_key_path = @ep_key

      r.host = @ep_host
      r.path = "/cp/fe"

      req = EportRequestPlainText.new

      req.operation_type = operation_name.to_s.upcase if [:operation, :confirm, :check, :cancel].include?(operation_name)
      req.operation_id   = operation_id
      req.product_id     = product_id
      req.value          = value
      req.account        = account

      r.body = req.body
    end

    ic = Iconv.new('UTF-8', 'WINDOWS-1251')
    ic.iconv(req.confirm)
   end
  
end