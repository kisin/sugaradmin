# encoding: UTF-8

ActiveAdmin.register Asset do
	menu :priority => 5, :label => "תמונות"

	index do
		column :id
		column :pic do |asset|
			image_tag asset.item.url(:small), :class => "thumbnail"
		end
		column :item_file_name
		column :item_content_type
		column :item_file_size
		column :created_at
	end
end
