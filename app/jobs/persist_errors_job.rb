class PersistErrorsJob < ActiveJob::Base
  queue_as :persist_errors_q

  def perform(errors, file_name, user_id)
    base_uri = ENV['FIREBASE_URL']
    firebase = Firebase::Client.new(base_uri)
    errors.each { |error| 
      payload = build_error_payload(error, file_name, user_id)
      firebase.push("errors", payload)
    }
    
  end
  
  private
  
  def build_error_payload(error, file_name, user_id)
    Jbuilder.encode do |json|
      json.user_id(user_id)
      json.file_name(file_name)
      json.error(error)
    end
  end
end
