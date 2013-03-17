require 'rspec'

Dir.glob(File.expand_path("../config/*.rb", File.dirname(__FILE__))).each do |file|
  require file
end

Dir.glob(File.expand_path("../app/*.rb", File.dirname(__FILE__))).each do |file|
  require file
end
require File.expand_path("../lib/models", File.dirname(__FILE__))
require File.expand_path("../lib/utils", File.dirname(__FILE__))
