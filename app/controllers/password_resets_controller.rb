class PasswordResetsController < ApplicationController
  layout 'main'

  # vedi http://www.binarylogic.com/2008/11/16/tutorial-reset-passwords-with-authlogic/
  before_filter :load_user_using_perishable_token, :only => [:edit, :update]
  skip_before_filter :require_user
  before_filter :require_no_user

  def edit
    render
  end

  def new
    render
  end

  def create
    @user = User.find_by_email(params[:email])
    if @user
      @user.deliver_password_reset_instructions!
      flash[:notice] = "Ti abbiamo ora inviato un'email con le istruzioni per ottenere una nuova password. " +
      "Controlla la tua email."
      redirect_to root_url
    else
      flash[:notice] = "Attenzione: indirizzo email non presente nei nostri archivi (hai forse utilizzato un'altra email?)"
      render :action => :new
    end
  end

  def update
    @user.password = params[:user][:password]
    @user.password_confirmation = params[:user][:password_confirmation]
    if @user.save
      flash[:notice] = "Password aggiornata con successo"
      redirect_to root_url
    else
      render :action => :edit
    end
  end

  private

  def load_user_using_perishable_token
    @user = User.find_using_perishable_token(params[:id])
    unless @user
#      flash[:notice] = "We're sorry, but we could not locate your account. " +
#      "If you are having issues try copying and pasting the URL " +
#      "from your email into your browser or restarting the " +
#      "reset password process."
       flash[:notice] = "Ci spiace, ma non riusciamo a identificare il tuo accesso. "+
         "Fai un altro tentativo copiando ed incollando l'indirizzo http che ti abbiamo inviato dalla tua email al browser, " +
         "oppure riprova con un nuovo tentativo di farti inviare la nuova password."
      redirect_to root_url
    end
  end

end