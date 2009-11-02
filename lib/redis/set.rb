class Redis::Set
  include Redis::FieldProxy #:nodoc:
  COMMANDS = {
    :intersect_store  => "sinterstore",
    :union_store      => "sunionstore",
    :diff_store       => "sdiffstore",
    :move             => "smove",
  }
  
  def <<(value); redis.sadd key, marshal.dump(value);                     end
  
  def delete(value); redis.srem key, marshal.dump(value);                 end
  
  def include?(value); redis.sismember(key, marshal.dump(value)) == 1;    end
  
  alias_method :add, :<<
  alias_method :remove, :delete
  alias_method :has_key?, :include?
  alias_method :member?, :include?
  
  def members
    redis.smembers(key).map{|value| marshal.load(value) }
  end
  
  def intersect(*keys)
    redis.sinter(key, *keys).map{|value| marshal.load(value) }
  end
  
  def union(*keys)
    redis.sunion(@key, *keys).map{|value| marshal.load(value) }
  end
  
  def diff(*keys)
    redis.sdiff(key, *keys).map{|value| marshal.load(value) }
  end
  
  def length; redis.llen(key);                      end
  
  def to_s; members.join(', ');                     end
  
  def set(value)
    
  end

  protected

  def translate_method_name(m); COMMANDS[m];        end
end