class Payment < ActiveRecord::Base
	belongs_to :user
	serialize :params
	after_create :mark_user_as_payed



private

	def mark_user_as_payed
		if status == "Completed"
			user.update_attribute(:payed, 1)

			ContactMailer.money_mail.deliver
		end

	end

end
