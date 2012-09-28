class Emailmessage
	include ActiveModel::Validations
	include ActiveModel::Conversion
	include ActiveModel::Naming

	attr_accessor :subject, :body, :name, :email

	validates :subject, :body, :presence => true

	def initialize(attributes = {})
		attributes.each do |name, value|
			send("#{name}=", value)
		end
	end

	def persisted?
		false
	end
  
end