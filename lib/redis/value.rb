class Redis::Value
  include Redis::FieldProxy
  
  def set(value)
    return if value.nil?
    redis[key] = marshal.to_redis(value)       
  end
  
  def get
    marshal.from_redis(redis[key])                    
  end
end