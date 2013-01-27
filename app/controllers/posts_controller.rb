class PostsController < ApplicationController  

  def index
    posts = @blogger.all_posts(params[:blog_id])
  	render :json => posts.to_json
  end

  def show
  	result = @blogger.get_posts(:blogId => params[:blog_id], :postId => params[:id])
    if result.data['error']
      render :json => {
        :error => {
          :message => "unfortunately either blog with blog_id:#{params[:blog_id]}post_id:#{params[:id]} was not found" + 
            " or your access_token #{session[:access_token]} is invalid"
        }
      }
    else
      render :json => result.data.to_json
    end
  end


  def patch_post
  	#this works, now need to write the angular service
  	result = @blogger.patch_posts(
				:blogId => 2510490903247292153, 
				:postId => 7525644124941255150,
				:body_object => {
					:title => 'New Pretty Things'
				} 
			)
  	render :json => result.data.to_json

  end


end
