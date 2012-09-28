class UserMailer < ActionMailer::Base
	default :from => "admin@mysugar.co.il"

	def new_message(message)
		@message = message
		mail(:subject => @message.subject)
	end
end