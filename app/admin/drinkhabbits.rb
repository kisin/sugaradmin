ActiveAdmin.register Drinkhabbit do
	menu false

	index do
		column :id
		column :title

		default_actions
	end
end
