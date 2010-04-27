require "iconv"
require "yaml"

class Eport
  
  def initialize
    config_file = File.join(RAILS_ROOT, 'config', 'eport.yml')
    @config = YAML.load(IO.read(config_file)) 
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
    cp = CatalogParser.new
    cp.new_catalog(data)    
  end  
  
  def do_refill_operation(operation_id, product_id, value, account)
    req = Request.new do |r|
    r.point = @config[:eport][:point]
    r.private_key_path = "#{RAILS_ROOT}/#{@config[:eport][:private_key_path]}"

    r.host = @config[:eport][:host]
    r.path = "/cp/fe"
   
    req = EportRequestPlainText.new
    req.operation_type = "OPERATION"
    req.operation_id   = operation_id
    req.product_id     = product_id
    req.value          = value
    req.account        = account
    r.body = req.body
   end
   ic = Iconv.new('UTF-8', 'WINDOWS-1251')
   ic.iconv(req.confirm)
  end
  
  def confirm_refill_operation(operation_id, product_id, value, account)
     req = Request.new do |r|
     r.point = @config[:eport][:point]
     r.private_key_path = "#{RAILS_ROOT}/#{@config[:eport][:private_key_path]}"

     r.host = @config[:eport][:host]
     r.path = "/cp/fe"

     req = EportRequestPlainText.new
     req.operation_type = "CONFIRM"
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
