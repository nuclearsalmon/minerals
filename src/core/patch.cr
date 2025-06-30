module Minerals::Patch
  macro patch(patch_target, with_module)
    {% puts "Patching '#{patch_target.id}' with '#{with_module.id}'" %}

    {% if patch_target.struct? %}
      struct {{ patch_target.id }}
        include {{ with_module.id }}
      end
    {% elsif patch_target.class? %}
      class {{ patch_target.id }}
        include {{ with_module.id }}
      end
    {% elsif patch_target.module? %}
      module {{ patch_target.id }}
        include {{ with_module.id }}
      end
    {% else %}
      raise "Unknown type: #{ {{target_t}} }"
    {% end %}
  end

  macro patch(with_module)
    {% if with_module.is_a?(SymbolLiteral) %}
      {% with_module = with_module.id.stringify %}
    {% end %}

    {% if with_module.is_a?(StringLiteral) %}
      {% module_path_parts = with_module.split("/") %}
      {% patch_target = \
        (module_path_parts[0].titleize + \
        "::" + \
        module_path_parts[-1].titleize).id %}

      require {{ with_module }}
      patch {{ patch_target }}
    {% elsif with_module.is_a?(Path) %}
      {% with_module = parse_type(with_module.stringify).resolve %}

      {% if with_module.has_constant?(:PATCHES) %}
        {% patch_target = with_module.constant(:PATCHES) %}
        {% if patch_target.is_a?(ASTNode) %}
          {% if patch_target == "" || patch_target == "::" %}
            {% puts "Patching '::' with '#{with_module.id}'" %}

            include {{ with_module.id }}
          {% else %}
            {% patch_target = parse_type(patch_target).resolve %}

            {% puts "Patching '#{patch_target.id}' with '#{with_module.id}'" %}

            {% if patch_target.struct? %}
              struct {{ patch_target.id }}
                include {{ with_module.id }}
              end
            {% elsif patch_target.class? %}
              class {{ patch_target.id }}
                include {{ with_module.id }}
              end
            {% elsif patch_target.module? %}
              module {{ patch_target.id }}
                include {{ with_module.id }}
              end
            {% else %}
              raise "Unknown type: #{ {{ target_t }} }"
            {% end %}
          {% end %}
        {% else %}
          raise "Unknown type of patch target: #{ {{ patch_target}} }."
        {% end %}
      {% else %}
        raise "Module #{ {{ with_module }} } does not define a patch target."
      {% end %}
    {% end %}
  end
end