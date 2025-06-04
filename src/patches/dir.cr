class ::Dir
  def to_path : Path
    Path.new(self.path)
  end
end
