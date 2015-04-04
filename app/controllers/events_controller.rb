require 'digest'

class EventsController < ApplicationController
  respond_to          :json
  before_action       :set_event, only: [:show, :edit, :update, :destroy]
  before_action       :return_home, except: [:create]
  skip_before_filter  :verify_authenticity_token

  def return_home
    redirect_to '/'
  end

  def create
    params[:text].chomp!
    # Store raw SMS from Rapidpro

    @event = save_event params

    if @event.save
      render json: {notice: 'Event was successfully created.'}
    else
      render json: {error: 'Failure'}
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_event
      @event = Event.find(params[:id])
    end
end
