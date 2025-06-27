module Minerals
  macro this
    self.class
  end

  def extract(obj : T, & : ->R) : ::Tuple(T, R) forall T, R
    {obj, with obj yield}
  end

  # Execute a block of code with the given
  # object *obj* as *self*.
  def on(obj : T, & : ->R) : R forall T, R
    with obj yield
  end

  # Returns the class of the object if it is not already a class.
  macro to_class(obj)
    {{ obj }}.class unless {{ obj }}.is_a?(::Object.class)
  end
end
