ActiveAdmin.register Payment do
	menu false
	config.sort_order = "created_at_desc"


	index do
		column :id do |payment|
			link_to payment.id, admin_payment_path(payment)
		end
		column :user_id
		column :status
		column :transaction_id
		column :params
		column :created_at
	end


	show do |payment|
		attributes_table do
			row :id
			row :status
			row :user do
				link_to payment.user.email, admin_user_path(payment.user)
			end
			row :transaction_id do
				payment.transaction_id
			end
			row :created_at
			row :updated_at
		end

		active_admin_comments
	end
end
