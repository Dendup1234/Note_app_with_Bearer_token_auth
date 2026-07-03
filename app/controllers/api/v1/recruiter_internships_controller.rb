class Api::V1::RecruiterInternshipsController < ApplicationController
  before_action :authorize_request
  before_action :require_recruiter
  before_action :ensure_company_exists
  before_action :set_internship, only: %i[show update close destroy]

  def index
    internships = current_user.company.internships.order(created_at: :desc)

    render json: {
      internships: internships.map { |internship| internship_json(internship) }
    }, status: :ok
  end

  def show
    render json: {
      internship: internship_json(@internship)
    }, status: :ok
  end

  def create
    internship = current_user.company.internships.build(internship_params)
    internship.status = :open

    if internship.save
      render json: {
        message: "Internship created successfully",
        internship: internship_json(internship)
      }, status: :created
    else
      render json: {
        errors: internship.errors.full_messages
      }, status: :unprocessable_entity
    end
  end

  def update
    if @internship.update(internship_params)
      render json: {
        message: "Internship updated successfully",
        internship: internship_json(@internship)
      }, status: :ok
    else
      render json: {
        errors: @internship.errors.full_messages
      }, status: :unprocessable_entity
    end
  end

  def close
    if @internship.update(status: :closed)
      render json: {
        message: "Internship closed successfully",
        internship: internship_json(@internship)
      }, status: :ok
    else
      render json: {
        errors: @internship.errors.full_messages
      }, status: :unprocessable_entity
    end
  end

  def destroy
    @internship.destroy

    render json: {
      message: "Internship deleted successfully"
    }, status: :ok
  end

  private

  def ensure_company_exists
    return if current_user.company.present?

    render json: {
      error: "Please create your company profile before posting internships"
    }, status: :unprocessable_entity
  end

  def set_internship
    @internship = current_user.company.internships.find_by(id: params[:id])

    return if @internship

    render json: {
      error: "Internship not found"
    }, status: :not_found
  end

  def internship_params
    params.permit(
      :title,
      :description,
      :location,
      :mode,
      :duration_weeks,
      :monthly_stipend,
      :application_deadline
    )
  end

  def internship_json(internship)
    {
      id: internship.id,
      title: internship.title,
      description: internship.description,
      location: internship.location,
      mode: internship.mode,
      duration_weeks: internship.duration_weeks,
      monthly_stipend: internship.monthly_stipend,
      application_deadline: internship.application_deadline,
      status: internship.status,
      closed_for_applications: internship.closed_for_applications?,
      company: {
        id: internship.company.id,
        name: internship.company.name
      }
    }
  end
end