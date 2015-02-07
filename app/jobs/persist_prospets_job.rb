class PersistProspetsJob < ActiveJob::Base
  queue_as :persist_prospets_q

  #Delayed::Worker.logger.debug("PersistDataJob###### param: #{ENV['FIREBASE_URL']}")
  def perform(file_name, user_id)
    
    path_to_file = ENV['FTP_HOST'] + user_id + '/' + file_name
        
    base_uri = ENV['FIREBASE_URL']
    firebase = Firebase::Client.new(base_uri)

    document = Nokogiri::XML(open(path_to_file))
    doc_list = document.css("prospet")
    doc_list.each { |doc|
      payload = build_property_payload(doc)
      firebase.push("prospets", payload)
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
