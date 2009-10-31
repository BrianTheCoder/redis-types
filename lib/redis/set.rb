class Redis::Set < Set
  include Redis::FieldProxy #:nodoc:
  COMMANDS = {
    :intersect_store  => "sinterstore",
    :union_store      => "sunionstore",
    :diff_store       => "sdiffstore",
    :move             => "smove",
  }
  
  def <<(v); @redis.sadd @key, @marshal.dump(v);                     end
  
  def delete(v); @redis.srem @key, @marshal.dump(v);                 end
  
  def include?(v); @redis.sismember @key, @marshal.dump(v);          end
  
  alias_method :add, :<<
  alias_method :remove, :delete
  alias_method :has_key?, :include?
  alias_method :member?, :include?
  
  def members
    @redis.smembers(@key).map { |v| @marshal.load(v) }
  end
  
  def intersect(*keys)
    @redis.sinter(@key, *keys).map { |v| @marshal.load(v) }
  end
  
  def union(*keys)
    @redis.sunion(@key, *keys).map { |v| @marshal.load(v) }
  end
  
  def diff(*keys)
    @redis.sdiff(@key, *keys).map { |v| @marshal.load(v) }
  end
  
  def length; @redis.llen(@key);                    end
  
  def to_s; members.join(', ');                     end
  
  def set(value)
    
  end

  protected

  def translate_method_name(m); COMMANDS[m];        end
end