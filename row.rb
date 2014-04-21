class Row
  attr_accessor :date, :location, :user_name, :text
  
  def initialize( args= { :type => SYSTEM } )
    args.each_pair do | key, value |
      self.send("#{key}=", value)
    end
  end

  def to_json
    hash = {}
  
    self.instance_variables.each do |var|
      hash[var] = self.instance_variable_get var
    end
  
    hash.to_json
  end

  def from_json! string
    JSON.load(string).each do |var, val|
      self.instance_variable_set var, val
    end
  end

end