require 'digest/sha2'
require 'zlib'
require 'base64'

module Utils
  class PageCache

    include DataMapper::Resource

    property :cachekey, String, :length => 255, :key => true
    property :content, Text
    property :created_at, DateTime

    class << self

      def retrieve key
        page_cache = PageCache.get(key)
        if (page_cache.nil?)
          page_cache = PageCache.create(
            :content => encode(yield),
            :cachekey => key,
            :created_at => Time.now
          )
        end
        decode(page_cache.content)
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

      def encode(string)
        return nil if string.nil?
        Base64.encode64(deflate(string))
      end

      def decode(string)
        return nil if string.nil?
        inflate(Base64.decode64(string))
      end
    end
  end
end
