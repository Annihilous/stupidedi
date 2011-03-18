module Stupidedi
  module Envelope

    class TransactionSetVal < Values::AbstractVal

      # @return [TransactionSetDef]
      attr_reader :definition

      # @return [Array<TableVal>]
      attr_reader :table_vals

      # @return [FunctionalGroupVal]
      attr_reader :parent

      def initialize(definition, table_vals, parent)
        @definition, @table_vals, @parent =
          definition, table_vals, parent
      end

      # @return [TransactionSetVal]
      def copy(changes = {})
        self.class.new \
          changes.fetch(:definition, @definition),
          changes.fetch(:table_vals, @table_vals),
          changes.fetch(:parent, @parent)
      end

      # @return [TransactionSetVal]
      def append(child_val)
        unless child_val.is_a?(Values::TableVal)
          raise TypeError, child_val.class.name
        end

        copy(:table_vals => child_val.snoc(@table_vals))
      end

      alias append_table append

      # @private
      def pretty_print(q)
        id = @definition.try{|d| "[#{d.functional_group}#{d.id}]" }
        q.text("TransactionSetVal#{id}")
        q.group(2, "(", ")") do
          q.breakable ""
          @table_vals.each do |e|
            unless q.current_group.first?
              q.text ","
              q.breakable
            end
            q.pp e
          end
        end
      end

      # @return [Boolean]
      def ==(other)
        other.definition == @definition and
        other.table_vals == @table_vals
      end
    end

  end
end
