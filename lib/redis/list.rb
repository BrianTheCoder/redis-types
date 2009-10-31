class Redis::List
  include Redis::FieldProxy #:nodoc:
  def <<(v)
    @redis.rpush @key, @marshal.dump(v)
  end
  
  def push_head(v); @redis.lpush @key, @marshal.dump(v);             end
  
  def pop_tail; @marshal.load(@redis.rpop(@key));                    end
  
  def pop_head; @marshal.load(@redis.lpop(@key));                    end
  
  def [](from, to = nil)
    if to.nil?
      @marshal.load(@redis.lindex(@key, from))
    else
      @redis.lrange(@key, from, to).map! { |v| @marshal.load(v) }
    end
  end

  def []=(index, v); @redis.lset(@key, index, @marshal.dump(v));     end


  alias_method :range, :[]
  alias_method :push_tail, :<<  
  alias_method :set, :[]=
  
  def include?(v); @redis.exists(@key, @marshal.dump(v));            end
  
  def remove(count, v); @redis.lrem(@key, count, @marshal.dump(v));  end
  
  def length; @redis.llen(@key);                                     end
  
  def trim(from, to); @redis.ltrim(@key, from, to);                  end
  
  def to_s; range(0, 100).join(', ');                                end
  
  def set(value)
    
  end
  
  protected
  
  def translate_method_key(m); COMMANDS[m];                          end
end