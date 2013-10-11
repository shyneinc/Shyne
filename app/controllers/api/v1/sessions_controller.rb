class Api::V1::SessionsController < Devise::SessionsController
    protect_from_forgery with: :null_session, :if => Proc.new { |c| c.request.format == 'application/vnd.shyne.v1' }

    def create
      resource = warden.authenticate!(:scope => resource_name, :recall => "#{controller_path}#failure")
      render :status => 200,
             :json => { :success => true,
                        :info => "Logged in",
                        :user => current_user
             }
    end

    def destroy
      warden.authenticate!(:scope => resource_name, :recall => "#{controller_path}#failure")
      sign_out
      render :status => 200,
             :json => { :success => true,
                        :info => "Logged out",
             }
    end

    def failure
      render :status => 401,
             :json => { :success => false,
                        :info => "Login Credentials Failed"
             }
    end

    def show_current_user
      warden.authenticate!(:scope => resource_name, :recall => "#{controller_path}#failure")
      render :status => 200,
             :json => { :success => true,
                        :info => "Current User",
                        :user => current_user
             }

    end
end