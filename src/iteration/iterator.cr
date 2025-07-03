module Minerals::Iterator
  PATCHES = "::Iterator"

  macro included
    @[AlwaysInline]
    def select_range(range : Range)
      self.with_index.select { |_, i| range === i }.map { |e, _| e }
    end

    @[AlwaysInline]
    def reject_range(range : Range)
      self.with_index.reject { |_, i| range === i }.map { |e, _| e }
    end

    def with_self(&)
      with_object(self) { |args, iter|
        yield *{*args, iter}
      }
    end

    def with_self
      with_object(self).map { |args, iter|
        {*args, iter}
      }
    end

    @[AlwaysInline]
    def skip!(n : Int)
      n.times { self.next }
    end

    @[AlwaysInline]
    def next? : T? forall T
      (x = self.next).is_a?(::Iterator::Stop) ? nil : x.as(T)
    end
  end
end
