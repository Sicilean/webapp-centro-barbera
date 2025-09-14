class UserSessionsController < ApplicationController
  layout 'main'

  before_filter :require_no_user, :only => [:new, :create]
  before_filter :require_user, :only => :destroy

  def new
    @user_session = UserSession.new
  end

  def create
    @user_session = UserSession.new(params[:user_session])
    if @user_session.save
      #flash[:notice] = 'Entrato con successo.'
      # redirect_back_or_default account_url
      if @user_session.user.is_admin_or_operator?
        redirect_back_or_default :controller => 'admin', :action => 'index'
      else
        redirect_back_or_default :controller => 'main',  :action => 'welcome'
      end
    else
      render :action => 'new'
    end
  end

  def destroy
    if current_user_session
      current_user_session.destroy
      flash[:notice] = 'Uscito con successo.'
    else
      flash[:notice] = 'Nessuna sessione attiva da chiudere.'
    end
    redirect_to root_url
  end

end
