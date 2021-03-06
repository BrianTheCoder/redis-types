require 'redis'
require 'set'
require 'yajl'
require 'extlib'
require 'pathname'

class Redis
  dir = Pathname(__FILE__).dirname.expand_path.to_s    
          
  autoload :FieldProxy,   dir / 'field_proxy'
  autoload :Set,          dir / 'set'
  autoload :List,         dir / 'list'
  autoload :Value,        dir / 'value'
  autoload :DataTypes,    dir / 'data_types'
  
  module Types
    def self.redis=(redis); @redis = redis end
    
    def self.redis; @redis end
    
    class InvalidDataType < StandardError; end
    
    def self.included(model)
      Redis::DataTypes.define_data_types
      model.send :include, Extlib::Hook
      model.extend ClassMethods
    end
    
    module ClassMethods
      attr_accessor :prefix
      
      class NotAValue < StandardError; end
      
      def redis_fields; @_redis_fields ||= {}; end
      
      def indexes; @_indexes ||= {}; end
             
      def set(name, type = String, opts = {})
        redis_field(name, type, ::Redis::Set)
      end
      
      def list(name, type = String, opts = {})
        redis_field(name, type, ::Redis::List)
      end
      
      def value(name, type = String, opts = {})
        redis_field(name, type, ::Redis::Value)
      end
      
      def zset(name, type = String, opts = {})
        redis_field(name, type, ::Redis::Zset)
      end
      
      def redis
        if !Redis::Types.redis.blank?
          @redis = Redis::Types.redis
        else
          @_redis = Redis.new
        end 
      end
      
      def redis=(redis) 
        @redis = redis 
      end
      
      def delete(key)
        self.find(key).destroy                      
      end
      
      def find(key)
        self.new(:id => key)                          
      end
      
      alias :[] :find
      
      def to_redis(value)
        value.id.to_s
      end

      def from_redis(value)
        find(id)
      end
            
      private
      
      def redis_field(name, type, redis_type)
        redis_fields[name.to_s] = redis_type.new(redis, type)
        field_methods name, redis_type.name.split('::').last.downcase
      end
            
      def field_methods(name, type) #:nodoc:
        class_eval <<-RUBY, __FILE__, __LINE__ + 1
          def redis_#{type}_#{name}
            self.class.redis_fields['#{name}'].tap{|type| type.key = field_key('#{name}') }
          end
        RUBY
        define_getter   name, type
        define_bool     name, type
        define_setter   name, type
      end
      
      def define_getter(name, type) #:nodoc:
        class_eval "def #{name}; redis_#{type}_#{name}.get; end"
      end
      
      def define_setter(name, type) #:nodoc:
        class_eval "def #{name}=(value); redis_#{type}_#{name}.set(value); end"
      end
      
      def define_bool(name, type) #:nodoc:
        class_eval "def #{name}?; redis_#{type}_#{name}.blank?; end"
      end
    end
    
    attr_accessor :id, :redis
        
    def initialize(attrs = {})
      attrs.each do |name, value|
        self[name] = value
      end
    end
    
    def generate_id; self.id = self.class.redis.incr("#{self.class.to_s.snake_case}:nextId")  end
    
    def field_key(name); "#{prefix}:#{id}:#{name}"     end
    
    def prefix
      @prefix ||= self.class.prefix || self.class.to_s.
        sub(%r{(.*::)}, '').
        gsub(/([A-Z]+)([A-Z][a-z])/,'\1_\2').
        gsub(/([a-z\d])([A-Z])/,'\1_\2').
        downcase
    end
    
    def redis; @redis ||= self.class.redis end
    
    def [](method)
      raise NoMethodError, "method is undefined: #{method}" unless respond_to?(method)
      send(method)
    end
    
    def []=(method, value)
      raise NoMethodError, "no setter method defined: #{method}=" unless respond_to?(:"#{method}=")
      send(:"#{method}=", value)
    end
    
    def attributes
      self.class.redis_fields.inject({}) do |hsh, (key, value)|
        hsh[key] = self[key]
      end
    end
    
    def destroy(name = nil)
      if name
        redis.delete field_key(name.to_s)
      else
        self.class.redis_fields.each do |field, klass|
          redis.delete field_key(field)
        end
      end
    end
  end
end