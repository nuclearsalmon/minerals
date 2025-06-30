require "../misc/path"

module Minerals
  class DirIterator
    include ::Iterator(::Path)

    @dir_path : ::String
    @root_path : ::String
    @iter : ::Iterator(::String)
    @dir_queue = ::Array(::String).new
    @normalized_filters : ::Array({::String, ::Bool})

    def initialize(
      dir_path : ::Path | ::String,
      @allow_symlinks : ::Bool = true,
      filters : ::Array(::String) = [] of ::String
    )
      @dir_path = dir_path.is_a?(::String) ? dir_path : dir_path.to_s

      if !::File.directory?(@dir_path)
        raise ArgumentError.new("#{@dir_path} is not a directory")
      end

      @root_path = ::Path.new(::File.realpath(@dir_path)).to_posix.to_s
      @iter = ::Dir.new(@dir_path).each_child
      {"./", ".", ""}.each { |x| filters.reject!(x) }
      @normalized_filters = Minerals::Path.normalize_filters(filters)
    end

    def self.new(
      dir_paths : ::Iterable(::Path | ::String),
      allow_symlinks : ::Bool = true,
      filters : ::Array(::String) = [] of ::String
    )
      dir_paths.compact_map {|dir_path|
        if ::File.directory?(dir_path)
          new(dir_path, allow_symlinks: allow_symlinks, filters: filters)
        elsif !self.filter?(filters, dir_path.to_s)
          ::Path.new(dir_path)
        end
      }.flatten
    end

    protected def self.filter?(
      filters : ::Array({::String, ::Bool}),
      elem : ::String
    ) : ::Bool
      filters.each { |filter, positive|
        res = ::File.match?(filter, elem)
        return !positive if res
      }
      return false
    end

    protected def filter?(elem : ::String) : ::Bool
      self.class.filter?(@normalized_filters, elem)
    end

    def next : ::Path | ::Iterator::Stop
      loop do
        elem = @iter.next
        if elem.is_a?(::Iterator::Stop)
          dir_path = @dir_queue.shift?
          if dir_path.nil?
            break stop
          else
            @dir_path = dir_path
            @iter = ::Dir.new(@dir_path).each_child
          end
        else
          elem_p = ::Path.new(@dir_path) / elem
          elem = elem_p.normalize.to_posix.to_s

          skip = false
          if @allow_symlinks && ::File.symlink?(elem)
            elem = ::File.realpath(elem)
            # avoid recursive symlinks
            if ::Path.new(elem).to_posix.to_s.includes?(@root_path)
              skip = true
            end
          end
          skip = self.filter?(elem) unless skip

          unless skip
            if ::File.directory?(elem)
              @dir_queue << elem
            elsif ::File.file?(elem)
              break ::Path.new(elem)
            end
          end
        end
      end
    end
  end
end
