class HooksController < ApplicationController

  ###########
  #  hooks  #
  ###########

  def ping
    Rails.logger.debug "HubWorker /hooks/test called!"
    render text: 'pong', :status => 200
  end
  
  # hook that record the file to process in the validationQ
  # curl -i http://localhost:3000/hooks/handledata
  def handledata
    Rails.logger.debug "HubWorker /hooks/handledata called!"
    xmlfilename = params[:xmlfilename]
    ValidateXmlJob.perform_later xmlfilename # put new job in the validate_xml_q queue
    render nothing: true, :status => 200
  end
  
  
  ##########
  #  Jobs  #
  ##########
  
  # Persist data in datastore
  def persistDataJob
    # process job from persistDataQ
    
    #Pour chaque item
    #  try 
    #    create_or_update or delete firebase
    #  catch
    #    send to persistErrorQ
  end
  
  # Persist error in datastore
  def persistErrorJob
    # process job from persistErrorQ
    
    # create Error log in firebase
    
  end
  
  # Validate XML file against the DTD
  def validateXMLJob
    # process job from validateXMLQ
    # do the check
    # if pass send to persistDataQ
    # if error send to persistErrorQ
  end
end
