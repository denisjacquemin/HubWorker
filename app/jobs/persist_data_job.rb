class PersistDataJob < ActiveJob::Base
  queue_as :persist_data_q

  def perform(*args)
    # Do something later
  end
end
