class ::String
  include Minerals::String

  def to_b(*args, **kwargs) : ::Bool
    Minerals.s_to_b(self, *args, **kwargs)
  end

  def to_b?(*args, **kwargs) : ::Bool
    Minerals.s_to_b?(self, *args, **kwargs)
  end

  def lpad(amount : Int, padding : String = " ") : self
    (padding * amount) + self
  end

  def rpad(amount : Int, padding : String = " ") : self
    self + (padding * amount)
  end

  def pad(*args, **kwargs) : self
    self.lpad(*args, **kwargs).rpad(*args, **kwargs)
  end
end
