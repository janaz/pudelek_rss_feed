require 'sinatra/base'
require 'nokogiri'

module PudelekRSSFeed
  class Pudelek < Sinatra::Base

    RSS_ENTRIES = 120

    get '/' do
      content_type 'application/atom+xml', :charset => 'utf-8'
      rss
    end

    get '/healthcheck' do
      content_type 'text/plain', :charset => 'utf-8'
      <<-EOF
Cache Size = #{Utils::PageCache.count}
      EOF
    end

    private

    def to_rfc3339 time
      base = time.strftime('%Y-%m-%dT%H:%M:%S')
      tz = time.strftime('%z')
      tz_rfc = "#{tz[0..2]}:#{tz[3..4]}"
      "#{base}#{tz_rfc}"
    end

    def articles
      PudelekRSSFeed::PudelekMainPage.new.all.sort.reverse[0..(RSS_ENTRIES-1)]
    end

    def rss
      builder = Nokogiri::XML::Builder.new do |xml|
        xml.feed(:xmlns => "http://www.w3.org/2005/Atom") {
          xml.link(:href => "http://www.pudelek.pl/", :rel => 'self')
          xml.title 'Pudelek by Janaz'
          xml.id "http://www.pudelek.pl/"
          xml.updated to_rfc3339(Time.now)
          articles.each do |e|
            xml.entry {
              xml.title  e.title
              xml.link(:type => "text/html", :rel => "alternate", :href => e.url)
              xml.id e.article_id
              xml.updated to_rfc3339(e.time)
              xml.content e.content, :type => 'html'
              xml.author {
                xml.name 'pudelek.pl'
              }
            }
          end
        }
      end
      builder.to_xml
    end
  end
end
