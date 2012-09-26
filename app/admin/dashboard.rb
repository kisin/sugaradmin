# encoding: UTF-8

ActiveAdmin.register_page "Dashboard" do

	menu :priority => 1, :label => proc{ I18n.t("active_admin.dashboard") }

	content :title => proc{ I18n.t("active_admin.dashboard") } do

		div :class => "blank_container" do
			@count = { 
							:users => User.count,
							:users_payed => User.payed.count,
							:messages => Message.count,
							:winks => Wink.count,
							:assets => Asset.count,
							:blocks => Block.count
						}

			render :partial => "stats", :locals => { :count => @count }
		end

		columns do
			column do
				panel I18n.t("active_admin.recent_users") do
					@users = User.order("users.created_at DESC").limit(10)
					render :partial => "recent_users", :locals => { :users => @users }
				end
			end

			column do
				panel I18n.t("active_admin.recent_messages") do
					@messages = Message.original.limit(10)
					render :partial => "recent_messages", :locals => { :messages => @messages }
				end
			end
		end
	end


	sidebar :information_tables do
		ul :class => "table_links" do
			li link_to "הכנסה שנתית", admin_annualincomes_path
			li link_to "מבנה גוף", admin_bodytypes_path
			li link_to "תקציב", admin_budgets_path
			li link_to "עיר", admin_cities_path
			li link_to "הרגל שתייה", admin_drinkhabbits_path
			li link_to "השכלה", admin_educations_path
			li link_to "סוג עיניים", admin_eyecolors_path
			li link_to "מצב משפחתי", admin_familystatuses_path
			li link_to "סוג שיער", admin_haircolors_path
			li link_to "גובה", admin_heights_path
			li link_to "איזור", admin_regions_path
			li link_to "הרגל עישון", admin_smokehabbits_path
		end
	end


  #content :title => proc{ I18n.t("active_admin.dashboard") } do
   # div :class => "blank_slate_container", :id => "dashboard_default_message" do
    #  span :class => "blank_slate" do
     #   span "Welcome to Active Admin. This is the default dashboard page."
      #  small "To add dashboard sections, checkout 'app/admin/dashboards.rb'"
      #end
    #end

    # Here is an example of a simple dashboard with columns and panels.
    #
    # columns do
    #   column do
    #     panel "Recent Posts" do
    #       ul do
    #         Post.recent(5).map do |post|
    #           li link_to(post.title, admin_post_path(post))
    #         end
    #       end
    #     end
    #   end

    #   column do
    #     panel "Info" do
    #       para "Welcome to ActiveAdmin."
    #     end
    #   end
    # end
  #end # content
end
