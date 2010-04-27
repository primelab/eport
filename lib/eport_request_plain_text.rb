class EportRequestPlainText
  OPERATION_TYPES = [
    "CHECK",
    "OPERATION",
    "CONFIRM",
    "CANCEL"
  ]
  
  STRING_SEPARATOR = "\r\n"
  
  attr_accessor :operation_type, :operation_id, :product_id, :value, :account
  
  def operation_type=(value)
    if OPERATION_TYPES.include?(value.upcase)
      @operation_type = value
    else
      raise ArgumentError, "Not supported operation type \"#{value}\""
    end
  end
  
  def initialize(&block)
    @operation_type = nil
    @operation_id   = nil
    @product_id     = nil
    @value          = nil
    @account        = nil
    
    if block
      block.call
    end
  end
  
  def body
    output = ""
    output << @operation_type + STRING_SEPARATOR
    output << key_value("id", @operation_id)
    output << key_value("checkid", @operation_id)
    output << key_value("product", @product_id)
    output << key_value("value", @value)
    output << key_value("account", @account)
    output
  end
  
  private
  def key_value(key, value)
    "#{key}=#{value}#{STRING_SEPARATOR}"
  end
end

#req = EportRequestPlainText.new
#req.operation_type = "OPERATION"
#puts req.body