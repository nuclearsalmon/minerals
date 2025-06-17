module Minerals::Ref
  PATCHES = ""

  macro ref(var)
    {pointerof({{ var }}), sizeof(typeof({{ var }}))}
  end

  macro ref(var, type)
    {pointerof({{ var }}).unsafe_as(Pointer({{ type }})), sizeof(typeof({{ var }}))}
  end
end
