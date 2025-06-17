module Minerals::Lib
  PATCHES = ""

  macro include_lib_consts(from = LibC)
    {% for member in from.resolve.constants %}
      {{ member }} = {{ from.id }}::{{ member }}
    {% end %}
  end

  macro include_lib_const(name, from = LibC)
    {{ name.id }} = {{ from.id }}::{{ name.id }}
  end

  macro wrap_c_struct(name, from_lib = LibC)
    {% c_struct = parse_type("#{from_lib.id}::#{name.id}").resolve %}

    @[Extern]
    struct {{ name }}
      @%c_struct : {{ c_struct }}

      macro method_missing(call)
        @%c_struct.\{{ call }}
      end

      # set as private just for readability - it becomes
      # private no matter what you set it as
      private def initialize(c_struct : {{ c_struct }}) : Nil
        @%c_struct = c_struct
      end

      # required as the initialize method becomes private
      # no matter what you set it as
      def public_initialize(c_struct : {{ c_struct }}) : Nil
        initialize(c_struct)
      end

      # macro to splat out kwargs to allow for namedarguments-style
      # initialization of c struct, which is not possible during
      # runtime and thus has to be a macro
      macro new(**kwargs)
        c_struct = ({{ c_struct }}.new \{{ kwargs.double_splat }})
        instance = \{{ @type }}.allocate
        instance.public_initialize(c_struct)
        instance
      end

      def to_unsafe
        @%c_struct
      end

      def to_slice : Slice(UInt8)
        mem = IO::Memory.new(sizeof({{ from_lib.id }}::{{ name.id }}))
        \{% for member in {{ from_lib.id }}::{{ name.id }}.instance_vars %}
          slice = @{{ name.id.stringify.downcase.id }} \
            .\{{ member.name.id }} \
            #.unsafe_as(Slice(UInt8))
          mem.write_bytes(slice)
        \{% end %}
        mem.to_slice
      end

      def to_io(io : IO, format : IO::ByteFormat)
        to_slice.each{ |e| format.encode(e, io) }
      end
    end
  end
end