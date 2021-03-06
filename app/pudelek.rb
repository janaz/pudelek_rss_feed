require 'sinatra/base'
require 'nokogiri'

module PudelekRSSFeed
  class Pudelek < Sinatra::Base

    RSS_ENTRIES = 50

    get '/' do
      content_type 'application/atom+xml', :charset => 'utf-8'
      rss
    end

    get '/healthcheck' do
      content_type 'text/plain', :charset => 'utf-8'
      <<-EOF
Cache Size = #{Utils::PageCache.count}
Old records = #{Utils::PageCache.all(:created_at.lt => (Time.now - 24*3600*90)).count}
RACK_ENV = #{ENV['RACK_ENV']}
      EOF
    end

    get '/delete_cache' do
      content_type 'text/plain', :charset => 'utf-8'
      Utils::PageCache.all(:created_at.lt => (Time.now - 24*3600*90)).destroy
      'ok'
    end

    private

    def articles
      PudelekRSSFeed::PudelekMainPage.new.all.sort.reverse[0..(RSS_ENTRIES-1)]
    end

    def rss
      builder = Nokogiri::XML::Builder.new do |xml|
        xml.feed(:xmlns => "http://www.w3.org/2005/Atom") {
          xml.link(:href => "http://www.pudelek.pl/", :rel => 'self')
          xml.title 'Pudelek by Janaz'
          xml.id "http://www.pudelek.pl/"
          xml.updated Time.now.to_rfc3339
          articles.each do |e|
            xml.entry {
              xml.title  e.title
              xml.link(:type => "text/html", :rel => "alternate", :href => e.url)
              xml.id e.article_id
              xml.updated e.time.to_rfc3339
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
