class Redis
  module DataTypes
    TYPES = %w(String Integer Float EpochTime DateTime Json Yaml)
    def self.define_data_types
      TYPES.each do |data_type|
        if Object.const_defined?(data_type)
          klass = Object.const_get(data_type)
        else
          klass = Object.const_set(data_type, Class.new)
        end
        klass.extend const_get(data_type)
      end
    end
    
    module String
      def to_redis(value); value; end
      def from_redis(value); value; end
    end

    module Integer
      def to_redis(value); value.to_s;          end
      def from_redis(value); value && value.to_i; end
    end

    module Float
      def to_redis(value); value.to_s;          end
      def from_redis(value); value && value.to_f; end
    end

    module EpochTime
      def to_redis(value) value.is_a?(Integer) ? Time.at(value) : value end

      def from_redis(value)
        value.is_a?(DateTime) ? value.to_time.to_i : value.to_i
      end
    end

    module DateTime
      def to_redis(value); value.strftime('%FT%T%z');                      end
      def from_redis(value); value && ::DateTime.strptime(value, '%FT%T%z'); end
    end

    module Json
      def to_redis(value); Yajl::Encoder.encode(value);         end
      def from_redis(value); value && Yajl::Parser.parse(value);  end
    end
    
    module Yaml
      def to_redis(value); Yaml.dump(value);    end
      def from_redis(value); Yaml.load(value);  end
    end
  end
end