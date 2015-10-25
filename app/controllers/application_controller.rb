class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  protect_from_forgery with: :null_session

  def return_home
    redirect_to '/'
  end

  # SMS could come either to /events or to /rumors
  def save_event(params, is_rumor=false)
    event  = Event.new(entry: params, ip: request.remote_ip)

    # The phone number (or hash) is needed to group sms' from same user    
    if Rails.env.development?
      # We're probably using Rapidpro's simulator
      phone   = Digest::SHA256.hexdigest "#{params[:phone]}#{params[:run]}" 
    else
      phone   = params[:phone]
    end

    steps     = JSON.parse(params[:steps])

    # I think that text of last step should not be blank
    unless steps.empty?
      if steps.last['type'] == 'R'
        steps.last['text']  = params[:text]
      end
    end

    completion = Completion.find_or_initialize_by(phone: phone, primary: JSON.parse(params[:steps]).first['node'])
    completion.update!(
      arrived_on:  JSON.parse(params[:steps]).last["arrived_on"],
      ids:         JSON.parse(params[:steps]).map{|e| e['node']},
      left_on:     JSON.parse(params[:steps]).last["left_on"],
      primary:     JSON.parse(params[:steps]).first['node'],
      values:      JSON.parse(params[:values]),
      flow:        params[:flow],
      run:         params[:run],
      step:        params[:step],
      text:        params[:text],
      created_at:  DateTime.now,
      ip:          request.remote_ip,
      phone:       phone,
      status:      'new',
      soft_delete: false,
      steps:       steps,
      is_rumor:    is_rumor
      )

    return event
  end
end
