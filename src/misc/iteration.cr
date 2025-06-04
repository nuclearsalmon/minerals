module Minerals::Iteration
  extend self

  def select(iter : Iterator, range : Range)
    iter.with_index.select { |_, i| range === i}
  end

  def reject(iter : Iterator, range : Range)
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
