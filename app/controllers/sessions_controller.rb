class SessionsController < ApplicationController
  def new
  end
  
  def create
    @errors = false
    user = User.find_by_email(params[:email])
    
    if user && user.authenticate(params[:password])
      session[:user_id] = user.id
      if !user.first_name.blank?
        flash[:success] = "Welcome back " + user.first_name + "!"
      else
        flash[:success] = "Welcome back!"
      end
      redirect_to profile_url
    else
      @errors = true
      flash.now[:alert] = "Hmm, there were some errors..."
      render 'new'
    end
  end
  
  def destroy
    session[:user_id] = nil
    flash[:success] = "Goodbye!"
    redirect_to root_url
  end
end
