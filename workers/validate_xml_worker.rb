require 'open-uri'
require 'nokogiri'

# FTP_HOST configured in hud.iron.io dashboard
# agent_id, entity_type and file_name from payload
url_to_file = URI.join(params['FTP_HOST'], params['agent_id'], params['entity_type'], params['file_name'])

xsd_name = params['entity_type'] + '.xsd'

schema = Nokogiri::XML::Schema(File.read(File.join(Rails.root, 'app', 'xsd', xsd_name )))
document = Nokogiri::XML(open(url_to_file)) # build

errors = schema.validate(document).collect { |error|
  error.to_s
}
