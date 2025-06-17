# MUTEX = Mutex.new
#
# def write_lines; Defer.scope do
#   MUTEX.lock
#   defer { MUTEX.unlock }
#
#   file = File.open("somefile.txt", "w")
#   defer { file.close }
#
#   10.times do |i|
#     file.write "Line: #{i}"
#   end
#
#   puts "lines written"
# end; end
module Minerals::Defer
  @@indexes = [] of Int32
  @@defers = [] of ->

  @[AlwaysInline]
  def self.defer(&blk : ->)
    @@defers.push blk
  end

  @[AlwaysInline]
  def self.scope
    @@indexes.push @@defers.size
    with Defer yield
  ensure
    index = @@indexes.pop
    while @@defers.size > index
      @@defers.pop.call
    end
  end
end
