class Api::StatusesController < ApplicationController
  respond_to :json

  def index
    statuses = [
      {
        id: 'new',
        name: 'new'
      },
      {
        id: 'investigation',
        name: 'investigation'
      },
      {
        id: 'verified',
        name: 'verified'
      },
      {
        id: 'debunked',
        name: 'debunked'
      }
    ]
    render json: statuses
  end
end