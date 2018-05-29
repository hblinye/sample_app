require 'test_helper'

class MessageTest < ActiveSupport::TestCase
  def setup
    @user = users(:michael)
    @message = @user.messages.build(message: "Lorem ipsum", user_id: @user.id,to_account_name: "undefined")
  end

  test "should be valid" do
    assert @message.valid?
  end

  test "user id should be present" do
    @message.user_id = nil
    assert_not @message.valid?
  end
  
  test "to account name should be present" do
    @message.to_account_name = nil
    assert_not @message.valid?
  end
  
  test "message should be present" do
    @message.message = "   "
    assert_not @message.valid?
  end

  test "content should be at most 140 characters" do
    @message.message = "a" * 201
    assert_not @message.valid?
  end
end