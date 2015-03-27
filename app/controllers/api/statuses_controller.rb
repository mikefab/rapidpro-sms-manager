class Api::StatusesController < ApplicationController
  respond_to :json

  def index
    statuses = [
      {
        id: 'new',
        name: 'new'
      },
      {
        id: 'investigating',
        name: 'investigating'
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

    urgencies = [
      {
        id: 'low',
        name: 'low'
      },
      {
        id: 'medium',
        name: 'medium'
      },
      {
        id: 'high',
        name: 'high'
      }

    ]

    render json: [statuses, urgencies]
  end
end