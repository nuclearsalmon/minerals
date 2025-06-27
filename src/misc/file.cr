module Minerals::File
  PATCHES = "::File"

  macro included
    def to_path : ::Path
      ::Path.new(self.path)
    end

    def each_line_in(
      range : ::Range,
      chomp : ::Bool = true,
      *args
    ) : ::Iterator(::String)
      each_line(*args, chomp: chomp).select_range(range)
    end

    def each_line_in(
      range : ::Range,
      chomp : ::Bool = true,
      *args,
      &
    ) : ::Iterator(::String)
      each_line(*args, chomp: chomp).select_range(range).each { yield }
    end

    def read_lines_in(
      range : Range,
      chomp : Bool = true,
      *args
    ) : ::Array(::String)
      iter = each_line_in(range, chomp, *args)
      [*iter]
    end
  end
end
