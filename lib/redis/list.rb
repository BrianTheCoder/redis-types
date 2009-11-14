class Redis::List
  include Redis::FieldProxy #:nodoc:
  
  def <<(value) redis.rpush key, marshal.to_redis(value);                     end
  
  def push_head(value); redis.lpush key, marshal.to_redis(value);             end
  
  def pop_tail; marshal.from_redis(redis.rpop(key));                          end
  
  def pop_head; marshal.from_redis(redis.lpop(key));                          end
  
  def [](from, to = nil)
    if to.nil?
      marshal.from_redis(redis.lindex(key, from))
    else
      redis.lrange(key, from, to).map!{|value| marshal.from_redis(value) }
    end
  end

  def []=(index, value); redis.lset(key, index, marshal.to_redis(value));     end

  alias_method :range, :[]
  alias_method :push_tail, :<<  
  alias_method :set, :[]=
  
  def include?(value); redis.exists(key, marshal.to_redis(value));            end
  
  def remove(count, value); redis.lrem(key, count, marshal.to_redis(value));  end
  
  def length; redis.llen(key);                    end
  
  def trim(from, to); redis.ltrim(key, from, to); end
  
  def to_s; range(0, 100).join(', ');             end
  
  def get; self                                   end
  
  def set(value)
    value.each{|item| redis.rpush(marshal.to_redis(item)) }
  end
  
  protected
  
  def translate_method_key(m); COMMANDS[m];                          end
end