module Minerals::Concurrency
  extend self
  
  def async(&block)
    p "1"
    channel = Channel(Nil).new
    spawn do
      p "2"
      block.call()
      p "3"
      channel.send(nil)
      p "4"
    end
    p "5"
    channel.receive
    p "6"
  end
end
