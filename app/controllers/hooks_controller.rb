class HooksController < ApplicationController
  def test
    Rails.logger.debug "HubWorker /hooks/test called!"
    render  nothing: true, :status => 200
  end
end
