require 'test_helper'

class MicropostsInterfaceTest < ActionDispatch::IntegrationTest

  def setup
    @user = users(:michael)
    @reply= users(:archer)
  end

  test "micropost interface" do
    log_in_as(@user)
    get root_path
    assert_select 'div.pagination'
    # 無効な送信
    assert_no_difference 'Micropost.count' do
      post microposts_path, params: { micropost: { content: "" } }
    end
    assert_select 'div#error_explanation'
    # 有効な送信
    content = "This micropost really ties the room together"
    assert_difference 'Micropost.count', 1 do
      post microposts_path, params: { micropost: { content: content } }
    end
    assert_redirected_to root_url
    follow_redirect!
    assert_match content, response.body
    # 投稿を削除する
    assert_select 'a', text: 'delete'
    first_micropost = @user.microposts.paginate(page: 1).first
    assert_difference 'Micropost.count', -1 do
      delete micropost_path(first_micropost)
    end
    # 違うユーザーのプロフィールにアクセス (削除リンクがないことを確認)
    get user_path(users(:archer))
    assert_select 'a', text: 'delete', count: 0
  end
  
  test "micropost with reply" do
    log_in_as(@user)
    get root_path
    content = "@#{@reply.account_name } This micropost really ties the room together"
    assert_difference 'Micropost.count', 1 do
      post microposts_path,params: {micropost: { content: content }}
    end
    assert_redirected_to root_url
    follow_redirect!
    first_micropost = @user.feed.paginate(page: 1).first
    assert_equal @reply.account_name, first_micropost.in_reply_to
    log_out
    log_in_as(@reply)
    get root_path
    first_micropost = @reply.feed.paginate(page: 1).first
    assert_equal @reply.account_name, first_micropost.in_reply_to
    assert_equal @user.id , first_micropost.user_id
    
  end
    
end