require 'nokogiri'
require 'net/http'
require 'date'

module PudelekRSSFeed
  class PudelekMainPage
    URL = 'http://www.pudelek.pl/'

    def url
      URL
    end

    def all
      articles + photo_stories
    end

    def articles
      page.css('.content .news .entry').map { |entry| create_article(entry) }
    end

    def photo_stories
      page.css('.photo-main ul li a').map { |entry| create_photo_story(entry) }
    end

    private

    def create_photo_story entry
      url = entry.attr('href')
      title = entry.css('h4').text
      PudelekArticle.from_params(:url => url, :title => title)
    end


    def create_article entry
      url = entry.css('.header h3 a').attr('href')
      title = entry.css('.header h3 a').text
      date_time = entry.css('.header span.time').text #dd.mm.yyyy hh:mm,
      time = DateTime.strptime("#{date_time} CET", '%d.%m.%Y %H:%M %Z').to_time rescue nil
      PudelekArticle.from_params(:url => url, :title => title, :time => time)
    end

    def page
      @page ||= Nokogiri::HTML(fetch)
    end

    def fetch
      @html ||= Net::HTTP.get_response(URI.parse(url)).body
    end

  end
end