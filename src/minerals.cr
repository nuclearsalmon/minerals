require "./requires"

module Minerals
  extend self

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

  macro noimplement(&block)
    def {{ &block }}
      raise ::NotImplementedError.new({% @def.try &.name || @caller.try &.first.try &.name || "" %})
    end
  end

  macro not_implemented(name)
    {% if name.is_a?(TypeDeclaration) %}
      {% var_name = name.var.id %}
      {% type = name.type %}
    {% elsif name.is_a?(Assign) %}
      {% var_name = name.target %}
      {% type = nil %}
    {% else %}
      {% var_name = name.id %}
      {% type = nil %}
    {% end %}

    def {{var_name}} {% if type %} : {{type}} {% end %}
      raise ::NotImplementedError.new({% verbatim do %}
        {% @def.try &.name || @caller.try &.first.try &.name || "" %}
      {% end %})
    end
  end

  macro class_not_implemented(name)
    {% if name.is_a?(TypeDeclaration) %}
      {% var_name = name.var.id %}
      {% type = name.type %}
    {% elsif name.is_a?(Assign) %}
      {% var_name = name.target %}
      {% type = nil %}
    {% else %}
      {% var_name = name.id %}
      {% type = nil %}
    {% end %}

    def self.{{var_name}} {% if type %} : {{type}} {% end %}
      raise ::NotImplementedError.new({% verbatim do %}
        {% @def.try &.name || @caller.try &.first.try &.name || "" %}
      {% end %})
    end
  end

  macro class_abstract_def(name)
    {% if name.is_a?(TypeDeclaration) %}
      {% var_name = name.var.id %}
      {% type = name.type %}
    {% elsif name.is_a?(Assign) %}
      {% var_name = name.target %}
      {% type = nil %}
    {% else %}
      {% var_name = name.id %}
      {% type = nil %}
    {% end %}

    private module ClassMethods__%classmethods
      abstract def {{var_name}} {% if type %} : {{type}} {% end %}
    end
    extend ClassMethods__%classmethods
  end

  # Returns the class of the object if it is not already a class.
  macro to_class(obj)
    {{ obj }}.class unless {{ obj }}.is_a?(::Object.class)
  end
end

require "./patch"
require "./lowlevel/ref"
include Minerals::Patch
include Minerals
