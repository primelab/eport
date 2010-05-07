class CatalogParser
  attr_accessor :catalog 
  
  def initialize()
    @catalog = { :v => [], :x => [], :e => [], :p => [] }
  end
  
  
  ITEM_SEPARATOR = "\r\n"
  VALUE_SEPARATOR = "\t"
  
  VALUES = {:x => [:version, :prev_version, :form_date, :money], 
            :v => [:id, :name], 
            :e => [:id, :provider_id, :name, :money_restriction, :price, :agent_max_value, :agent_value, :client_attributes, :client_attributes_regexp],
            :p => [:body] }


  def new_catalog(data)   
    ic = Iconv.new('UTF-8', 'WINDOWS-1251')
    strings = data.split(ITEM_SEPARATOR)
    strings[1..-1].each do |string|
      values = string.split(VALUE_SEPARATOR)
      type = ic.iconv(values[0]).to_s
      key = type.last.to_sym
      if ["+v", "+x", "+e", "+p"].include?(type)
        hash = {}
        VALUES[key].each_with_index{|o, index| hash[VALUES[key][index]] = ic.iconv(values[index+1]).to_s}
        @catalog[key] << hash      
      end
    end
   @catalog
  end
end