
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

  test 'against instance' do

    foo = Foo.new

    assert foo.consume(:foo, 'hello'), [ Foo, :vfoo, 'hello' ]
    assert foo.consume(:bar, 'world'), [ Foo, :vbar, 'world' ]

    assert_error(
      lambda { foo.consume(:nada, 'nemo') },
      NoMethodError, 'no :validate_nada method')
  end

  test 'against singleton class' do

    assert Bar.consume(:foo, 'hello'), [ Bar, :vfoo, 'hello' ]
    assert Bar.consume(:bar, 'world'), [ Bar, :vbar, 'world' ]

    assert_error(
      lambda { Bar.consume(:nada, 'nemo') },
      NoMethodError, 'no :validate_nada method')
  end
end

