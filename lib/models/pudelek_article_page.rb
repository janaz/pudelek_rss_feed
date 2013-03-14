require 'nokogiri'
require 'net/http'
require 'date'

module PudelekRSSFeed
  class PudelekArticlePage

    class << self

      protected :new

      def from_url(url)
        self.new(url)
      end
    end

    attr_reader :url

    def initialize url
      @url = url
    end

    def time
      el = page.css('.content .time')
      if el.first
        time_str = el.attr('datetime')
        DateTime.strptime("#{time_str} CET", '%Y-%m-%d %Z').to_time rescue nil
      end
    end

    def content
      el = if video?
             page.css('.single-article .single-article-text')
           else
             page.css('.content .single-entry-text')
           end
      el.css('script').remove
      el.to_html
    end

    def video?
      url =~ /pudelek.tv\/video\//
    end

    def article_id
      url
    end

    private

    def page
      @page ||= Nokogiri::HTML(fetch)
    end

    def fetch
      @html ||= Utils::PageCache.retrieve(url) do
        Net::HTTP.get_response(URI.parse(url)).body
      end
    end
  end
end