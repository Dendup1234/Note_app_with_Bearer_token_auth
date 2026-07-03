class Api::V1::RecruiterApplicationsController < ApplicationController
  before_action :authorize_request
  before_action :require_recruiter
  before_action :ensure_company_exists
  before_action :set_internship, only: [:index]
  before_action :set_application, only: %i[show update_status]

  def index
    applications = @internship.applications
                              .includes(:student)
                              .order(created_at: :desc)

    render json: {
      internship: {
        id: @internship.id,
        title: @internship.title
      },
      applications: applications.map { |application| application_json(application) }
    }, status: :ok
  end

  def show
    render json: {
      application: application_json(@application)
    }, status: :ok
  end

  def update_status
    new_status = params[:status]

    unless Application.statuses.key?(new_status)
      render json: {
        error: "Invalid application status"
      }, status: :unprocessable_entity
      return
    end

    if @application.withdrawn?
      render json: {
        error: "Cannot update a withdrawn application"
      }, status: :unprocessable_entity
      return
    end

    if @application.update(
      status: new_status,
      status_changed_by: current_user,
      status_changed_at: Time.current
    )
      render json: {
        message: "Application status updated successfully",
        application: application_json(@application)
      }, status: :ok
    else
      render json: {
        errors: @application.errors.full_messages
      }, status: :unprocessable_entity
    end
  end

  private

  def ensure_company_exists
    return if current_user.company.present?

    render json: {
      error: "Please create your company profile first"
    }, status: :unprocessable_entity
  end

  def set_internship
    @internship = current_user.company.internships.find_by(id: params[:internship_id])

    return if @internship

    render json: {
      error: "Internship not found"
    }, status: :not_found
  end

  def set_application
    @application = Application
                   .includes(:student, internship: :company)
                   .joins(:internship)
                   .where(internships: { company_id: current_user.company.id })
                   .find_by(id: params[:id])

    return if @application

    render json: {
      error: "Application not found"
    }, status: :not_found
  end

  def application_json(application)
    {
      id: application.id,
      cover_note: application.cover_note,
      status: application.status,
      status_changed_at: application.status_changed_at,
      created_at: application.created_at,
      student: {
        id: application.student.id,
        name: application.student.name,
        email: application.student.email,
        bio: application.student.bio,
        college: application.student.college,
        graduation_year: application.student.graduation_year,
        resume_uploaded: application.student.resume.attached?,
        resume_url: resume_url(application.student)
      },
      internship: {
        id: application.internship.id,
        title: application.internship.title,
        location: application.internship.location,
        mode: application.internship.mode
      },
      status_changed_by: status_changed_by_json(application)
    }
  end

  def resume_url(student)
    return nil unless student.resume.attached?

    rails_blob_url(student.resume, only_path: false)
  end

  def status_changed_by_json(application)
    return nil unless application.status_changed_by

    {
      id: application.status_changed_by.id,
      name: application.status_changed_by.name,
      email: application.status_changed_by.email,
      role: application.status_changed_by.role
    }
  end
end