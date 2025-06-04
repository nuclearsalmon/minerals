require "./requires"

module Minerals
  extend self

  macro this
    self.class
  end

  macro uppercase?(obj)
    ((s = {{obj}}.to_s).upcase == s)
  end

  macro downcase?(obj)
    ((s = {{obj}}.to_s).downcase == s)
  end

  # Returns the class of the object if it is not already a class.
  macro to_class(obj)
    obj.class unless obj.is_a?(::Object.class)
  end

  macro pvar(stmt)
    puts "{{ stmt }}:\n  #{ {{ stmt }}.pretty_inspect }"
  end

  macro pvar(*stmts)
    {% for stmt, _ in stmts %}
      puts "{{ stmt }}:\n  #{ {{ stmt }}.pretty_inspect }"
    {% end %}
  end

  macro env_exists?(key)
    !(ENV[{{ key }}]?.nil? || Env[{{ key }}]? == "")
  end

  def s_to_b?(
      s : ::String,
      case_sensitive : ::Bool = true,
      truthy : Array(String) = ["true", "True"],
      falsy : Array(String) = ["false", "False"]
    ) : ::Bool?
    if case_sensitive
      truthy.each { |word| return true if word == s }
      falsy.each { |word| return false if word == s }
    else
      s = s.downcase
      return true if truthy.any?(s)
      return false if falsy.any?(s)
    end

    return nil
  end

  def s_to_b(*args, **kwargs) : ::Bool
    result = s_to_b?(*args, **kwargs)
    if result.nil?
      raise ::Exception::TypeCastError.new("cast from String to Bool failed")
    else
      result
    end
  end

  # for use in compile-time expressions
  def env_to_b(key : ::String) : ::Bool
    value = ENV[key]?.try &.downcase || "false"
    return false if value == "false"
    return true if value == "true"
    raise ::TypeCastError.new("cast to Bool failed: #{ENV.[key]? || "false"}")
  end

  def extract(obj, &)
    {obj, with obj yield}
  end

  # Execute a block of code with the given
  # object *obj* as *self*.
  def on(obj, &)
    with obj yield
  end

  macro mcall(obj, *methods)
    { {% for method, _ in methods[...-1] %} {{ obj }}.{{ method }}, {% end %} {{ obj }}.{{ methods[-1] }} }
  end

  macro mncall(obj, *methods)
    { {% for method, _ in methods[...-1] %} {{ method.id.split('.').first }}: {{ obj }}.{{ method }}, {% end %} {{ methods[-1].id.split('.').first }}: {{ obj }}.{{ methods[-1] }} }
  end
end

MINERALS_TOPLEVEL = ENV["MINERALS_TOPLEVEL"] ||= ""
{% if MINERALS_TOPLEVEL != "" %}
include Minerals
{% end %}
