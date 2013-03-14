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
      time_str = Utils::PageCache.retrieve("#{url}-time") do
        el = page.css('.content .time')
        if el.first
          time_str = el.attr('datetime')
        end
      end
      DateTime.strptime("#{time_str} CET", '%Y-%m-%d %Z').to_time rescue nil
    end

    def content
      Utils::PageCache.retrieve("#{url}-content") do
        el = if video?
               page.css('.single-article .single-article-text')
             else
               page.css('.content .single-entry-text')
             end
        el.css('script').remove
        el.to_html
      end
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
      @html ||= Net::HTTP.get_response(URI.parse(url)).body
    end
  end
end