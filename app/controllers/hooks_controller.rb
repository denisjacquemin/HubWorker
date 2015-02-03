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
end
