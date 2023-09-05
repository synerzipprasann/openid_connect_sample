class TopController < ApplicationController
  before_filter :authenticate_account!
  #before_filter :require_anonymous_access

  def index
  end
end
