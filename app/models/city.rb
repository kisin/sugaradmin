class City < ActiveRecord::Base
  has_one :profile

  default_scope order(:title)
end
