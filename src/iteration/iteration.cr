require "dir_iterator"
require "reverse_index_iterator"

module Minerals::Iteration
  extend self

  def each_file(*args, **kwargs)
    Minerals::DirIterator.new(*args, **kwargs)
  end

  def each_file(*args, **kwargs, &)
    each_file(*args, **kwargs).each { |file| yield file }
  end

  def select(iter : Iterator(T), range : Range) : Iterator(T) forall T
    iter.with_index.select { |_, i| range === i}
  end

  def reject(iter : Iterator(T), range : Range) : Iterator(T) forall T
    iter.with_index.reject { |_, i| range === i}
  end

  def each_line_in(file : File, range : Range)
    Minerals::Iteration.select(file.each_line, range)
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
  # for how each_with_index works.
  def reverse_each_with_index(indexable : Indexable) forall T
    Minerals.on Indexable {
      Minerals::ReverseIndexIterator(self, T).new(self)
    }
  end
end
