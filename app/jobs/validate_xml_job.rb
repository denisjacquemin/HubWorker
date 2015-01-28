class ValidateXmlJob < ActiveJob::Base
  queue_as :validate_xml_q

  def perform(*args)
    # process job from validateXMLQ
    # do the check
    # if pass send to persistDataQ
    # if error send to persistErrorQ
    
    #Rails.logger.debug "xmlfilename: #{args[:xmlfilename]}"
    Rails.logger.debug "args: #{args}"
    
    
    #unless args[:xmlfilename] PersistErrorJob.perform_later args # xmlfilename is mandatory
    
    PersistDataJob.perform_later
  end
end
