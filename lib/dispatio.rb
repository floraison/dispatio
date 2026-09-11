
module Dispatio

  VERSION = '1.0.0'.freeze

  class << self

    def make_table(point, prefix)

      Dispatio::Table.new(
        prefix,
        point
          .methods
          .select { |m|
            m.to_s.start_with?(prefix) }
          .inject({}) { |h, m|
            h[m.to_s[prefix.length..-1]] = point.method(m)
            h }
      ).freeze
    end
  end

  class Table

    def initialize(prefix, table)

      @prefix = prefix
      @table = table.freeze
    end

    def dispatch(name, *args, **opts, &block)

      ( @table[name.to_s] ||
        fail(NoMethodError.new("no :#{@prefix}#{name} method"))
          ).call(*args, **opts, &block)
    end
  end
end

