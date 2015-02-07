class PersistPropertiesJob < ActiveJob::Base
  queue_as :persist_properties_q

  #Delayed::Worker.logger.debug("PersistDataJob###### param: #{ENV['FIREBASE_URL']}")
  def perform(path_to_file, agent_id)    
    base_uri = ENV['FIREBASE_URL']
    firebase = Firebase::Client.new(base_uri)

    document = Nokogiri::XML(open(path_to_file))
    doc_list = document.css("property")
    doc_list.each { |doc|
      payload = build_property_payload(doc, agent_id)
      firebase.push("properties", payload)
    }
  end

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
end
