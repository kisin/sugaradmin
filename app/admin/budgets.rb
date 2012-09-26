ActiveAdmin.register Budget do
	menu false

	index do
		column :id
		column :title

		default_actions
	end

	filter :title
end
