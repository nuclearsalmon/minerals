module Minerals::StaticArray
  private PATCHES = ::StaticArray

  macro from_s(str_lit)
    slice = {{ str_lit }}.to_slice
    StaticArray(LibC::Char, {{ str_lit.size }}).new { |i| slice[i]? || 0u8 }
  end

  macro from_s(str, len)
    slice = {{ str }}.to_slice
    StaticArray(LibC::Char, {{ len }}).new { |i| slice[i]? || 0u8 }
  end

  macro from(slice, len, t, fill)
    StaticArray({{ t }}, {{ len }}).new { |i| slice[i]? || {{ fill }} }
  end

  macro from(slice, len, fill)
    StaticArray(typeof({{ fill }}), {{ len }}).new { |i| slice[i]? || {{ fill }} }
  end
end
