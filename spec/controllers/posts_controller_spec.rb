require 'spec_helper' 

describe PostsController do

  let(:llb_id) { '2510490903247292153'}

  before :all do
    Blogger.extend GooglerTestingService
    Blogger.include_test_client
   end

  describe "#index" do

    it "returns a list of my posts" do
      xhr :get, :index, :blog_id => llb_id
      response.should be_success 
      posts = JSON.parse(response.body)
      posts.count.should be > 1
    end

 end

  describe "#show" do

    let(:first_llb_post_id) { '7525644124941255150' }


    it "returns details about a post by post id" do
      xhr :get, :show, { :blog_id => llb_id , :id => first_llb_post_id }
      response.should be_success
      post = JSON.parse(response.body)
      post['id'].should eq first_llb_post_id
      post['blog']['id'].should eq llb_id
      post['title'].should match /New Pretty things/i
    end

    it "returns a post not found or invalid credentials message when an invalid post id or credential is passed in and message includes params" do
      xhr :get, :show, { :blog_id => llb_id , :id => 'invalidid123' }
      JSON.parse(response.body)['error']['message'].should match(/post_id:invalidid123/)
    end



  end

end
