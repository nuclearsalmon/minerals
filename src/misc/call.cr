module Minerals::Call
  extend self
  PATCHES = ""

  macro mcall(obj, *methods)
    { {% for method, _ in methods[...-1] %} {{ obj }}.{{ method }}, {% end %} {{ obj }}.{{ methods[-1] }} }
  end

  macro mncall(obj, *methods)
    { {% for method, _ in methods[...-1] %} {{ method.id.split('.').first }}: {{ obj }}.{{ method }}, {% end %} {{ methods[-1].id.split('.').first }}: {{ obj }}.{{ methods[-1] }} }
  end

  macro mnget(obj, *members)
    { {% for member, _ in members[...-1] %} {{ member.id.split('.').first }}: {{ obj }}[{{ member.id.stringify }}], {% end %} {{ members[-1].id.split('.').first }}: {{ obj }}[{{ members[-1].id.stringify }}] }
  end
end
