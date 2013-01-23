require 'spec_helper'   
describe Blogger do


	let(:llb_id) { '2510490903247292153'}
	let(:qlh_id) {'2360593805083673688'}

	context "new object model" do
		#psuedo di for testing
		before :each do
			Blogger.extend GooglerTestingService
			Blogger.include_test_client
		end


		let(:blogger) {Blogger.new(:token => 'fake-t0ken', :service => 'blogger')}
		it "can get some info about my blogs" do
			
			result = blogger.get_blogs(:blogId => '2510490903247292153')
			result.data['name'].should == 'Loud Like Bulls'
		end

		it "should be able to count the number of posts a blog contains" do
			posts_count = blogger.count_posts(llb_id)
			posts_count.should eq 2
			posts_count.should be_a(Integer)
		end

		it "should be able to fetch 77 posts from the quiet like horses blog" do
			posts = blogger.fetch_post_names_and_ids(qlh_id, 27)
			posts.count.should eq 27
		end

		it "should be able to get all posts for a blog" do
			result  = blogger.all_posts(llb_id)
			result.count.should be > 1
		end

		it "can fetch an individual blog post" do
			result = blogger.get_posts(:blogId => 2510490903247292153, :postId => 7525644124941255150)
			result.data['title'].should match /Pretty Things/i
		end

		it "can update a blogger post" do
			pending 'my testing service strategy cannot make this call, 
			going to have to build fixtures and stub'
			backup_fixture_string = File.read(Rails.root.join('spec/fixtures/blogs/2510490903247292153/posts/7525644124941255150.json'))
			post = JSON.parse(backup_fixture_string)
			post['content'].gsub!(/(s[0-9]{3})\//, 's600/').gsub(/height="[0-9]{3}"/, '').gsub(/width="[0-9]{3}"/, '')
			#puts post
			#puts post['title']
			result = blogger.patch_posts(
				:blogId => 2510490903247292153, 
				:postId => 7525644124941255150,
				:body_object => {
					:title => 'New Pretty Things'
				} 
			)
			puts result.data
			puts result.response.body
		end



		
	end


end