require "./requires"

module Minerals
  PATCHES = ""
  NUL = 0u8

  macro this
    self.class
  end

  def extract(obj, &)
    {obj, with obj yield}
  end

  # Execute a block of code with the given
  # object *obj* as *self*.
  def on(obj, &)
    with obj yield
  end

  macro noimplement(*args)
    def {{ *args }}
      raise ::NotImplementedError.new({% @def.try &.name || @caller.try &.first.try &.name || "" %})
    end
  end

  # Returns the class of the object if it is not already a class.
  macro to_class(obj)
    obj.class unless obj.is_a?(::Object.class)
  end
end

require "./patch"
require "./lowlevel/ref"
include Minerals::Patch
include Minerals
