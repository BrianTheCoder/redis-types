class Redis::Counter
  attr_accessor :redis, :key

  def initialize(redis, key)
    self.redis = redis
    self.key = key
  end
  
  def incr
    redis.incr(key)
  end
  
  def decr
    redis.decr(key)
  end
end