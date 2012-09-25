class Watcher < ActiveRecord::Base
	belongs_to :user
	belongs_to :user_watch, :foreign_key => "watch_id", :class_name => "User" 

	default_scope :order => "created_at DESC"

	def activity_user(uid)
		return user if watch_id == uid
		user_watch
	end

	def self.count_watched_at(id)
		self.where("user_id = ?", id).count
	end

	def self.count_watched_by(id)
		self.where("watch_id = ?", id).count
	end

end
