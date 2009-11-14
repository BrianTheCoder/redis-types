class Redis
  module FieldProxy #:nodoc
    attr_accessor :redis, :key, :marshal

    def initialize(redis, marshal)
      @redis    = redis
      @key      = key
      @marshal  = marshal
      check_for_redis_serialization
    end

    def method_missing(method, *argv)
      translated_method = translate_method_name(method)
      raise NoMethodError.new("Method '#{method}' is not defined") unless translated_method
      @redis.send translated_method, @key, *argv
    end

    protected
    
    def check_for_redis_serialization
      unless @marshal.respond_to?(:to_redis)
        @marshal.instance_eval "def to_redis(value); value.to_s end"
      end
      unless @marshal.respond_to?(:from_redis)
        @marshal.instance_eval "def from_redis(value); value end"
      end
    end
  
    def translate_method_name(m); m; end
  end
end