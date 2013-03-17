require 'rspec/core/rake_task'

RSpec::Core::RakeTask.new(:spec)

task :dupa do
  puts "dupa"
end