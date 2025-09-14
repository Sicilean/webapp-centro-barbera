class User < ActiveRecord::Base

  belongs_to :cliente

  acts_as_authentic do |c|
    #c.my_config_option = my_value # for available options see documentation in: Authlogic::ActsAsAuthentic
    c.login_field = :email
  end # block optional

  validates_presence_of :nome

  def deliver_password_reset_instructions!
    reset_perishable_token!
    Notifier.deliver_password_reset_instructions(self)
  end


  def is_admin?
    role == 10
  end

  def is_operator?
    role == 20
  end

  def is_admin_or_operator?
    is_admin? || is_operator?
  end

  def is_cliente?
    role == 30
  end

  def role_in_words
    risultato = ""
    USER_ROLE_TYPES.each do |x|
      if role == x[1]
        risultato = x[0]
      end
    end
    risultato.capitalize
  end
end
