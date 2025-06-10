module Minerals::Iteration(T)
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
    @exclude : Array(String)

    def initialize(
      dir_path : Path | String,
      @allow_symlinks : Bool = true,
      @exclude : Array(String) = [] of String
    )
      @dir_path = dir_path.is_a?(String) ? dir_path : dir_path.to_s

      if !File.directory?(@dir_path)
        raise ArgumentError.new("#{@dir_path} is not a directory")
      end

      @root_path = Path.new(File.realpath(@dir_path)).to_posix.to_s
      @iter = Dir.new(@dir_path).each_child
      @exclude.reject!(".").reject!("")
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
          elem_p = Path.new(@dir_path) / elem
          elem = elem_p.to_posix.to_s

          skip = false
          if @allow_symlinks && File.symlink?(elem)
            elem = File.realpath(elem)
            if Path.new(elem).to_posix.to_s.includes?(@root_path)
              skip = true
            end
          end

          unless skip
            @exclude.each { |excl|
              excl = excl.strip
              next if excl.starts_with?("!")

              if excl.starts_with?("/")
                excl = ".#{excl}"
              else
                excl = "**/#{excl}"
              end
              excl = ("#{excl}**") if excl.ends_with?("/")

              #puts "#{excl}: #{elem} = #{File.match?(excl, elem)}"
              if File.match?(excl, elem)
                skip = true
                break
              end
            }
          end

          if skip
            @exclude.each { |excl|
              excl = excl.strip
              next unless excl.starts_with?("!")

              excl = excl.lchop("!")
              if excl.starts_with?("/")
                excl = ".#{excl}"
              else
                excl = "**/#{excl}"
              end
              excl = "#{excl}**" if excl.ends_with?("/")

              if File.match?(excl, elem)
                skip = false
                break
              end
            }
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

  def each_file(*args, **kwargs)
    DirIterator.new(*args, **kwargs)
  end

  def each_file(*args, **kwargs, &)
    each_file(*args, **kwargs).each { |file| yield file }
  end

  def select(iter : Iterator(T), range : Range) : Iterator(T)
    iter.with_index.select { |_, i| range === i}
  end

  def reject(iter : Iterator(T), range : Range) : Iterator(T)
    iter.with_index.reject { |_, i| range === i}
  end

  # A potentially more efficient version of
  # `indexable.reverse.each_with_index`.
  #
  # Reverse engineered from the Crystal source code
  # for how each_with_index works.
  def reverse_each_with_index(indexable : Indexable, &)
    on indexable {
      (size - 1).downto(0) { |i|
        tuple = {unsafe_fetch(i), i}
        yield tuple
      }
    }
  end

  # A potentially more efficient version of
  # `indexable.reverse.each_with_index`.
  #
  # Reverse engineered from the Crystal source code
  # for how IndexIterator works.
  class ReverseIndexIterator(A, T)
    include Iterator(T)

    def initialize(@array : A, @index : Int32 = array.size - 1)
    end

    def next
      if @index < 0
        stop
      else
        index = @index
        value = @array[index]
        @index -= 1
        {value, index}
      end
    end
  end

  # A potentially more efficient version of
  # `indexable.reverse.each_with_index`.
  #
  # Reverse engineered from the Crystal source code
  # for how each_with_index works.
  def reverse_each_with_index(indexable : Indexable)
    on Indexable {
      ReverseIndexIterator(self, T).new(self)
    }
  end
end
