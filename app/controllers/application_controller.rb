class ApplicationController < ActionController::Base
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern

  # Changes to the importmap will invalidate the etag for HTML responses
  stale_when_importmap_changes
  protect_from_forgery with: :null_session

  private

  def authorize_request
    header = request.headers["Authorization"]

    if header.blank?
      render json: { error: "Missing token" }, status: :unauthorized
      return
    end

    token = header.split(" ").last
    decoded = JsonWebToken.decode(token)

    if decoded.nil?
      render json: { error: "Invalid or expired token" }, status: :unauthorized
      return
    end

    @current_user = User.find_by(id: decoded[:user_id])

    unless @current_user
      render json: { error: "User not found" }, status: :unauthorized
    end
  end

  def current_user
    @current_user
  end

  def require_student
    unless current_user&.student?
      render json: { error: "Only students can access this page" }, status: :forbidden
    end
  end

  def require_recruiter
    unless current_user&.recruiter?
      render json: { error: "Only recruiters can access this page" }, status: :forbidden
    end
  end
end
