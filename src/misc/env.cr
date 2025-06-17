module Minerals::Env
  extend self
  PATCHES = ""

  macro env_exists?(key)
    !(ENV[{{ key }}]?.nil? || Env[{{ key }}]? == "")
  end

  # for use in compile-time expressions
  def env_to_b(key : ::String) : ::Bool
    value = ENV[key]?.try &.downcase || "false"
    return false if value == "false"
    return true if value == "true"
    raise ::TypeCastError.new("cast to Bool failed: #{ENV.[key]? || "false"}")
  end
end
