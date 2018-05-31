class MessagesController < ApplicationController
  before_action :logged_in_user, only: [:index, :show, :create]
  before_action :get_message_and_contacts, only: [:index, :show, :create]
  
  def index

  end
    
  def show
    @messages = get_messages_with_id(params[:id])
  end
  
  def create
    @message  = @current_user.messages.build(message_params)
    if(@user = User.find_by(account_name: @message.to_account_name))
      @messages = get_messages_with_id(@user.id)
      if @message.save
        @message = @current_user.messages.build(to_account_name: @user.account_name)
      end
      render "show"
    else
      flash[:danger] = "User not found"
      redirect_to messages_url
    end
      
  end
    
  private
  
    def message_params
      params.require(:message).permit(:message, :to_account_name)
    end
    
    def get_messages_with_id(id)
      if(user = User.find(id))
      @message.to_account_name = user.account_name
      @messages = @current_user.messages_with_other_user(user).paginate(page: params[:page])
      end
    end
    
    def get_message_and_contacts
      @message  = @current_user.messages.build
      @contacts = get_contacts      
    end
    
    def get_contacts
      contacts = Array.new
      messages = @current_user.allmessages
      messages.each {
        |message|
        user = nil
        if(message.user_id == current_user.id)
          user = User.find_by(account_name: message.to_account_name)
        elsif(message.to_account_name == current_user.account_name)
          user = User.find(message.user_id)
        end
        contacts << user if(!user.nil? && !contacts.include?(user))
      }
      return contacts
    end
end
