require "option_parser"

abstract class Minerals::MonoOptionParser < ::OptionParser
  def self.new
    super(&->build(self))
  end

  private abstract def build

  private def self.build(parser : self) : ::Nil
    Minerals.on(parser){ build }
  end
end
