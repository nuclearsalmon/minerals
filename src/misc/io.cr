module Minerals::IO
  extend self

  def each_line_in(file : File, range : Range)
    Minerals::Iteration.select(file.each_line, range)
  end

  class DirIterator
    include Iterator(Path)

    @dir_path : String
    @root_path : String
    @iter : Iterator(String)
    @dir_queue = Array(String).new

    def initialize(
      dir_path : Path | String,
      @allow_symlinks : Bool = true
    )
      @dir_path = dir_path.is_a?(String) ? dir_path : dir_path.to_s

      if !File.directory?(@dir_path)
        raise ArgumentError.new("#{@dir_path} is not a directory")
      end

      @root_path = Path.new(File.realpath(@dir_path)).to_posix.to_s
      @iter = Dir.new(@dir_path).each_child
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
            @iter = Dir.new(@dir_path).each_child
          end
        else
          elem = (Path.new(@dir_path) / elem).to_s

          skip = false
          if @allow_symlinks && File.symlink?(elem)
            elem = File.realpath(elem)

            if Path.new(elem).to_posix.to_s.includes?(@root_path)
              skip = true
            end
          end

          unless skip
            if File.directory?(elem)
              @dir_queue << elem
            elsif File.file?(elem)
              break Path.new(elem)
            end
          end
        end
      end
    end
  end

  def each_file(path : Path | String, allow_symlinks : Bool = true)
    DirIterator.new(path, allow_symlinks)
  end

  def each_file(*args, **kwargs, &)
    each_file(*args, **kwargs).each { |file| yield file }
  end
end
