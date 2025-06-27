module Minerals::Dir
  PATCHES = "::Dir"

  macro included
    def to_path : ::Path
      ::Path.new(self.path)
    end
  end
end
