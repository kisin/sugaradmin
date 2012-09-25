# encoding: UTF-8

include ActionView::Helpers::DateHelper

class User < ActiveRecord::Base
	# Include default devise modules. Others available are:
	# :confirmable, :token_authenticatable, :encryptable, :confirmable, :lockable, :timeoutable and :omniauthable
	devise :database_authenticatable, :registerable,
	       :recoverable, :rememberable, :trackable, :validatable
	       

	# Setup accessible (or protected) attributes for your model
	attr_accessible :email, :password, :password_confirmation, :remember_me, :type_id, :profile_attributes


	has_one :profile, :dependent => :destroy
	has_many :payments, :dependent => :destroy
	has_many :blocks, :dependent => :destroy
	has_many :favorites, :dependent => :destroy
	has_many :messages_sent, :class_name => "Message", :foreign_key => "from_id", :conditions => "copy = 1", :dependent => :destroy
	has_many :messages_inbox, :class_name => "Message", :foreign_key => "to_id", :conditions => "copy = 0", :dependent => :destroy
	has_many :watched_at, :class_name => "Watcher", :foreign_key => "user_id", :dependent => :destroy
	has_many :watched_me, :class_name => "Watcher", :foreign_key => "watch_id", :dependent => :destroy
	has_many :winked_at, :class_name => "Wink", :foreign_key => "user_id", :dependent => :destroy
	has_many :winked_me, :class_name => "Wink", :foreign_key => "wink_id", :dependent => :destroy
	has_many :assets, :dependent => :destroy
	belongs_to :type

	accepts_nested_attributes_for :profile

	validates :type_id, :numericality => { :only_integer => true }


	#scopes
	scope :olds, where(:type_id => [1,2])
	scope :kids, where(:type_id => [3,4])
	scope :payed, where(:payed => 1)
	scope :online, lambda { where('users.updated_at > ?', Time.now - 5.minutes) }




	# user is considerd new if its his first login and he is no more then 2 minutes in the site
	def new?
		return true if sign_in_count < 2 && Time.now-created_at < 2*60
		false
	end

	def is_kid?
		return true if [3,4].include?(type_id)
		false
	end

	def is_old?
		return true if [1,2].include?(type_id)
		false
	end

	def is_payed?
		return true unless ((payed.nil? || payed == 0) && type.price>0)
		false
	end

	def is_payed_now?
		return true if !last_payed_at.nil? && Time.now-last_payed_at < 1*60
	end

	def not_payed?
		!is_payed?
	end

	def male?
		return true if [1,4].include?(type_id)
		false
	end

	def female?
		return true if [2,3].include?(type_id)
		false
	end

	def online?
		return true if updated_at.to_i > (Time.now - 5.minutes).to_i
		false
	end

	def can_wink?(user_id)
		return winked_me.where("winks.user_id = :user_id AND winks.read_at IS NULL", {:user_id => user_id}).empty?
	end

	def messages_count
		count = 	Rails.cache.fetch("/messages_count/#{id}") do
						messages_inbox.where("messages.read_at IS NULL").count
					end
		return "99+" if count > 100
		count
	end

	def winks_count
		count =	Rails.cache.fetch("/winks_count/#{id}") do
						winked_me.where("winks.read_at IS NULL").count
					end
		return "99+" if count > 100
		count
	end

	def views_count
		count =	Rails.cache.fetch("/views_count/#{id}") do
						watched_me.where("watchers.read_at IS NULL").count
					end
		return "99+" if count > 100
		count
	end

	def blocks_count
		count =	Rails.cache.fetch("/blocks_count/#{id}") do
						blocks.count
					end
		return "99+" if count > 100
		count
	end

	def blocked(block_id)
		return !blocks.where("blocks.blocked_id = :block_id", {:block_id => block_id.to_i}).empty?
	end

	def assets_count
		count =	Rails.cache.fetch("/assets_count/#{id}") do
						assets.count
					end
		return "99+" if count > 100
		count
	end

	def random_to_user(count = 5)
		case type_id
		when 1
			user_type_id = 3
		when 2
			user_type_id = 4
		when 3
			user_type_id = 1
		when 4
			user_type_id = 2
		else
			user_type_id = 3
		end
 
		return Rails.cache.fetch("/random_to_user/#{type_id}", :expires_in => 1.hour) do
					User.select("users.id AS user_id, assets.id AS asset_id, assets.access_token")
						.where("users.type_id=:user_type_id AND profiles.hasimages=1 AND assets.is_primary=1", {:user_type_id => user_type_id})
						.joins(:profile)
						.joins("LEFT JOIN assets ON assets.user_id=users.id")
						.limit(count.to_i)
						.order("users.last_sign_in_at DESC").all
				end
	end


	#presenters
	def gender
		return "זכר" if male?
		"נקבה"
	end

	def last_seen
		return "עדיין לא נראה באתר" if current_sign_in_at.blank?
		return "לפני #{time_ago_in_words(updated_at)}" if current_sign_in_at < 3.minutes.ago
		"ברגעים אלו"
	end

end
