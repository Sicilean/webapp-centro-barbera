module UsersHelper
  def user_role_types_available_for_current_user
    if @current_user.is_cliente?
      return []
    else
      # USER_ROLE_TYPES =
      #    [
      #            ['amministratore', 10],
      #            ['operatore', 20],
      #            ['cliente', 30]
      #    ]
      my_array = Array.new
      USER_ROLE_TYPES.each {|x| my_array << x if x[1] >= @current_user.role}
      return my_array
    end
  end
end
