require 'rails_helper'
require 'requests_helper'
require 'spec_helper'

describe 'Users' do
  it "does not allow non logged in user into rails admin" do
    # user = User.create!(:email => 'a@a.com', :password => 'password!')
    # login(user)
    get '/rumors'
    expect(response).to have_http_status(302)
  end  

  it "does not allow non admin user into rails admin" do
    user = User.create!(:email => 'a@a.com', :password => 'password!')
    login(user)
    get '/api/rumors'
    body = JSON.parse(response.body)
    expect(body['error']).to eq('You need to sign in or sign up before continuing.')
  end  


  it "allows admin user into rails admin" do
    user = User.create!(:email => 'a@a.com', :password => 'password!', role: 'admin')
    login(user)
    get '/rumors'
    expect(response).to have_http_status(200)
  end
end  
