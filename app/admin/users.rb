# encoding: UTF-8

ActiveAdmin.register User do
	menu :priority => 3, :label => "משתמשים"

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


	action_item :only => :show do
	end
end
