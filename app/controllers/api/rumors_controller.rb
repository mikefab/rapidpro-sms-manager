class Api::RumorsController < ApplicationController
  before_action :set_completion, only: [:show, :edit, :update, :destroy]

  respond_to :json

  def index
    # Track.create(ip: request.remote_ip, params: params)
    @completions = []
    Completion.all.order_by(:arrived_on => 'desc').select{|c| c.steps[0].text.match(/deysay/i)}.each do |c|
      @completions << {
        explanation: c.explanation,
        id:          c.id.to_s,
        text:        c.text,
        last_date:   c.created_at,
        status:      c.status  || 'new',
        urgency:     c.urgency || 'low',
        notes:       c.notes,
        phone:       c.phone

      }
    end
    render json: @completions
  end


  def update
    render json: @completion.update(completion_params)

    # respond_to do |format|
    #   if @completion.update(completion_params)
    #     format.json { render :json, status: :ok, location: @completion }
    #   else

    #     format.json { render json: @completion.errors, status: :unprocessable_entity }
    #   end
    # end
  end


  private
    # Use callbacks to share common setup or constraints between actions.
    def set_completion
      @completion = Completion.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def completion_params
      params.require(:rumor).permit(:run, :flow, :phone, :values, :steps, :step, :primary, :ids, :status, :urgency, :text, :soft_delete, :notes, :explanation)
    end
end