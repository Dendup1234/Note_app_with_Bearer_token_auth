class Api::V1::AuthController < ApplicationController
  skip_before_action :verify_authenticity_token

  def register
    user = User.new(register_params)

    if user.save
      token = JsonWebToken.encode(
        user_id: user.id,
        email: user.email,
        role: user.role
      )

      render json: {
        message: "Registered successfully",
        token: token,
        user: {
          id: user.id,
          name: user.name,
          email: user.email,
          role: user.role
        }
      }, status: :created
    else
      render json: {
        errors: user.errors.full_messages
      }, status: :unprocessable_entity
    end
  end

  def login
    user = User.find_by(email: params[:email])

    if user&.authenticate(params[:password])
      token = JsonWebToken.encode(
        user_id: user.id,
        email: user.email,
        role: user.role
      )

      render json: {
        message: "Login successful",
        token: token,
        user: {
          id: user.id,
          name: user.name,
          email: user.email,
          role: user.role
        }
      }, status: :ok
    else
      render json: {
        error: "Invalid email or password"
      }, status: :unauthorized
    end
  end

  private

  def register_params
    params.permit(:name, :email, :password, :password_confirmation, :role)
  end
end