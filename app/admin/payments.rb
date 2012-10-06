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
end
