class ValidateController < ApplicationController
  def test
  		Rails.logger.debug "HubWorker test!"
  		render nothing: true, :status => 200
  	end
end
