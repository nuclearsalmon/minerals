module Minerals::String
  PATCHES = "::String"

  macro uppercase?(obj)
    ((s = {{obj}}.to_s).upcase == s)
  end

  macro downcase?(obj)
    ((s = {{obj}}.to_s).downcase == s)
  end
end
