module Minerals::Late
  macro latedef(&block)
    private module LateDef__%x
      macro included
        {{ block.body }}
      end
    end
    include LateDef__%x
  end
end