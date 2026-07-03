class Api::V1::RecruiterDashboardController < ApplicationController
  before_action :authorize_request
  before_action :require_recruiter

  def index
    render json: {
      message: "Welcome to recruiter dashboard",
      user: {
        id: current_user.id,
        name: current_user.name,
        email: current_user.email,
        role: current_user.role
      }
    }
  end
end