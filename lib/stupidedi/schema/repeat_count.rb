module Stupidedi
  module Schema

    class RepeatCount
      class Bounded < RepeatCount

        # @return [Integer]
        attr_reader :max

        def initialize(max)
          @max = max
        end

        def include?(n)
          n <= @max
        end

        def inspect
          @max.to_s
        end
      end

      # @private
      Once = Class.new(Bounded) do
        def initialize
          @max = 1
        end
      end.new

      # @private
      Unbounded = Class.new(RepeatCount) do
        def include?(n)
          true
        end

        def inspect
          ">1"
        end
      end.new
    end

    class << RepeatCount
      # @group Constructors
      #########################################################################

      def bounded(n)
        if n < 1
          raise Exception::InvalidSchemaError,
            "n must be positive"
        elsif n == 1
          RepeatCount::Once
        else
          RepeatCount::Bounded.new(n)
        end
      end

      def unbounded
        RepeatCount::Unbounded
      end

      # @endgroup
      #########################################################################
    end

  end
end
