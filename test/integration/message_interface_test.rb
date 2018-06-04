require 'test_helper'

class MessageInterfaceTest < ActionDispatch::IntegrationTest
  
  def setup
    @user       = users(:michael)
    @other_user = users(:archer)
    @third_user = users(:lana)
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
    assert_equal @other_user.messages_with_other_user(@user).first.message,message
  end
  
  
  test "send message from user show page" do
    log_in_as(@user)
    get user_path(@third_user)
    assert_select "div.send-to"
    get message_path(@third_user)
    assert_select "form.new_message"
    assert @user.messages_with_other_user(@third_user).empty?
    assert @third_user.messages_with_other_user(@user).empty?
    contacts_before = assigns(:contacts).count
    assert_difference 'Message.count', 1 do
      post messages_path, params: { message: { to_account_name: @third_user.account_name,
                                               message: "first_message" } }
    end
    contacts_after = assigns(:contacts).count
    assert_equal contacts_after,(contacts_before+1)
    assert_not @user.messages_with_other_user(@third_user).empty?
    assert_not @third_user.messages_with_other_user(@user).empty?
  end
end
