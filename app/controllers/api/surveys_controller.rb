class Api::SurveysController < ApplicationController
  respond_to :json

  def index
    # Track.create(ip: request.remote_ip, params: params)
    @primary_nodes = []
    Record.all.group_by{|e| e.primary}.keys.each do |e|
      #@primary_nodes[e] = Record.primary_node_text(e)
      @primary_nodes << {node: e, question: Record.primary_node_text(e), flare: Completion.flare(e)}
    end

    render json: @primary_nodes
  end
end