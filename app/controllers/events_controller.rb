require 'digest'

class EventsController < ApplicationController
  respond_to :json
  before_action :set_event, only: [:show, :edit, :update, :destroy]
  before_action :return_home, except: [:create]
  skip_before_filter  :verify_authenticity_token


  def return_home
    redirect_to '/'
  end

  # # GET /events
  # # GET /events.json
  # def index
  #   @events = Event.all
  # end

  # # GET /events/1
  # # GET /events/1.json
  # def show
  # end

  # # GET /events/new
  # def new
  #   @event = Event.new
  # end

  # # GET /events/1/edit
  # def edit
  # end

  # POST /events
  # POST /events.json
  def create

    params[:text].chomp!
    @event  = Event.new(entry: params, ip: request.remote_ip)
    phone   = params[:phone] #Digest::SHA256.hexdigest "#{params[:phone]}#{params[:run]}"
    steps   = JSON.parse(params[:steps])

    # I think that text of last step should not be blank
    unless steps.empty?
      if steps.last['type'] == 'R'
        steps.last['text'] = params[:text]
      end
    end

    @record = Record.create!(
      run:     params[:run]    ,
      phone:   phone,
      text:    params[:text]   ,
      flow:    params[:flow]   ,
      step:    params[:step]   ,
      channel: params[:channel],
      values:  JSON.parse(params[:values]),
      steps:   steps,
      primary: JSON.parse(params[:steps]).first['node'],
      ids:     JSON.parse(params[:steps]).map{|e| e['node']},
      arrived_on: JSON.parse(params[:steps]).last["arrived_on"],
      left_on:    JSON.parse(params[:steps]).last["left_on"],
      created_at: DateTime.now,
      ip: request.remote_ip
      )

    @completion = Completion.find_or_initialize_by(phone: phone, primary: JSON.parse(params[:steps]).first['node'])
    @completion.update!(
      run:         params[:run]    ,
      phone:       phone  ,
      text:        params[:text]   ,
      flow:        params[:flow]   ,
      step:        params[:step]   ,
      values:      JSON.parse(params[:values]),
      steps:       steps,
      primary:     JSON.parse(params[:steps]).first['node'],
      ids:         JSON.parse(params[:steps]).map{|e| e['node']},
      arrived_on:  JSON.parse(params[:steps]).last["arrived_on"],
      left_on:     JSON.parse(params[:steps]).last["left_on"],
      created_at:  DateTime.now,
      status:      'new',
      soft_delete: false,
      ip: request.remote_ip
      )

    @record.save!


    if @event.save
      render json: {notice: 'Event was successfully created.'}
    else
      render json: {notice: 'Failure'}
    end


    # respond_to do |format|
    #   if @event.save
    #     puts "!!!!!!"
    #     format.html { redirect_to @event, notice: 'Event was successfully created.' }
    #     format.json { render :show, status: :created, location: @event }
    #   else
    #     format.html { render :new }
    #     format.json { render json: @event.errors, status: :unprocessable_entity }
    #   end
    # end
  end

  # # PATCH/PUT /events/1
  # # PATCH/PUT /events/1.json
  # def update
  #   respond_to do |format|
  #     if @event.update(event_params)
  #       format.html { redirect_to @event, notice: 'Event was successfully updated.' }
  #       format.json { render :show, status: :ok, location: @event }
  #     else
  #       format.html { render :edit }
  #       format.json { render json: @event.errors, status: :unprocessable_entity }
  #     end
  #   end
  # end

  # # DELETE /events/1
  # # DELETE /events/1.json
  # def destroy
  #   @event.destroy
  #   respond_to do |format|
  #     format.html { redirect_to events_url, notice: 'Event was successfully destroyed.' }
  #     format.json { head :no_content }
  #   end
  # end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_event
      @event = Event.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def event_params
      params.require(:event).permit(:entry)
    end

    def record_params
      params.require(:record).permit(:run, :phone, :text, :flow, :relayer, :step, :values, :steps)
    end

    def node_params
      params.require(:node).permit(:node, :arrived_on, :left_on, :text, :type, :value)
    end



end
