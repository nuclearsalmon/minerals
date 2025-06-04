require "./version"

require "./modules/*"
require "./misc/*"

MINERALS_PATCH = ENV["MINERALS_PATCH"] ||= ""
{% if MINERALS_PATCH != "" %}
  require "./patches/*"
  include Minerals
{% end %}
