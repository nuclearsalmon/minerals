module Minerals
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
end
