class Redis
  module FieldProxy #:nodoc
    attr_accessor :redis, :key, :marshal

    def initialize(redis, marshal)
      @redis    = redis
      @key      = key
      @marshal  = marshal
      validate_marshal
    end

    def method_missing(method, *argv)
      translated_method = translate_method_name(method)
      raise NoMethodError.new("Method '#{method}' is not defined") unless translated_method
      @redis.send translated_method, @key, *argv
    end

    protected
    
    def validate_mashal
      @marshal.extend Redis::DataTypes::TO unless @marshal.responds_to?(:to_redis)
      @marshal.extend Redis::DataTypes::FROM unless @marshal.responds_to?(:from_redis)
    end
  
    def translate_method_name(m); m; end
  end
end