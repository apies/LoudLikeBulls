require 'google/api_client'    
require 'oauth2'

class Blogger < Googler


  def count_posts(blog_id)
    blog = get_blogs(:blogId => blog_id)
    blog.data['posts']['totalItems'].to_i
  end

  def all_posts(blog_id)
    posts_count = count_posts(blog_id)
    result = fetch_posts(blog_id, posts_count)
    result 
  end

  def fetch_posts(blog_id, number_of_posts)
    @fetcher = Fetcher.new(number_of_posts)
    request_lambda = ->(blog_id, token) do 
      params = { :blogId => blog_id, :maxResults => 20 }
      params.merge!(:pageToken => token) unless token.blank?
      list_posts(params)
    end
    fetcher.fetch_records(blog_id, &request_lambda)
  end


  def fetch_post_names_and_ids(blog_id, number_of_posts)
    @fetcher = Fetcher.new(number_of_posts)
    request_lambda  = ->(blog_id, token)  do
      params = { :blogId => blog_id, :maxResults => 20, :fields =>'nextPageToken, items(title, id)' }
      params.merge!(:pageToken => token) unless token.blank? 
      list_posts(params) 
    end
    fetcher.fetch_records(blog_id, &request_lambda)
  end


end









