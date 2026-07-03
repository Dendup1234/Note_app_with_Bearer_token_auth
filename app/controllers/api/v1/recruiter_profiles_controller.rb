class Api::V1::RecruiterProfilesController < ApplicationController
  before_action :authorize_request
  before_action :require_recruiter
  
  def show
    render json: {
      user: recruiter_json(current_user)
    }, status: :ok

  end

  def update
    if current_user.update(recruiter_profile_params)
      render json: {
        message: "Recruiter profile updated successfully",
        user: recruiter_json(current_user)
      }, status: :ok
    else
      render json: {
        errors: current_user.errors.full_messages
      }, status: :unprocessable_entity
    end
  end

  def recruiter_profile_params
    params.permit(:name)
  end

  def recruiter_json(user)
    {
      id: user.id,
      name: user.name,
      email: user.email,
      role: user.role
    }
  end
end
