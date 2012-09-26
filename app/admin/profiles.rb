# encoding: UTF-8

ActiveAdmin.register Profile do
	menu false

	member_action :back, :method => :get do
		redirect_to "#"
	end

	action_item :only => :show do
		link_to "חזרה לצפייה בפרטי המשתמש", admin_user_path(profile.user.id), :class => "info"
	end
end