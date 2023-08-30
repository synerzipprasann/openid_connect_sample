class Api::V1::UsersController < Api::V1::AuthorizationController

  before_filter :get_fake
  def create
  end

  def update
    begin
      if @fake.update_attributes(params[:users])
        #render json:{ users: @fake.as_json(excect: [:password])}, status: :ok, root: 'users'
        render json: { users: @fake.attributes.except('password') }, status: :ok
      else
        render json: {errors: @fake.errors.full_messages}, status: :unprocessable_entity
      end
    rescue StandardError => e
      render json: {error: e.message}, status: :unprocessable_entity
    end
  end

  private

  def get_fake
    @fake ||= current_token.account.fake
  end
end
