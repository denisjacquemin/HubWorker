class ValidateProspectsXmlJob < ActiveJob::Base
  queue_as :validate_prospets_xml_q

  require 'open-uri'

  # check if the file_name contains properties or prospects
  # if errors persist them
  # valide against xsd
  # if errors persist them
  # send to right PersistPropertiesJob or PersistProspectsJob
  def perform(file_name, user_id)
    path_to_file = ENV['FTP_HOST'] + user_id + '/prospets/' + file_name
    
    Delayed::Worker.logger.debug("In ValidateProspectsXmlJob ####### #{path_to_file}")
    
    schema = Nokogiri::XML::Schema(File.read(File.join(Rails.root, 'app', 'xsd', 'prospects.xsd' )))
    document = Nokogiri::XML(open(path_to_file))
    errors = schema.validate(document)
    
    errorsMsg = errors.collect { |error|
      error.to_s
    }
    
    Delayed::Worker.logger.debug("ValidateXmlJob####### #{errorsMsg.inspect}")
    
    if errors.empty? # if xml is valid, store the data in db
      PersistPropertiesJob.perform_later path_to_file
    else # if xml is invalid store the errors in db
      Delayed::Worker.logger.debug("Errors found to persist: #{errorsMsg.inspect}")
      PersistErrorsJob.perform_later(errorsMsg, file_name, user_id)
    end
  end
end
