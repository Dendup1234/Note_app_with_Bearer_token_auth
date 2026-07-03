class Api::V1::StudentProfilesController < ApplicationController
  before_action :authorize_request
  before_action :require_student

  def show
    render json: {
      user: student_json(current_user)
    }, status: :ok
  end

  def update
    if current_user.update(student_profile_params)
      render json: {
        message: "Profile updated successfully",
        user: student_json(current_user)
      }, status: :ok
    else
      render json: {
        errors: current_user.errors.full_messages
      }, status: :unprocessable_entity
    end
  end

  private

  def student_profile_params
    params.permit(:name, :bio, :college, :graduation_year)
  end

  def student_json(user)
    {
      id: user.id,
      name: user.name,
      email: user.email,
      role: user.role,
      bio: user.bio,
      college: user.college,
      graduation_year: user.graduation_year
    }
  end
end
