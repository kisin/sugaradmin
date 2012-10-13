# encoding: UTF-8

class UserMailer < ActionMailer::Base
	default :from => "admin@mysugar.co.il"

	def new_message(message)
		@message = message
		
		mail(:to => @message.email, :subject => @message.subject)
	end

	def create_new_user_from_register(register, pw)
		@email = register.email
		@pw = pw
		@type = Type.find(register.type_id).title

		mail(:to => @email, :subject => "mysugar נפתח! ברוך בואך לאתר")
	end
end