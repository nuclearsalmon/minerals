module Minerals
  struct TriState
    @states : ::Tuple(::Symbol, ::Symbol, ::Symbol)
    property state : ::Bool?

    private macro raw_states
      {false, nil, true}
    end

    def initialize(
      state1 : ::Symbol,
      state2 : ::Symbol,
      state3 : ::Symbol,
      default : ::Symbol? = nil
    )
      @states = {state1, state2, state3}
      @state = default.nil? ? nil : state(default)
    end

    def self.new_(*args, **kwargs) : self
      {{@type}}.new(*args, **kwargs)
    end

    macro new(state1, state2, state3, default_state = nil)
      begin
        state1 = :{{ state1.id.stringify.camelcase(lower: true).id }}
        state2 = :{{ state2.id.stringify.camelcase(lower: true).id }}
        state3 = :{{ state3.id.stringify.camelcase(lower: true).id }}
        default_state = {{ default_state.nil? }} ? nil : :{{ default_state.id.stringify.camelcase(lower: true).id}}

        TriState.new_(state1, state2, state3, default_state)
      end
    end

    macro method_missing(call)
      def {{ call.name }} : ::Bool?
        {% if call.name.stringify.ends_with?("?") %}
          sym = @states[raw_states.index!(@state)]
          other_sym = {{ call.name.tr("?", "").symbolize }}
          sym == other_sym
        {% elsif call.name.stringify.ends_with?("!") %}
          @state = state({{ call.name.tr("!", "").symbolize }})
        {% else %}
          state({{ call.name.symbolize }})
        {% end %}
      end
    end

    private def self.to_i(state : ::Bool?) : ::Int8
      case state
      in false; -1;
      in nil; 0;
      in true; 1;
      end
    end

    def to_i : ::Int8
      self.class.to_i(@state)
    end

    def to_sym : ::Symbol
      @states[raw_states.index[@state]]
    end

    def to_b : ::Bool
      @state
    end

    def to_s : ::String
      to_sym.to_s
    end

    def state(state : ::Symbol) : ::Bool?
      raw_states[@states.index!(state)]
    end

    def [](state : ::Symbol) : ::Bool?
      raw_states[@states.index!(state)]
    end

    def []?(state : ::Symbol) : ::Bool?
      raw_states[@states.index?(state)]
    end

    def [](state : ::Bool?) : ::Symbol
      @states[raw_states.index!(state)]
    end

    def []?(state : ::Bool?) : ::Symbol?
      raw_states.index?(state).try { |i| @states[i] }
    end

    def flip : ::Bool?
      @state.try { |x| !x }
    end

    def flip! : ::Bool?
      @state.try { |x| @state = !x }
    end

    def try_flip(&) : ::Bool?
      @state.try { |x|
        yield
        !x
      }
    end

    def try_flip!(&)
      @state.try { |x|
        yield
        @state = !x
      }
    end

    def try(state : ::Bool?, &)
      yield if @state == state
    end

    def try!(state : ::Bool?, &)
      with self yield if @state == state
    end

    def <=>(other : ::Bool?)
      case {@state, other}
      in {false, false}, {true, true}, {nil, nil}
        0
      in {false, nil}, {false, true}, {nil, true}
        -1
      in {nil, false}, {true, false}, {true, nil}
        1
      end
    end

    def <=>(other : self)
      self <=> other.state
    end

    def <=>(other : ::Int8)
      other = {-1, {other, 1}.min}.max  # clamp
      other_b : ::Bool? = raw_states[other]
      self <=> other_b
    end
  end
end
