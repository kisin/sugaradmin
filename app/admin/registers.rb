ActiveAdmin.register Register do
	action_item :only => [:show] do
		button_to "רשום משתמש ושלח דואר הרשמה", createuser_admin_register_path(register) if register.registered==0
	end

	member_action :createuser, :method => :post do
		register = Register.find(params[:id])
		o = [('a'..'z'),(0..9)].map{ |i| i.to_a }.flatten
		pw = (0...4).map{ o[rand(o.length)]  }.join

		User.create({:email => register.email, :type_id => register.type_id, :password => pw})
		UserMailer.create_new_user_from_register(register, pw).deliver
		register.update_attribute(:registered, 1)

		redirect_to admin_registers_path, :notice => "ההודעה נשלחה למשתמש בכתובת #{register.email}"
	end
end