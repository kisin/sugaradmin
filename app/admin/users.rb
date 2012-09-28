# encoding: UTF-8

ActiveAdmin.register User do
	menu :priority => 3, :label => "משתמשים"

	actions :all, :except => [:destroy]

	index do
		column :id do |user|
			link_to user.id, admin_user_path(user)
		end
		column :type
		column :email
		column :current_sign_in_at
		column :current_sign_in_ip
		column :created_at
		column :payed do |user|
			(user.payed == 0) ? "לא" : "כן"
		end

		default_actions
	end


	filter :type, :label => "סוג משתמש"
	filter :email
	filter :payed, :label => "משתמש שילם?", :as => :check_boxes, :collection => [["כן", 1], ["לא", 0]]
	filter :created_at


	show do |user|
		p = user.profile

		attributes_table do
			row :id
			row :created_at
			row :locked_at
			row :type
			row :profile do
				link_to p.displayname, admin_profile_path(p)
			end
			row :email
			row :sign_in_count
			row :current_sign_in_at
			row :last_sign_in_at
			row :current_sign_in_ip
			row :last_sign_in_ip
			row :payed
			row :last_payed_at
		end

		active_admin_comments
	end


	action_item :only => [:show] do
		if user.locked_at.nil?
			button_to "חסום משתמש", ban_admin_user_path(user), :method => :post
		else
			button_to "בטל חסימת משתמש", unban_admin_user_path(user), :method => :post
		end
	end

	action_item :only => [:show] do
		link_to "שלח דואר אלקטרוני", email_admin_user_path(user)
	end

	member_action :ban, :method => :post do
		user = User.find(params[:id])
      	user.ban!
      	redirect_to admin_user_path(user)
	end

	member_action :unban, :method => :post do
		user = User.find(params[:id])
      	user.unban!
      	redirect_to admin_user_path(user)
	end

	member_action :email, :method => :get do
	end

	member_action :sendemail, :method => :post do
		user = User.find(params[:id])
		emailmessage = Emailmessage.new(params[:emailmessage].merge({:name => user.profile.displayname}))

		if emailmessage.valid?
			UserMailer.new_message(emailmessage).deliver
			redirect_to admin_user_path(user), :notice => "ההודעה נשלחה למשתמש"
		else
			redirect_to email_admin_user_path(user), :notice => "אחד מהפרטים בטופס חסר. מלא את כל פרטי הטופס על מנת לשלוח אותו"
		end
	end

end
