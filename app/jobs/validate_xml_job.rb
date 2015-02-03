class ValidateXmlJob < ActiveJob::Base
  queue_as :validate_xml_q

  require 'open-uri'

  # process job from validateXMLQ
  # do the check
  # if pass send to persistDataQproperties.dtd
  # if error send to persistErrorQ
  def perform(xmlfilename)
    
    schema = Nokogiri::XML::Schema(File.read(File.join(Rails.root, 'app', 'xsd', 'properties.xsd' )))
    document = Nokogiri::XML(open(xmlfilename))
    errors = schema.validate(document)
    
    Delayed::Worker.logger.debug("ValidateXmlJob####### #{errors.inspect}")
    
    if errors.empty? # if xml is valid, store the data in db
      PersistDataJob.perform_later xmlfilename
    else # if xml is invalid store the errors in db
      Delayed::Worker.logger.debug("Errors found to persist: #{errors.inspect}")
      #PersistErrorJob.perform_later errors
    end
  end
end
