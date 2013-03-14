require 'sinatra/base'
require 'nokogiri'

module PudelekRSSFeed
  class Pudelek < Sinatra::Base
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

    def rss
      builder = Nokogiri::XML::Builder.new do |xml|
        xml.feed(:xmlns => "http://www.w3.org/2005/Atom") {
          xml.link(:href => "http://janaz.pl/", :rel => 'self')
          xml.title 'Pudelek by Janaz'
          xml.id "http://janaz.pl/"
          xml.updated Time.now.strftime('%Y-%m-%dT%H:%M:%S%z')
          PudelekRSSFeed::PudelekMainPage.new.all.each do |e|
            xml.entry {
              xml.title  e.title
              xml.link(:type => "text/html", :rel => "alternate", :href => e.url)
              xml.id e.article_id
              xml.updated e.time.strftime('%Y-%m-%dT%H:%M:%S%z')
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
