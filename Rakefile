require 'dotenv'
Dotenv.load
require 'rake'
Dir.glob(File.expand_path("tasks/*.rake", File.dirname(__FILE__))).each do |file|
  import file
end
