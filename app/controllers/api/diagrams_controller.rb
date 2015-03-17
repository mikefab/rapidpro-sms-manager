class Api::DiagramsController < ApplicationController
  respond_to :json

  def index
  	diagram = Completion.diagram(params[:node])
  	flare   = Completion.flare(diagram)
    render json: [Completion.diagram(params[:node])]
  end
end