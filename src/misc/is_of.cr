module Minerals::IsOf
  private macro recursive_inherited_is_of
    def self.reverse_is_of(reverse_self) : ::Bool
      reverse_self.is_a?({{ @type }})
    end

    def self.is_of(other) : ::Bool
      other_cls.reverse_is_of(self)
    end

    def is_of?(other) : ::Bool
      other_cls.reverse_is_of(self)
    end

    macro inherited
      recursive_inherited_is_of
    end
  end

  macro included
    recursive_inherited_is_of
  end
end
