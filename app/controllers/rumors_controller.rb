require 'digest'

class RumorsController < ApplicationController
  respond_to          :json
  before_action       :set_event, only: [:show, :edit, :update, :destroy]
  before_action       :return_home, except: [:create]
  skip_before_filter  :verify_authenticity_token

  def create
    params[:text].strip!
    
    # Store raw SMS from Rapidpro
    @rumor = save_event params, true

    if @rumor.save
      render json: {notice: 'Event was successfully created.'}
    else
      render json: {error: 'Failure'}
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_event
      @rumor = Event.find(params[:id])
    end
end
