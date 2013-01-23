require 'spec_helper'  
describe Googler do


  context "object oriented inheritence strategy" do

    before :all do
    	class GooglerTester < Googler
      	def instantiate_service(service)
      		@service = service
      	end
      end
    end


    it "should instantiate itself with a service and a token" do
    	googler = GooglerTester.new(:token => 'token', :service => Dir)
    	googler.token.should eq 'token'
    	googler.service.should eq Dir
    end

    context "method missing google client api wrapper" do

    	subject {GooglerTester.new(:token => 'token', :service => Dir)}

    	it "should correctly build the method missing attribute hash" do
        method_hash = subject.get_method_hash('get_posts')
        method_hash[:model].should eq 'posts'
        method_hash[:method].should eq 'get'
        method_hash_complex = subject.get_method_hash('list_blogs_by_user')
        method_hash_complex[:model].should eq 'blogs'
        method_hash_complex[:method].should eq 'list_by_user'
    	end


    	it "should be able to build an api_method method on the service and client objects" do
      	api_method = subject.build_api_method('pwd', 'to_s')
      	api_method.should eq Dir.pwd.to_s
    	end
    
	    it "should be able to build an execution hash to send to the google client" do
	      execution_hash = subject.build_execution_hash('length_pwd', {'userId' => 'self'} )
        execution_hash[:parameters].should eq({'userId' => 'self'})
	      execution_hash[:api_method].should eq(Dir.pwd.length)
	    end
	    
	    it "should build the execution hash and execute it on method missing" do
	      subject.client = double('client')
	      subject.client.should_receive(:execute).with(:api_method => Dir.pwd.length, :parameters => {'userId' => 'self'}, :headers => {'Content-Type' => 'application/json'})
	      subject.length_pwd('userId' => 'self')
	    end
	    
	    it "should be able to make api calls with method missing hook" do
        subject.client = double('client')
	      subject.client.should_receive(:execute).with(:api_method => Dir.pwd.length, :parameters => {'userId' => 'self'}, :headers => {'Content-Type' => 'application/json'})
        #googler  = GooglerTester.new(:token => 'token', :service => Dir)
	      subject.length_pwd('userId' => 'self')
	    end

      it "should be able to strip body object out of params" do
        params = {
          :blogId => '123',
          :postId => 'kjh21',
          :body_object => {
            :title => 'Blogs are Cool',
            :content => '<h1>BLOGS ARE COOL!</h1>'
          }
        }
          
        parsed_params = subject.parse_params(params)
        parsed_params[:body_object][:title].should eq 'Blogs are Cool'
        parsed_params[:params][:blogId].should == '123'
      end



    end

    

    




 end

  
  
  
  
end