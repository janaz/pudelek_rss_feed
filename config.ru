require 'dotenv'
Dotenv.load
Dir.glob(File.expand_path("config/*.rb", File.dirname(__FILE__))).each do |file|
  require file
end
Dir.glob(File.expand_path("app/*.rb", File.dirname(__FILE__))).each do |file|
  require file
end
require File.expand_path("lib/utils", File.dirname(__FILE__))


run PudelekRSSFeed::Pudelek.new

