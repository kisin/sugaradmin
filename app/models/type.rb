class Type < ActiveRecord::Base
	has_one :user

	def price?
		return true if self.price>0
		false
	end
end