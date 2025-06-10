require "option_parser"

abstract class Minerals::OptionParser(T) < ::OptionParser
  def self.new(*args, options : T, **kwargs)
    super(*args, **kwargs, &->(parser : self){ build(parser, options) })
  end

  private abstract def build(options : T)

  private def self.build(parser : self, options : T) : ::Nil
    Minerals.on(parser){ build(options) }
  end
end
