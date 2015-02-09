require 'open-uri'
require 'nokogiri'
require 'net/http'


# FTP_HOST configured in hud.iron.io dashboard
# agent_id, entity_type and file_name from payload
path_to_xml = config['FTP_HOST'] + params['agent_id'] + '/' + params['entity_type'] + '/' + params['file_name']

#path_to_xml = 'http://hubworker.herokuapp.com/immo356/properties/properties_20150129190212.xml'

path_to_xsd = 'xsd/' + params['entity_type'] + '.xsd' # 

schema = Nokogiri::XML::Schema(File.read(path_to_xsd))
document = Nokogiri::XML(open(path_to_xml)) # build

errors = schema.validate(document).collect { |error|
  error.to_s
}

if errors.empty? {
  # no errors call webhook /savedata
  uri = URI.parse(config['HOOKS_BASE_URI'] + 'savedata'),
  params = { :agent_id => params['agent_id'], :entity_type => params['entity_type'], :file_name => params['file_name']}
  uri.query = URI.encode_www_form( params )
  Net::HTTP.get(uri)
}

unless errors.empty? {
  # save errors to 
}
  