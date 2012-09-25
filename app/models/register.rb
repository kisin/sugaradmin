class Register < ActiveRecord::Base
	before_create :build_secret


private

	def build_secret
		o = [('a'..'z'),('A'..'Z'),(0..9)].map{ |i| i.to_a }.flatten
		self.secret = (0..30).map{ o[rand(o.length)]  }.join if self.secret.nil?
	end
end