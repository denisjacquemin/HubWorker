require 'firebase'

firebase = Firebase::Client.new( params['FIREBASE_URL'] )

path_to_xml = params['FTP_HOST'] + params['agent_id'] + '/' + params['entity_type'] + '/' + params['file_name']
document = Nokogiri::XML(open( path_to_xml ))

doc_list = document.css("property")
doc_list.each { |doc|
  payload = build_property_payload(doc, agent_id)
  firebase.push("properties", payload)
}

private

def build_property_payload(property, agent_id)
  Jbuilder.encode do |json|
    json.agentid(agent_id)
    json.refagent(property.css("refagent").text)
    json.title(property.css("title").text)
    json.description(property.css("description").text)
    json.price(property.css("price").text)
    json.address(property.css("address").text)
    json.bedroom(property.css("bedroom").text)
    json.url(property.css("url").text)
  end
end