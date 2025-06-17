module Minerals::Patch
  macro patch(patch_target, with_module)
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
    {% if !with_module.is_a?(TypeNode) %}
      {% with_module = parse_type(with_module.stringify).resolve %}
    {% end %}

    {% if with_module.has_constant?(:PATCHES) %}
      {% patch_target = with_module.constant(:PATCHES) %}
      {% if patch_target.is_a?(ASTNode) %}
        {% if patch_target == "" %}
          include {{ with_module.id }}
        {% else %}
          {% patch_target = patch_target.resolve %}

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
        {% end %}
      {% elsif !patch_target.is_a?(TypeNode) %}
        raise "Unknown type of patch target: #{ {{ patch_target}} }."
      {% end %}
    {% else %}
      raise "Module #{ {{with_module}} } does not define a patch target."
    {% end %}
  end
end