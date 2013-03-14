require 'dm-migrations'
task :auto_migrate do
  DataMapper.auto_migrate!
end
