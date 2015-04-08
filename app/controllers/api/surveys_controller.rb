class Api::SurveysController < ApplicationController
  respond_to :json

  def index
    # Track.create(ip: request.remote_ip, params: params)
    @primary_nodes = []
    Completion.non_rumors.all.order_by(:arrived_on => 'desc').group_by{|e| e.primary}.keys.each do |e|
      @primary_nodes << {
        node: e,
        question:         Completion.primary_node_text(e),
        first_date:       Completion.first_event_date(e), 
        last_date:        Completion.last_event_date(e),
        total_instances:  Completion.total_instances(e)
      }
    end
    render json: @primary_nodes
  end
end