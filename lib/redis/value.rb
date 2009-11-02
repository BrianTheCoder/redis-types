class Redis::Value
  include Redis::FieldProxy
  
  def set(value); redis[key] = marshal.dump(value);     end
  
  def get; marshal.load(redis[key]);                    end
end