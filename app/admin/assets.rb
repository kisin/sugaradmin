# encoding: UTF-8

ActiveAdmin.register Asset do
	menu :priority => 5, :label => "תמונות"

	actions :all, :except => [:edit]

	index do
		column :id
		column :picture do |asset|
			link_to image_tag(asset.item.url(:small), :class => "thumbnail"), asset.item.url, :target => "_blank"
		end
		column :user
		column :primary do |asset|
			(asset.primary?) ? raw("<strong>ראשית</strong>") : "רגילה"
		end
		column :item_file_name
		column :item_content_type
		column :item_file_size
		column :created_at

		default_actions
	end

	filter :is_primary, :label => "סוג תמונה", :as => :check_boxes, :collection => [["ראשית", 1], ["רגילה", 0]]
	filter :item_content_type
	filter :item_file_size
	filter :created_at


end
