module Minerals::Late
  macro latedef(&block)
    private module LateDef%x
      macro included
        {{ block.body }}
      end
    end
    include LateDef%x
  end

  macro class_abstract_def(name)
    {% if name.is_a?(TypeDeclaration) %}
      {% var_name = name.var.id %}
      {% type = name.type %}
    {% else %}
      {% var_name = name.id %}
      {% type = nil %}
    {% end %}

    private module ClassMethods%x
      abstract def {{var_name}} {% if type %} : {{type}} {% end %}
    end
    extend ClassMethods%x
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
end