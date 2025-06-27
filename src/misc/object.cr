module Minerals::Object
  PATCHES = "::Object"

  macro included
    def extract(&block) : ::Tuple(self, self)
      {self, with self yield}
    end

    def do(&)
      with self yield
    end

    @[AlwaysInline]
    def to_class : ::Object.class
      Minerals.to_class self
    end
  end
end
