
# dispatio

[![Gem Version](https://badge.fury.io/rb/dispatio.svg)](http://badge.fury.io/rb/dispatio)

A stupid dispatch table tool.

```ruby
require 'dispatio'

class MyClass

  def consume(type, msg)

    (@ctable ||= Dispatio.make_table(self, 'consume_').call(type, msg)
      # or
    #(@ctable ||= Dispatio.make_table(self, prefix: 'consume_').call(type, msg)
  end

  def post(type, msg)

    (@ptable ||= Dispatio.make_table(self, suffix: '_post').call(type, msg)
  end

  protected

  def consume_this(msg)
    # ...
  end
  def consume_that(msg)
    # ...
  end
  def this_post(msg)
    # ...
  end
  def that_post(msg)
    # ...
  end
end
```

The `Dispatio.make_table(klass, prefix_or_opts)` creates a dispatch table by enumerating the matching (prefix or suffix) methods. One can then `call` (or `dispatch`) the table to call the corresponding method.


## against an instance

```ruby
require 'dispatio'

class Foo

  def consume(name, data)

    dtable.dispatch(name, data) # or
    #dtable.call(name, data)    #
    #dtable.(name, data)        #
    #dtable[name].call(data) # or
    #dtable[name].(data)     #
    #dtable[name][data]      #
      #
      # just use the one you like
  end

  protected

  def validate_foo(data)
    [ self.class, :vfoo, data ]
  end

  def validate_bar(data)
    [ self.class, :vbar, data ]
  end

  def dtable; @dtable ||= Dispatio.make_table(self, 'validate_'); end
    # or
  #def dtable; @dtable ||= Dispatio.make_table(self, prefix: 'validate_'); end
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
require 'dispatio'

class Bar

  class << self

    def consume(name, data)

      dtable.dispatch(name, data) # or
      #dtable.call(name, data)    #
      #dtable.(name, data)        #
      #dtable[name].call(data) # or
      #dtable[name].(data)     #
      #dtable[name][data]      #
        #
        # just use the one you like
    end

    protected

    def validate_foo(data)
      [ self, :vfoo, data ]
    end

    def validate_bar(data)
      [ self, :vbar, data ]
    end

    def dtable; @dtable ||= Dispatio.make_table(self, 'validate_'); end
      # or
    #def dtable; @dtable ||= Dispatio.make_table(self, prefix: 'validate_'); end
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

