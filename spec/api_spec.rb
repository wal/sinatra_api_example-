require File.dirname(__FILE__) + '/spec_helper'

describe "errors" do
  it "should POST to /api" do    
    ApiRequest.should_receive(:create!)    
    post '/api'
    assert last_response.ok?
  end
end
