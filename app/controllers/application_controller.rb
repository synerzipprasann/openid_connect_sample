class ApplicationController < ActionController::Base
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
end
