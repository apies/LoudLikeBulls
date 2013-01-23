require 'spec_helper'
describe GooglerTestingService do

	before :all do
		class Tester < Googler
			extend GooglerTestingService
		end
	end
	


	context "using object model" do
		
		it "can extend Googler and create a service client" do
			Tester.should respond_to(:include_test_client)
			Tester.include_test_client
			blogger = Tester.new(:token => 'fake-t0ken', :service => 'blogger')
			blogger.should respond_to(:_create_client)
			result = blogger.get_blogs(:blogId => 2510490903247292153)
			result.data['name'].should eq 'Loud Like Bulls'
		end
		
	end

	
end