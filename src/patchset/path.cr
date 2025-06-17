module Minerals
  struct ::Path
    def +(suffix : String) : self
      self.parent / (self.basename + suffix)
    end

    def includes?(
      path : Path | String,
      base : (Path | String) = Dir.current
    ) : ::Bool
      parent_path = self.normalize.expand(base: base).to_posix.to_s
      target_path = Path.new(path).normalize.expand(base: base).to_posix.to_s
      parent_path.includes?(target_path)
    end
  end
end