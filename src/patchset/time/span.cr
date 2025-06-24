struct ::Time::Span
  def self.new(
    *,
    seconds : Int = 0,
    nanoseconds : Int64 = 0,
    picoseconds : Int = 0,
    milliseconds : Int = 0,
    microseconds : Int = 0,
    **kwargs
  )
    # add units to nanoseconds
    nanoseconds += (picoseconds * 0.001).to_i64
    nanoseconds += milliseconds * 1000000
    nanoseconds += microseconds * 1000

    # shift over remainder to seconds
    seconds + nanoseconds.tdiv(Time::Span::MAX.nanoseconds)
    nanoseconds = nanoseconds.remainder(Time::Span::MAX.nanoseconds)

    # call default constructor and let it deal with overflow and other stuff
    new(**kwargs, seconds: seconds, nanoseconds: nanoseconds)
  end
end
