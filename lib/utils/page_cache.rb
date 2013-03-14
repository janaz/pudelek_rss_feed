require 'digest/sha2'
require 'zlib'
require 'base64'

module Utils
  class PageCache

    include DataMapper::Resource

    property :shakey, String, :length => 64, :key => true
    property :content, Text
    property :created_at, DateTime

    class << self

      def retrieve key
        shakey = sha(key)
        page_cache = PageCache.get(shakey)
        puts page_cache.inspect
        if (page_cache.nil?)
          page_cache = PageCache.create(
            :content => encode(yield),
            :shakey => shakey,
            :created_at => Time.now
          )
          #page_cache.save!
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
        Base64.encode64(deflate(string))
      end

      def decode(string)
        inflate(Base64.decode64(string))
      end

      def sha key
        d = Digest::SHA2.new(256) << key
        d.to_s
      end
    end
  end
end