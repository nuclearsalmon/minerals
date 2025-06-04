require "levenshtein"

module ::Levenshtein
  def self.bounds(
    string1 : ::String,
    string2 : ::String
  ) : ::Tuple(UInt32, UInt32)
    lower_bound = (string1.size - string2.size).abs
    upper_bound = {string1.size, string2.size}.max

    if string1.size == string2.size
      hamming_distance = string1.chars.zip(string2.chars) \
        .count { |c1, c2| c1 != c2 }
      upper_bound = {upper_bound, hamming_distance}.max
    end

    {lower_bound.to_u32, upper_bound.to_u32}
  end

  def self.similar?(
    string1 : ::String,
    string2 : ::String,
    threshold_percentage : ::Float
  ) : ::Bool
    max_distance = (string1.size * threshold_percentage).to_i
    distance(string1, string2) < max_distance
  end

  def self.similarity(
    string1 : ::String,
    string2 : ::String
  ) : ::Float
    dist = distance(string1, string2)
    _, upper_bound = bounds(string1, string2)

    sim = 1.0 - (dist.to_f / upper_bound.to_f)  # percentage
    sim = [[sim, 0.0].max, 1.0].min               # clamp
    sim
  end
end
