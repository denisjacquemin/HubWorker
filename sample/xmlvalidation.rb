require 'rubygems'
gem 'nokogiri'
require 'nokogiri'
require 'open-uri'
 

#schema = Nokogiri::XML::Schema(File.read(ARGV.pop))
document = Nokogiri::XML(open("http://localhost:3000/properties_20150129190212.xml"))
#errors = schema.validate(document)
#puts errors.inspect
