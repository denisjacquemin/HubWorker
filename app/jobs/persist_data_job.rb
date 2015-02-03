class PersistDataJob < ActiveJob::Base
  queue_as :persist_data_q

  def perform(xmlfilename)
    Delayed::Worker.logger.debug("PersistDataJob###### param: #{xmlfilename}")
    
    base_uri = ENV['FIREBASE_URL']
    Delayed::Worker.logger.debug("PersistDataJob###### param: #{ENV['FIREBASE_URL']}")
    firebase = Firebase::Client.new(base_uri)

    document = Nokogiri::XML(open(xmlfilename))
    properties = document.css("property")
    properties.each { |property|
      payload = build_property_payload(property)
      firebase.push("properties", payload)
      Delayed::Worker.logger.debug("PersistDataJob###### payload: #{payload}")
    }
  end

  private
  
  def build_property_payload(property)
    Jbuilder.encode do |json|
      json.title(property.css("title").text)
      json.description(property.css("description").text)
      json.price(property.css("price").text)
      json.address(property.css("address").text)
      json.bedroom(property.css("bedroom").text)
      json.url(property.css("url").text)
    end
  end
end
