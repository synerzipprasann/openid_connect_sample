class ApplicationController < ActionController::Base
  layout :set_layout
  
  include Authentication
  include Notification

  rescue_from HttpError do |e|
    render status: e.status, nothing: true
  end
  rescue_from FbGraph::Exception, Rack::OAuth2::Client::Error do |e|
    redirect_to root_url, flash: {error: e.message}
  end

  protect_from_forgery


  def after_sign_in_path_for(resource)
    # Customize the redirection logic here
    if resource.is_a?(Account)
      # Redirect to a specific page for signed-in users
      after_logged_in_endpoint
    else
      # For other types of resources, you can handle redirection differently
      super
    end
  end

  def after_logged_in_endpoint
    session.delete(:after_logged_in_endpoint) || dashboard_url
  end



  private

  def set_layout
    # Check if the controller is a Devise controller
    if is_devise_controller?
      'login' # Set your Devise-specific layout here
    else
      'application2'  # Set your default layout here
    end
  end

  def is_devise_controller?
    # Check if the controller's class is a subclass of Devise's controllers
    # You can add more Devise controllers if needed
    [
      Devise::SessionsController,
      Devise::RegistrationsController,
      Devise::PasswordsController,
      # Add more Devise controllers here as necessary
    ].any? { |controller| self.class <= controller }
  end
end
