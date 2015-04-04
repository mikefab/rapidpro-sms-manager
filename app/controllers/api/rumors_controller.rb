class Api::RumorsController < ApplicationController
  before_action      :set_completion, only: [:show, :edit, :update, :destroy]
  before_filter      :authenticate_user!
  skip_before_filter :verify_authenticity_token

  respond_to :json

  def index
    unless current_user.role == 'admin'
      render json: { error: 'You need to sign in or sign up before continuing.' }
    else
      @completions = []
      rumors       = Completion.rumors !!params[:deleted]

      rumors.each do |c|
        @completions << {
          explanation: c.explanation,
          id:          c.id.to_s,
          text:        c.text,
          last_date:   c.created_at,
          status:      c.status  || 'new',
          urgency:     c.urgency || 'low',
          notes:       c.notes,
          explanation: c.explanation,
          phone:       c.phone,
          arrived_on:  c.arrived_on,
          soft_delete: c.soft_delete || 'false',
          is_public:   c.is_public
        }
      end
      render json: @completions
    end
  end


  def update
    render json: @completion.update(completion_params)
  end


  private
    # Use callbacks to share common setup or constraints between actions.
    def set_completion
      @completion = Completion.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def completion_params
      params.require(:rumor).permit(:run, :flow, :phone, :values, :steps, :step, :primary, :ids, :status, :urgency, :text, :soft_delete, :notes, :explanation, :is_public, :arrived_on)
    end
end