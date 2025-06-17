class ::Object
  include Minerals::IsOf

  @[AlwaysInline]
  def upcase? : ::Bool
    Minerals.upcase? self
  end

  @[AlwaysInline]
  def downcase? : ::Bool
    Minerals.downcase? self
  end

  @[AlwaysInline]
  def to_class : ::Object.class
    Minerals.to_class self
  end

  def extract(&block) : ::Tuple(self, self)
    result = with self yield
    {self, result}
  end

  def do(&)
    with self yield
  end
end
