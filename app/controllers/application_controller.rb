require Rails.root.join('app/models/fetcher.rb')
class ApplicationController < ActionController::Base
	
	before_filter :spawn_blogger
  respond_to :json

  def spawn_blogger
    @blogger = Blogger.new(:token => session[:access_token] , :service => 'blogger')
  end
  protect_from_forgery
  
end
