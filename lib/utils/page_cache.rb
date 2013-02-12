require 'digest/sha2'
require 'zlib'

module Utils
  class PageCache
    CACHE_ROOT = File.expand_path('../../cache', File.dirname(__FILE__))
    class << self

      def retrieve key
        cache_file = File.join(CACHE_ROOT, sha(key))
        if !File.exist?(cache_file)
          data = yield
          File.open(cache_file, "w") { |f| f << deflate(data) } if data
          data
        else
          inflate(File.read(cache_file))
        end
      end


      private
      def deflate(string, level = Zlib::DEFAULT_COMPRESSION)
        z = Zlib::Deflate.new(level)
        dst = z.deflate(string, Zlib::FINISH)
        z.close
        dst
      end

      def inflate(string)
        zstream = Zlib::Inflate.new
        buf = zstream.inflate(string)
        zstream.finish
        zstream.close
        buf
      end

      def sha key
        d = Digest::SHA2.new(256) << key
        d.to_s
      end
    end
  end
end