class HooksController < ApplicationController

  def ping
    render text: 'pong', :status => 200
  end
  
  # hook queing the file to process in the validationQ
  # curl -i http://localhost:3000/hooks/handledata?xmlfilename=http://localhost:3000/properties_20150129190212.xml
  def handledata
    ValidateXmlJob.perform_later params[:xmlfilename] unless params[:xmlfilename].nil? # put new job in the validate_xml_q queue
    render nothing: true, :status => 200
  end
  
  # curl -i 'http://hubworker.herokuapp.com/hooks/handleproperties?filename=properties_20150129190212.xml&agent_id=immo356'
  def handleproperties
    
    IronWorkerNG::Client.new
    task_id = client.tasks.create('ValidateXML',
                                  {:agent_id    => params[:agent_id],
                                   :entity_type => 'properties',
                                   :file_name   => params[:filename]} )
                                   
    render nothing: true, :status => 200
  end
  
  # curl -i 'http://localhost:3000/hooks/handleprospets?filename=prospets_20150129190212.xml&agent_id=immo356'
   def handleprospets
     puts params.inspect
     ValidatePropspetsXmlJob.perform_later(params[:filename], params[:agent_id]) unless params[:filename].nil? && params[:agent_id].nil?# put new job in the validate_xml_q queue
     render nothing: true, :status => 200
   end
end
