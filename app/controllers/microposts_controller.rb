class MicropostsController < ApplicationController
  before_action :logged_in_user, only: [:create, :destroy]
  before_action :correct_user,   only: :destroy
  def create
    @micropost = current_user.microposts.build(micropost_params)
    content = @micropost.content
    splitbyat    = content.split '@'
    splitbyblank = splitbyat[1].split if !splitbyat[1].nil?
    if replyname = splitbyblank.nil? ? nil : splitbyblank[0]
      replyname  = replyname.slice 0,20 if replyname.length > 20
    end
    replyuser    = User.find_by(account_name: replyname)
    @micropost.in_reply_to = replyuser.id if !replyuser.nil? && replyuser.id!=current_user.id 
    
    if @micropost.save
      flash[:success] = "Micropost created!"
      redirect_to root_url
    else
      @feed_items = []
      render 'static_pages/home'
    end
  end

  def destroy
    @micropost.destroy
    flash[:success] = "Micropost deleted"
    redirect_to request.referrer || root_url
  end

  private

    def micropost_params
      params.require(:micropost).permit(:content, :picture)
    end
    
    def correct_user
      @micropost = current_user.microposts.find_by(id: params[:id])
      redirect_to root_url if @micropost.nil?
    end
end