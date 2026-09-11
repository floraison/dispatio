
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

  test 'against instance' do

    foo = Foo.new

    assert foo.consume(:foo, 'hello'), [ Foo, :vfoo, 'hello' ]
  end

  #test 'against singleton class' do
  #  assert foo.consume(:foo, 'hello'), [ Foo, :vfoo, 'hello' ]
  #end
end

