module Minerals::Char
  PATCHES = "::Char"

  macro included
    @[AlwaysInline]
    def downcase? : Bool
      !uppercase?
    end
  end
end
