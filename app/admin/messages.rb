ActiveAdmin.register Message do
	menu :priority => 4, :label => proc{ I18n.t("active_admin.messages") } 

	index do
		column :id
		column :content
		column :created_at
		column :read_at
		column :copy
		column :deleted

		default_actions
	end

end
