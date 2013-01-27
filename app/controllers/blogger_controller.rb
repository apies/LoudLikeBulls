class BloggerController < ActionController::Base
	
	before_filter :spawn_blogger
  respond_to :json

  def spawn_blogger
    @blogger = Blogger.new(:token => session[:access_token] , :service => 'blogger')
  end
  

end