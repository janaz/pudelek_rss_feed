require 'net/http'
require 'nokogiri'
require 'pp'
html = Net::HTTP.get_response(URI.parse('http://www.pudelek.pl/')).body

page = Nokogiri::HTML(html)

page.css('.content .news .entry').map do |entry|
    url = entry.css('.header h3 a').attr('href').value
    html_entry = Net::HTTP.get_response(URI.parse(url)).body
    article_page = Nokogiri::HTML(html_entry)
    content_element = article_page.css('.content .single-entry-text')
    content_element.css('script').remove
 e= {
    :url => url,
    :title => entry.css('.header h3 a').text,
    :date_time => entry.css('.header span.time').text, #dd.mm.yyyy hh:mm,
    :content => content_element.to_html
  }

  puts e
end
