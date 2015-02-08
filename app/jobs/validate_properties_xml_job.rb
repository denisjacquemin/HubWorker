class ValidatePropertiesXmlJob < ActiveJob::Base
  queue_as :validate_properties_xml_q

  # check if the file_name contains properties or prospects
  # if errors persist them
  # valide against xsd
  # if errors persist them
  # send to right PersistPropertiesJob or PersistProspectsJob
  def perform(file_name, agent_id)    
    iron_worker = IronWorkerNG::Client.new
    iron_worker.tasks.create("validate_properties_xml", {:file_name=>file_name, :agent_id => agent_id})
  end
end
