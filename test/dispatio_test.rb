
#
# Testing dispatio
#
# Fri Sep 11 09:59:11 JST 2026  Hiroshima
#

group 'Dispatio' do

  class Foo

    def consume(name, data)

      dtable.dispatch(name, data)
    end

    protected

    def validate_foo(data)
      [ self.class, :vfoo, data ]
    end

    def validate_bar(data)
      [ self.class, :vbar, data ]
    end

    def dtable; @dtable ||= Dispatio.make_table(self, 'validate_'); end
  end

  class Bar

    class << self

      def consume(name, data)

        dtable.dispatch(name, data)
      end

      protected

      def validate_foo(data)
        [ self, :vfoo, data ]
      end

      def validate_bar(data)
        [ self, :vbar, data ]
      end

      def dtable; @dtable ||= Dispatio.make_table(self, 'validate_'); end
    end
  end

  class Baz; class << self

    def consume0(name, data)

      dtable.call(name, data)
    end

    def consume1(name, data)

      dtable[name].call(data)
    end

    def consume2(name, data)

      dtable[name].(data)
    end

    def consume3(name, data)

      dtable.(name, data)
    end

    protected

    def validate_foo(data)
      [ self, :vfoo, data ]
    end

    def dtable; @dtable ||= Dispatio.make_table(self, 'validate_'); end
  end; end

  test 'against instance' do

    foo = Foo.new

    assert foo.consume(:foo, 'hello'), [ Foo, :vfoo, 'hello' ]
    assert foo.consume(:bar, 'world'), [ Foo, :vbar, 'world' ]

    assert foo.consume('foo', 'hello'), [ Foo, :vfoo, 'hello' ]
    assert foo.consume('bar', 'world'), [ Foo, :vbar, 'world' ]

    assert_error(
      lambda { foo.consume(:nada, 'nemo') },
      NoMethodError, 'no :validate_nada method')
  end

  test 'against singleton class' do

    assert Bar.consume(:foo, 'hello'), [ Bar, :vfoo, 'hello' ]
    assert Bar.consume(:bar, 'world'), [ Bar, :vbar, 'world' ]

    assert Bar.consume('foo', 'hello'), [ Bar, :vfoo, 'hello' ]
    assert Bar.consume('bar', 'world'), [ Bar, :vbar, 'world' ]

    assert_error(
      lambda { Bar.consume(:nada, 'nemo') },
      NoMethodError, 'no :validate_nada method')
  end

  test 'calls Baz' do

    assert Baz.consume0(:foo, 'seven'), [ Baz, :vfoo, 'seven' ]
    assert Baz.consume1(:foo, 11), [ Baz, :vfoo, 11 ]
    assert Baz.consume2(:foo, 12), [ Baz, :vfoo, 12 ]
    assert Baz.consume3(:foo, 13), [ Baz, :vfoo, 13 ]
  end
end

