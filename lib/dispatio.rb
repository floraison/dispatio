
module Dispatio

  VERSION = '1.3.0'.freeze

  class << self

    def make_table(point, prefix_or_opts)

      opts =
        case poo = prefix_or_opts
        when /\A_/ then { suffix: poo }
        when String then { prefix: poo }
        else poo; end

      fail(
        ArgumentError,
        "2nd arg to Dispatio.make_table must be a string or option hash"
      ) unless opts.is_a?(Hash)

      optklas = [ opts[:prefix], opts[:suffix] ].compact.map(&:class).uniq
        #
      fail(
        ArgumentError,
        "missing or invalid prefix: or suffix: option"
      ) unless optklas == [ String ]

      Dispatio::Table.new(
        opts,
        point
          .methods
          .inject({}) { |h, m|
            if px = opts[:prefix]
              h[m.to_s[px.length..-1]] = point.method(m) \
                if m.to_s.start_with?(px)
            else; sx = opts[:suffix]
              h[m.to_s[0..-(sx.length + 1)]] = point.method(m) \
                if m.to_s.end_with?(sx)
            end
            h }
      ).freeze
    end
  end

  class Table

    def initialize(opts, table)

      @opts = opts
      @table = table.freeze
    end

    def [](name)

      @table[name.to_s]
    end

    def call(name, *args, **opts, &block)

      m = self[name]

      fail(
        NoMethodError,
        @opts[:prefix] ?
          "no :#{@opts[:prefix]}#{name} method" :
          "no :#{name}#{@opts[:suffix]} method"
            ) unless m

      m.call(*args, **opts, &block)
    end
    alias dispatch call

    def names

      @table.keys
    end

    def include?(name)

      @table.keys.include?(name.to_s)
    end
  end
end

