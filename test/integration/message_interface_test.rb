require 'test_helper'

class MessageInterfaceTest < ActionDispatch::IntegrationTest
  
  def setup
    @user       = users(:michael)
    @other_user = users(:archer) 
  end
  
  test "message interface" do
    log_in_as(@user)
    get messages_path
    # 無効な送信
    assert_no_difference 'Message.count' do
      post messages_path, params: { message: { to_account_name: @other_user.account_name} }
    end
    assert_no_difference 'Message.count' do
      post messages_path, params: { message: { message: "message without to account name"} }
    end
    assert_no_difference 'Message.count' do
      post messages_path, params: { message: { to_account_name: "nobody_called_this",
                                               message: "message with wrong account name"} }
    end
    # 有効な送信
    message = "this is the correct message"
    assert_difference 'Message.count', 1 do
      post messages_path, params: { message: { to_account_name: @other_user.account_name,
                                               message: message } }
    end
    
    
  end
end
