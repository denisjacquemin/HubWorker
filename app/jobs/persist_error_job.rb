class PersistErrorJob < ActiveJob::Base
  queue_as :persist_error_q

  def perform(*args)
    # Do something later
  end
end
