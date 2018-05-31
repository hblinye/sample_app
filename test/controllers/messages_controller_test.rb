require 'test_helper'

class MessagesControllerTest < ActionDispatch::IntegrationTest

  def setup
    @user    = users(:michael)
    @other_user = users(:archer)
  end

  test "should redirect when not logged in" do
    get messages_path
    assert_redirected_to login_url
    
    get messages_path, params: {id: "1"}
    assert_redirected_to login_url
    
    post messages_path, params: {message: { to_account_name: "Sterling_Archer", message: "hello,world"}}
    assert_redirected_to login_url
  end

end
