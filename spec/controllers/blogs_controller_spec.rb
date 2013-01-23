require 'spec_helper'

describe BlogsController do

	let(:llb_id) {'2510490903247292153'}

  before :each do
    Blogger.extend GooglerTestingService
    Blogger.include_test_client
  end

  describe "#index" do

    it "returns http success" do
      xhr :get, :index, {}
      response.should be_success
    end


  end

  describe "#show" do

    it "returns my blog details" do
      xhr :get, :show, :id => llb_id
      JSON.parse(response.body)['name'].should eq "Loud Like Bulls"
      response.should be_success
    end

    it "returns a blog not found or invalid credentials message when an invalid blog id or credential is passed in and message includes params" do
      xhr :get, :show, :id => 'invalid1234232'
      JSON.parse(response.body)['error']['message'].should match(/blogId:invalid1234232/)
    end

 end



end
