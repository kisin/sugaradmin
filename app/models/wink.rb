# encoding: UTF-8

class Wink < ActiveRecord::Base
	belongs_to :user
	belongs_to :user_winked, :foreign_key => "wink_id", :class_name => "User"

	default_scope order("winks.id desc")

	validates 	:user_id, :numericality => { :only_integer => true }
	validates 	:wink_id, :numericality => { :only_integer => true }
	validate 	:cannot_wink_yourself,
				:cannot_wink_user_that_you_already_winked,
				:cannot_wink_user_you_blocked,
				:cannot_wink_if_user_not_payed,
				:cannot_wink_user_with_the_same_age_type



	#custom validators
	def cannot_wink_yourself
		if user_id == wink_id
			errors.add(:base, "אי אפשר לקרוץ לעצמך")
		end
	end

	def cannot_wink_user_that_you_already_winked
		unless Wink.find_by_user_id_and_wink_id(user_id, wink_id).nil?
			errors.add(:base, "כבר קרצת למשתמש הזה בלי שהוא הגיב לקריצה")
		end
	end

	def cannot_wink_user_you_blocked
		user_blocked = !Block.where("blocks.user_id = :user_id AND blocks.blocked_id = :blocked_id", {:user_id => user_id, :blocked_id => wink_id}).empty?
		if user_blocked
			errors.add(:base, "אי אפשר לקרוץ למשתמש שחסמת")
		end
	end

	def cannot_wink_if_user_not_payed
		if user.not_payed?
			errors.add(:base, "על מנת לקרוץ למשתמשים עליך לשדרג את חשבונך")
		end
	end

	#user cant wink user on the same age type (old or kid)
	def cannot_wink_user_with_the_same_age_type
		winking_user = User.find(user_id)
		winked_user  = User.find(wink_id)

		if (winking_user.is_old? == winked_user.is_old?)
			errors.add(:base, "אי אפשר לקרוץ למשתמש באותה קבוצת גיל כמוך")
		end
	end

end
