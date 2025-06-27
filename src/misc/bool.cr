module Minerals::Bool
  extend self

  def from_s?(
      s : ::String,
      case_sensitive : ::Bool = true,
      truthy : ::Array(::String) = ["true", "True"],
      falsy : ::Array(::String) = ["false", "False"]
    ) : ::Bool?
    if case_sensitive
      truthy.each { |word| return true if word == s }
      falsy.each { |word| return false if word == s }
    else
      s = s.downcase
      return true if truthy.any?(s)
      return false if falsy.any?(s)
    end

    return nil
  end

  def from_s(*args, **kwargs) : ::Bool
    result = s_to_b?(*args, **kwargs)
    if result.nil?
      raise ::Exception::TypeCastError.new("cast from String to Bool failed")
    else
      result
    end
  end
end
