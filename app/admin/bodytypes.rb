ActiveAdmin.register Bodytype do
	menu false
	config.sort_order = "title_asc"

	index do
		column :id
		column :title

		default_actions
	end

	filter :title
end
