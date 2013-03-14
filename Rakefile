require 'dotenv'
Dotenv.load
require 'rake'
Dir.glob(File.expand_path("config/*.rb", File.dirname(__FILE__))).each do |file|
  require file
end

Dir.glob(File.expand_path("tasks/*.rb", File.dirname(__FILE__))).each do |file|
  require file
end
