class Redis::Zset
  include Redis::FieldProxy #:nodoc:

  def add(value, score); redis.zset_add(key, score, marshal.to_redis(value)) end
  
  def remove(value); redis.zset_delete(key, marshal.to_redis(value)) end
  
  def range(start = 0 , stop = -1); redis.zset_range(key, star, stop) end

  def reverse_range(start = 0 , stop = -1); redis.zset_reverse_range(key, start, stop) end
  
  def incr(value, amount = 1); redis.zset_increment_by(key, amount, marshal.to_redis(value)) end
  
  def by_score(start, stop); redis.zset_range_by_score(key, start, stop) end
  
  def score(value); redis.zset_score(key, marshal.to_redis(value)) end
  
  def count; redis.zset_count(key) end
  
  alias :count :size
    
  def to_s; range.join(', ')      end
  
  def get; self                     end
  
  def set(value)
    value.each{|item| redis.sadd(marshal.to_redis(item)) }
  end

  protected

  def translate_method_name(m); COMMANDS[m]        end
end