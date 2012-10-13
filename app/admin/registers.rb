# encoding: UTF-8

ActiveAdmin.register Register do
	menu false
	config.sort_order = "id_desc"

	index do
		column :id do |register|
			link_to register.id, admin_register_path(register)
		end
		column :email
		column :type_id do |register|
			case register.type_id
			when 1 then "שוגר דדי"
			when 2 then "שוגר מאמי"
			when 3 then "שוגר בייב"
			when 4 then "שוגר בוי"
			end
		end
		column :registered
		column :created_at
	end

	filter :email
	filter :registered

	show do |register|
		attributes_table do
			row :id
			row :email
			row :type_id do
				case register.type_id
				when 1 then "שוגר דדי"
				when 2 then "שוגר מאמי"
				when 3 then "שוגר בייב"
				when 4 then "שוגר בוי"
				end
			end
			row :registered
		end

		active_admin_comments
	end


	action_item :only => [:show] do
		if register.registered==0
			button_to "רשום משתמש ושלח דואר הרשמה", createuser_admin_register_path(register), :method => :post 
		end
	end

	member_action :createuser, :method => :post do
		register = Register.find(params[:id])
		if register.registered==0
			o = [('a'..'z'),(0..9)].map{ |i| i.to_a }.flatten
			pw = (0...4).map{ o[rand(o.length)]  }.join

			begin 
				user = User.create!({:email => register.email, :type_id => register.type_id, :password => pw})
				Profile.find_or_create_by_user_id_and_nickname(user.id, register.email[/[^@]+/])
				UserMailer.create_new_user_from_register(register, pw).deliver
				register.update_attribute(:registered, 1)
			rescue ActiveRecord::RecordInvalid => invalid
				logger.info "==================="
				logger.info invalid.record.errors.full_messages
				logger.info "==================="
			end

			redirect_to admin_registers_path, :notice => "ההודעה נשלחה למשתמש בכתובת #{register.email}"
		else
			redirect_to admin_registers_path, :notice => "המשתמש בכתובת #{register.email} כבר רשום"
		end
	end
end