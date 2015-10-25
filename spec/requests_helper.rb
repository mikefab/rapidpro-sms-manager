require 'spec_helper'
require File.expand_path("../../config/environment", __FILE__)
require 'rspec/rails'
require 'capybara'
require 'capybara/rspec'

def login(user)
  post_via_redirect user_session_path, 'user[email]' => user.email, 'user[password]' => user.password
end  
