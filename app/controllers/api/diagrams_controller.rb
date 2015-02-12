class Api::DiagramsController < ApplicationController
  respond_to :json

  def index
    render json: [Completion.diagram(params[:node])]
  end
end