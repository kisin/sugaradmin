ActiveAdmin.register Haircolor do
	menu false

	index do
		column :id
		column :title

		default_actions
	end
end
