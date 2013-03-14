Dir.glob(File.expand_path("utils/*.rb", File.dirname(__FILE__))).each do |file|
  require file
end