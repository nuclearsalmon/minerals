require "minerals/misc/bool"

module Minerals::String
  PATCHES = "::String"

  macro upcase?(obj)
    ((s = {{obj}}.to_s).upcase == s)
  end

  macro downcase?(obj)
    ((s = {{obj}}.to_s).downcase == s)
  end

  macro included
    def upcase? : ::Bool
      Minerals::String.upcase?(self)
    end

    def downcase? : ::Bool
      Minerals::String.downcase?(self)
    end

    def nicebreak(hardbreak_at : ::Int) : ::String
      Minerals::String.nicebreak(self, hardbreak_at)
    end

    def lpad(amount : ::Int, padding : ::String = " ") : ::String
      (padding * amount) + self
    end

    def rpad(amount : ::Int, padding : ::String = " ") : ::String
      self + (padding * amount)
    end

    def pad(*args, **kwargs) : ::String
      self.lpad(*args, **kwargs).rpad(*args, **kwargs)
    end
  end

  def self.nicebreak(str : ::String, hardbreak_at : ::Int) : ::String
    estimated_capacity = str.size + (str.size / hardbreak_at).to_i
    ::String.build(capacity: estimated_capacity) { |result|
      scanner = ::StringScanner.new(str)
      cached_word : ::String? = nil

      loop do
        line = ::String.build { |line|
          loop do
            unless cached_word.nil?
              line << cached_word  # ignore size limit, force append
              cached_word = nil
            end

            word = scanner.scan_until(/[\n ]/)
            last_char : ::Char? = nil
            if word.nil?
              word = scanner.rest
              scanner.terminate
              if word == ""
                break
              else
                last_char = ' '  # fake last char to get the desired behavior
              end
            else
              last_char = word[-1]
            end

            line_size = ::String.new(line.buffer, line.bytesize).size
            case last_char
            when ' '
              if line_size + word.size > hardbreak_at
                cached_word = word
                break
              else
                line << word
              end
            when '\n'
              if line_size + word.size > hardbreak_at
                cached_word = word
              else
                line << word
              end
              break
            else
              raise "Unexpected character: #{last_char.dump} ('#{last_char.unicode_escape}')"
            end
          end
        }

        result << line
        result << '\n' unless line.rstrip(' ').ends_with?('\n')
        break if scanner.eos?
      end

      # ensure cached word is not dropped
      unless cached_word.nil?
        result << cached_word
      else
        result.back('\n'.bytesize)  # efficiently remove last \n
      end
    }
  end
end
