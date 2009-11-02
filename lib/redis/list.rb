class Redis::List
  include Redis::FieldProxy #:nodoc:
  
  def <<(value) redis.rpush key, marshal.dump(value);                     end
  
  def push_head(value); redis.lpush key, marshal.dump(value);             end
  
  def pop_tail; marshal.load(redis.rpop(key));                    end
  
  def pop_head; marshal.load(redis.lpop(key));                    end
  
  def [](from, to = nil)
    if to.nil?
      marshal.load(redis.lindex(key, from))
    else
      redis.lrange(key, from, to).map!{|value| marshal.load(value) }
    end
  end

  def []=(index, value); redis.lset(key, index, marshal.dump(value));     end

  alias_method :range, :[]
  alias_method :push_tail, :<<  
  alias_method :set, :[]=
  
  def include?(value); redis.exists(key, marshal.dump(value));            end
  
  def remove(count, value); redis.lrem(key, count, marshal.dump(value));  end
  
  def length; redis.llen(key);                                     end
  
  def trim(from, to); redis.ltrim(key, from, to);                  end
  
  def to_s; range(0, 100).join(', ');                                end
  
  def set(value)
  
  end
  
  protected
  
  def translate_method_key(m); COMMANDS[m];                          end
end