require 'data_mapper'

DataMapper::Logger.new($stdout, :error)
DataMapper.setup(:default, ENV['DATABASE_URL'])

require File.expand_path("../lib/models", File.dirname(__FILE__))
require File.expand_path("../lib/utils", File.dirname(__FILE__))

DataMapper.finalize