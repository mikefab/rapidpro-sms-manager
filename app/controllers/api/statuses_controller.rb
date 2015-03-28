class Api::StatusesController < ApplicationController
  respond_to :json

  def index
    statuses = [
      {
        id:     'new',
        name:   'new',
        symbol: 'n'
      },
      {
        id:     'investigating',
        name:   'investigating',
        symbol: 'i'
      },
      {
        id:     'verified',
        name:   'verified',
        symbol: 'v'
      },
      {
        id:     'debunked',
        name:   'debunked',
        symbol: 'd'
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