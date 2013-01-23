class SessionsController < ApplicationController
  
  def create
   session[:access_token] = env['omniauth.auth']['credentials']['token']
   session[:refresh_token] = env['omniauth.auth']['credentials']['refresh_token']
   redirect_to root_path
  end


end
