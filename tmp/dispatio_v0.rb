
module Dispable

  def make_dispatch_table(prefix)

    Dispable::Table.new(
      prefix,
      self
        .methods
        .select { |m| m.to_s.start_with?(prefix) }
        .inject({}) { |h, m| h[m.to_s[prefix.length..-1]] = method(m); h })
  end

  class Table

    def initialize(prefix, table)

      @prefix = prefix
      @table = table
    end

    def dispatch(name, *args, **opts, &block)

      ( @table[name.to_s] ||
        fail(NoMethodError.new("no :#{@prefix}#{name} method"))
          ).call(*args, **opts, &block)
    end
  end
end

class Foo

  extend Dispable

  class << self

    def consume(name, data)

      dtable.dispatch(name, data)
    end

    protected

    def validate_foo(data)
      p [ Foo, :vfoo, data ]
    end

    def validate_bar(data)
      p [ Foo, :vbar, data ]
    end

    def dtable; @dtable ||= make_dispatch_table('validate_'); end
  end
end

Foo.consume(:foo, 'hello')
Foo.consume('bar', 'none')
#Foo.consume('naz', 'gul')


class Bar

  include Dispable

  def consume(name, data)

    dtable.dispatch(name, data)
  end

  protected

  def validate_foo(data)
    p [ Bar, :vfoo, data ]
  end

  def validate_bar(data)
    p [ Bar, :vbar, data ]
  end

  def dtable; @dtable ||= make_dispatch_table('validate_'); end
end

bar = Bar.new
bar.consume(:foo, 'hello')
bar.consume('bar', 'none')
#bar.consume('naz', 'gul')

