class BlogsController < BloggerController 
  
  def index
  	result = @blogger.list_blogs_by_user({'userId' => 'self'})
  	render :json => result.data['items'].to_json
  end

  def show
  	result = @blogger.get_blogs(:blogId => params[:id])
    if result.data['error']
      render :json => {
        :error => {
          :message => "unfortunately either blog with blogId:#{params[:id]} was not found" + 
            " or your access_token #{session[:access_token]} is invalid"
        }
      }
    else
      render :json => result.data.to_json
    end
  end

end
