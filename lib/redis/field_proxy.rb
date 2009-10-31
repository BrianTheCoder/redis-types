class Redis
  module FieldProxy #:nodoc
    attr_accessor :redis, :key, :marshal

    def initialize(redis, marshal)
      @redis    = redis
      @key      = key
      @marshal  = marshal
    end

    def method_missing(method, *argv)
      translated_method = translate_method_name(method)
      raise NoMethodError.new("Method '#{method}' is not defined") unless translated_method
      @redis.send translated_method, @key, *argv
    end

    protected
  
    def translate_method_name(m); m; end
  end
end