require 'test_helper'

class NfldataControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get nfldata_index_url
    assert_response :success
  end

end
