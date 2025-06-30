require "option_parser"

abstract class Minerals::OptionParser(T) < ::OptionParser
  def self.new(*args, options : T, **kwargs)
    super(*args, **kwargs, &->(parser : self){ parser.build(options) })
  end

  private abstract def build(options : T)
end
