if Rails.env == "development"
  activeadmin_reloader = ActiveSupport::FileUpdateChecker.new(Dir["app/admin/**/*"], true) do

    ActiveAdmin.application.unload!
    Rails.application.reload_routes!
  end

  ActionDispatch::Callbacks.to_prepare do
    activeadmin_reloader.execute_if_updated
  end
end