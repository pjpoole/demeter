module Foo
  def self.foo
    ObjectSpace.each_object(Module).count
  end
end

p Foo.foo
