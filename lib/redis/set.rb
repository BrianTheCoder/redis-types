class Redis::Set
  include Redis::FieldProxy #:nodoc:
  COMMANDS = {
    :intersect_store  => "sinterstore",
    :union_store      => "sunionstore",
    :diff_store       => "sdiffstore",
    :move             => "smove",
  }
  
  def <<(value); redis.sadd key, marshal.to_redis(value)                     end
  
  def delete(value); redis.srem key, marshal.to_redis(value)                 end
  
  def include?(value); redis.sismember(key, marshal.to_redis(value))         end
  
  def length; redis.set_count(key)  end
  
  alias_method :add, :<<
  alias_method :remove, :delete
  alias_method :has_key?, :include?
  alias_method :member?, :include?
  alias_method :size, :length
  
  def members
    redis.smembers(key).map{|value| marshal.from_redis(value) }
  end
  
  def intersect(*keys)
    redis.sinter(key, *keys).map{|value| marshal.from_redis(value) }
  end
  
  def union(*keys)
    redis.sunion(@key, *keys).map{|value| marshal.from_redis(value) }
  end
  
  def diff(*keys)
    redis.sdiff(key, *keys).map{|value| marshal.from_redis(value) }
  end
    
  def to_s; members.join(', ')      end
  
  def get; self                     end
  
  def set(value)
    value.each{|item| redis.sadd(marshal.to_redis(item)) }
  end

  protected

  def translate_method_name(m); COMMANDS[m]        end
end