class Redis
  class DataTypes
    class String
      def self.dump(value); value;                                          end
      def self.load(value); value;                                          end
    end

    class Integer
      def self.dump(value); value.to_s;                                     end
      def self.load(value); value && value.to_i;                            end
    end

    class Float
      def self.dump(value); value.to_s;                                     end
      def self.load(value); value && value.to_f;                            end
    end

    class EpochTime < Time
      def self.dump(value)
        value.is_a?(Integer) ? Time.at(value) : value
      end

      def self.load(value)
        return value.to_time.to_i if value.is_a? DateTime
        value.to_i
      end
    end

    class DateTime
      def self.dump(value); value.strftime('%FT%T%z');                      end
      def self.load(value); value && ::DateTime.strptime(value, '%FT%T%z'); end
    end

    class Json
      def self.dump(value); Yajl::Encoder.encode(value);                    end
      def self.load(value); v && Yajl::Parser.parse(value);                 end
    end
  end
end