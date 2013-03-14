Dir.glob(File.expand_path("models/*.rb", File.dirname(__FILE__))).each do |file|
  require file
end