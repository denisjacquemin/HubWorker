class HooksController < ApplicationController

  def ping
    render text: 'pong', :status => 200
  end

  # http://hubworker.herokuapp.com/hooks/validatexml?filename=properties_20150129190212.xml&agent_id=immo356&entity_type=properties
  # curl -i 'http://localhost:3000/hooks/handleproperties?filename=properties_20150129190212.xml&agent_id=immo356'
  def validate_xml
    
    client = IronWorkerNG::Client.new
    task_id = client.tasks.create('ValidateXML',
                                  {:agent_id    => params[:agent_id],
                                   :entity_type => params[:entity_type],
                                   :file_name   => params[:filename]} )
                                   
    render nothing: true, :status => 200
  end
  
  def save_data
    client = IronWorkerNG::Client.new
    task_id = client.tasks.create('SaveData',
                                  {:agent_id    => params[:agent_id],
                                   :entity_type => params[:entity_type],
                                   :file_name   => params[:filename]} )                             
    render nothing: true, :status => 200
  end

end
