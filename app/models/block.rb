# encoding: UTF-8

class Block < ActiveRecord::Base
	belongs_to :user
	belongs_to :user_blocked, :foreign_key => "blocked_id", :class_name => "User"

	validates 	:user_id,       :numericality => { :only_integer => true }
	validates 	:blocked_id, :numericality => { :only_integer => true }
	validate 	:cannot_block_yourself,
				:cannot_block_if_user_not_payed,
				:cannot_block_user_you_already_blocked,
				:cannot_block_user_with_the_same_age_type


	#custom validators
	def cannot_block_yourself
		if user_id == blocked_id
			errors.add(:base, "אי אפשר לחסום את עצמך")
		end
	end

	def cannot_block_if_user_not_payed
		if user.not_payed?
			errors.add(:base, "על מנת לחסום משתמשים עליך לשדרג את חשבונך")
		end
	end

	def cannot_block_user_you_already_blocked
		unless Block.find_by_user_id_and_blocked_id(user_id, blocked_id).nil?
			errors.add(:base, "כבר חסמת בעבר את המשתמש הזה")
		end
	end

	#user cant block user on the same age type (old or kid)
	def cannot_block_user_with_the_same_age_type
		blocking_user = User.find(user_id)
		blocked_user	 = User.find(blocked_id)

		if (blocking_user.is_old? == blocked_user.is_old?)
			errors.add(:base, "אי אפשר לחסום משתמש באותה קבוצת גיל כמוך")
		end
	end

end
