class Favorite < ActiveRecord::Base
  belongs_to :user
  belongs_to :user_fav, :foreign_key => "faved_id", :class_name => "User"

  validates :user_id,   :numericality => { :only_integer => true }
  validates :faved_id, :numericality => { :only_integer => true }
end
