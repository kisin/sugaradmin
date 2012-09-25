# encoding: UTF-8

class Message < ActiveRecord::Base
	belongs_to :user_to, :foreign_key => "to_id", :class_name => "User"
	belongs_to :user_from, :foreign_key => "from_id", :class_name => "User"

	before_create :filter_html
	after_create :send_email

	validates :content, :presence => true
	validate :cannot_send_or_recieve_from_blocked_users, :on => :create
	validate :cannot_message_user_with_the_same_age_type
	validate :cannot_send_too_quickly_to_same_user, :on => :create

	#scopes
	default_scope where("deleted = 0").order('messages.id desc')
	scope :original, where(:copy => 0)
	scope :copy, where(:copy => 1)
	scope :news, where("read_at is null")
	scope :olds, where("read_at is not null")
	scope :inbox, lambda { |id| where("to_id = ?", id) }
	scope :outbox, lambda { |id| where("from_id = ?", id) }



	def is_copy?
		return true if copy == 1
		false
	end

	def is_original?
		return true if copy == 0
		false
	end

	def is_deleted?
		return true if deleted == 1
		false
	end

	def is_new?
		return true if read_at == nil
		false
	end

	def belongs_to_user?(user_id)
		return true if (is_original? && to_id==user_id) || (is_copy? && from_id==user_id)
		false
	end

	def self.counter(user_id, folder = "inbox")
		m = Message.news.original
		m = (folder == "inbox") ? m.inbox(user_id) : m.outbox(user_id)

		messages_count = m.count
	end


private

	def filter_html
		self.content.gsub(/<.*>/m, "") unless self.content.nil?
	end

	def send_email
		UserMailer.msg(self.from_id, self.to_id, self.id).deliver unless self.is_copy?
	end

	def cannot_send_or_recieve_from_blocked_users
		errors[:base] << "חסמת את המשתמש ולכן אינך יכול לשלוח אליו הודעה" unless Block.where("user_id = ? AND blocked_id = ?", from_id, to_id).blank?
		errors[:base] << "המשתמש חסם אותך ולכן אינך יכול לשלוח אליו הודעות" unless Block.where("blocked_id = ? AND user_id = ?", from_id, to_id).blank?
	end

	def cannot_message_user_with_the_same_age_type
		from_user = User.find(from_id)
		to_user  = User.find(to_id)

		if (from_user.is_old? == to_user.is_old?)
			errors.add(:base, "אי אפשר לשלוח הודעה למשתמש באותה קבוצת גיל כמוך")
		end
	end

	def cannot_send_too_quickly_to_same_user
		#find last message sent to user
		message = Message
						.where('messages.created_at > ?', Time.now - 1.minutes)
						.where('messages.read_at IS NULL')
						.find_by_from_id_and_to_id(from_id, to_id)

		unless message.nil?
			errors.add(:base, "עליך להמתין דקה אחת לפני שתוכל לשלוח עוד הודעה לאותו המשתמש")
		end
	end
 
end
