
# dispatio

A stupid dispatch table tool.

## against an instance

```ruby
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

foo = Foo.new

foo.consume(:foo, 'hello') # ==> [ Foo, :vfoo, 'hello' ]
foo.consume(:bar, 'world') # ==> [ Foo, :vbar, 'world' ]

foo.consume('foo', 'hello') # ==> [ Foo, :vfoo, 'hello' ]
foo.consume('bar', 'world') # ==> [ Foo, :vbar, 'world' ]

foo.consume(:nada, 'nemo') # ==> NoMethodError, 'no :validate_nada method'
```

## against a singleton class

```ruby
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

Bar.consume(:foo, 'hello') # ==> [ Bar, :vfoo, 'hello' ]
Bar.consume(:bar, 'world') # ==> [ Bar, :vbar, 'world' ]

Bar.consume('foo', 'hello') # ==> [ Bar, :vfoo, 'hello' ]
Bar.consume('bar', 'world') # ==> [ Bar, :vbar, 'world' ]

Bar.consume(:nada, 'nemo') # ==> NoMethodError, 'no :validate_nada method'
```


## LICENSE

MIT, see [LICENSE.txt](LICENSE.txt)

