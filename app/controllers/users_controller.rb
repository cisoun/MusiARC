class UsersController < ApplicationController
  
  def new
    @user = User.new
  end
  
    def create
      @user = Post.new(params[:user])
      if @user.save
        redirect_to @user
      else
        render 'new'
      end
  end  
end