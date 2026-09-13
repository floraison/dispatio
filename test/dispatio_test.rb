
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

  class Baz; class << self

    def consume0(name, data); dtable.call(name, data); end
    def consume1(name, data); dtable[name].call(data); end
    def consume2(name, data); dtable[name].(data); end
    def consume3(name, data); dtable.(name, data); end
    def consume4(name, data); dtable[name][data]; end

    protected

    def validate_foo(data)
      [ self, :vfoo, data ]
    end

    def dtable; @dtable ||= Dispatio.make_table(self, 'validate_'); end
  end; end

  test 'calls Baz' do

    assert Baz.consume0(:foo, 'seven'), [ Baz, :vfoo, 'seven' ]
    assert Baz.consume1(:foo, 11), [ Baz, :vfoo, 11 ]
    assert Baz.consume2(:foo, 12), [ Baz, :vfoo, 12 ]
    assert Baz.consume3(:foo, 13), [ Baz, :vfoo, 13 ]
    assert Baz.consume4(:foo, -1), [ Baz, :vfoo, -1 ]
  end

  class Preposterous; class << self

    def post(name, msg); dtable.dispatch(name, msg); end

    protected

    def post_alservice(msg); [ :postal, msg ]; end

    def dtable; @dtable ||= Dispatio.make_table(self, prefix: 'post_'); end
  end; end

  class Sufficient; class << self

    def post(name, msg); dtable.dispatch(name, msg); end

    protected

    def foo_post(msg); [ :foop, msg ]; end

    def dtable; @dtable ||= Dispatio.make_table(self, suffix: '_post'); end
  end; end

  group 'prefix: and suffix:' do

    test 'prefix:' do

      assert Preposterous.post(:alservice, 'hello'), [ :postal, 'hello' ]
      assert Preposterous.post('alservice', 'world'), [ :postal, 'world' ]

      assert_error(
        lambda { Preposterous.post(:nada, 'meh') },
        NoMethodError, 'no :post_nada method')
    end

    test 'suffix:' do

      assert Sufficient.post(:foo, 'hello'), [ :foop, 'hello' ]
      assert Sufficient.post('foo', 'world'), [ :foop, 'world' ]

      assert_error(
        lambda { Sufficient.post(:nada, 'meh') },
        NoMethodError, 'no :nada_post method')
    end
  end
end

