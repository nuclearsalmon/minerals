module Minerals::ANSI
  extend self

  # Wraps the given String in ANSI and C0 codes to produce
  # an underline effect.
  #
  # NOTE: Hack - utilizing ETX (`\x03`) to force ANSI
  #        underline-CSI to apply across whitespace.
  #
  #        Starting the sequence with STX (`\x02`), to
  #        hopefully mitigate potential side effects of
  #        misusing C0 codes in this way.
  #
  #        This might be doable with Unicode, but doing it
  #        in this way lets us stay within ASCII range
  #        (regardless of character set), which is good.
  #
  #        One should not assume Unicode support.
  #        Testing for it can be done through some
  #        variation of
  #        `"\e[s\e[?1049h\e[2J\e1;1HΔΩÔ\e[6n", read, "\e[2J[?1049l\e[u"`,
  #        where if DSR doesn't report the column position
  #        as `3` it means the terminal interpreted the
  #        payload `ΔΩÔ`
  #        as more than three characters and Unicode is
  #        thus not supported.
  def terminal_underline(str : String) : String
    "\e[4m\x02" + str + "\x03\e[24m"
  end

  def bold(str : String) : String
    "\e[1m" + str + "\e[22m"
  end

  def invert(str : String) : String
    "\e[7m" + str + "\e[27m"
  end
end
