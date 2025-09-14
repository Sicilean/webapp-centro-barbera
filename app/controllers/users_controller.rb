class UsersController < ApplicationController



  before_filter :require_user, :only => [:show, :edit, :update]
  before_filter :require_admin_or_operator, :only => [:index, :new, :create, :destroy]

  layout 'main' 

  # la seguente solo per permettere la registrazione
  #before_filter :require_no_user, :only => [:new, :create]

# per amministratori

  def index
      @users = User.all
  end

  def new
      @user = User.new
  end

  def create
    @user = User.new(params[:user])
      if @user.save
        flash[:notice] = 'Utente creato con successo'
        if current_user.is_admin_or_operator?
          redirect_to users_url
        else
          redirect_to root_url
        end
        #il seguente si usa nel caso di registrazioni
        #redirect_back_or_default account_url
      else
        render :action => 'new'
      end
  end

  def destroy
    @user = User.find(params[:id])
    if @user == current_user
      flash[:error] = 'Non puoi cancellare te stesso'
    else
      @user.destroy
      flash[:notice] = 'Utente eliminato con successo.'
    end
    if current_user.is_admin_or_operator?
      redirect_to users_url
    else
      redirect_to root_url
    end
  end


# per utenti normali ed amministratori


#  def show
##    if current_user.is_admin? && !params[:id].blank?
##      @user = User.find(params[:id])
##    else
#      @user = current_user
##    end
#  end

  def edit
    if current_user.is_admin_or_operator? && !params[:id].blank?
      @user = User.find(params[:id])
    else
      @user = current_user
    end
  end

  def update
    if current_user.is_admin_or_operator? && !params[:id].blank?
      @user = User.find(params[:id])
    else
      @user = current_user
    end
    if @user.update_attributes(params[:user])
      flash[:notice] = 'Dati modificati con successo.'
      if current_user.is_admin_or_operator?
        redirect_to users_url
      else
        redirect_to root_url
      end
    else
      render :action => 'edit'
    end
  end


end