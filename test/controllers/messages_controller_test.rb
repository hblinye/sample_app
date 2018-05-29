require 'test_helper'

class MessagesControllerTest < ActionDispatch::IntegrationTest

  test "should redirect index when not logged in" do
    get messages_path
    assert_redirected_to login_url
  end
end
