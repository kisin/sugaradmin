ActiveAdmin.register Smokehabbit do
	menu false

	index do
		column :id
		column :title

		default_actions
	end
end
