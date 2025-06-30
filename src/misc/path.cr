module Minerals::Path
  extend self
  PATCHES = "::Path"

  macro included
    def +(suffix : ::String) : self
      self.parent / (self.basename + suffix)
    end

    def includes?(
      path : (::Path | ::String),
      base : (::Path | ::String) = ::Dir.current
    ) : ::Bool
      parent_path = self.normalize.expand(base: base).to_posix.to_s
      target_path = ::Path.new(path).normalize.expand(base: base).to_posix.to_s
      parent_path.includes?(target_path)
    end
  end

  def normalize_filters(
    filters : ::Iterable(::String)
  ) : Array({::String, ::Bool})
    normalized_filters = Array({::String, ::Bool}).new

    filters.each { |filter|
      filter = filter.strip

      positive = filter.starts_with?("!")
      filter = filter.lchop("!") if positive

      case filter
      when .starts_with?("/")
        filter = filter.lchop("/")
      when .starts_with?("./")
        filter = filter.lchop("./")
      else
        normalized_filters << {"**/#{filter}", positive}
      end

      normalized_filters << {"#{filter}**", positive} if filter.ends_with?("/")
      normalized_filters << {filter, positive}
    }

    normalized_filters.uniq
  end
end
