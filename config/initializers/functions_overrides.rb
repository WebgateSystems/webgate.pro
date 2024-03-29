require 'uri'

module URI
  class << self
    def escape(str)
      alpha = 'a-zA-Z'
      alnum = "#{alpha}\\d"
      unreserved = "\\-_.!~*'()#{alnum}"
      reserved = ';/?:@&=+$,\\[\\]'
      unsafe = Regexp.new("[^#{unreserved}#{reserved}]")
      str.gsub(unsafe) do
        us = ::Regexp.last_match(0)
        tmp = ''
        us.each_byte do |uc|
          tmp << format('%%%02X', uc)
        end
        tmp
      end.force_encoding(Encoding::US_ASCII)
    end
  end
end
