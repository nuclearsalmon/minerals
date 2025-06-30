require "./minerals"

include Minerals::Patch
patch Minerals
include Minerals::Late  # incl, because this is part of core
