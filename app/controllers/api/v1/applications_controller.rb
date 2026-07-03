class Api::V1::ApplicationsController < ApplicationController
  before_action :authorize_request
  before_action :require_student
  before_action :set_application, only: [:withdraw]

  def index
    applications = current_user.applications
                               .includes(internship: :company)
                               .order(created_at: :desc)

    render json: {
      applications: applications.map { |application| application_json(application) }
    }, status: :ok
  end

  def create
    internship = Internship.find_by(id: params[:internship_id])

    unless internship
      render json: { error: "Internship not found" }, status: :not_found
      return
    end

    if internship.closed_for_applications?
      render json: { error: "This internship is closed for applications" }, status: :unprocessable_entity
      return
    end

    unless current_user.resume.attached?
      render json: { error: "Please upload your resume before applying" }, status: :unprocessable_entity
      return
    end

    application = current_user.applications.build(
      internship: internship,
      cover_note: params[:cover_note],
      status: :submitted,
      status_changed_at: Time.current
    )

    if application.save
      render json: {
        message: "Application submitted successfully",
        application: application_json(application)
      }, status: :created
    else
      render json: {
        errors: application.errors.full_messages
      }, status: :unprocessable_entity
    end
  end

  def withdraw
    if @application.hired? || @application.rejected?
      render json: {
        error: "You cannot withdraw an application that is already hired or rejected"
      }, status: :unprocessable_entity
      return
    end

    if @application.update(status: :withdrawn, status_changed_at: Time.current)
      render json: {
        message: "Application withdrawn successfully",
        application: application_json(@application)
      }, status: :ok
    else
      render json: {
        errors: @application.errors.full_messages
      }, status: :unprocessable_entity
    end
  end

  private

  def set_application
    @application = current_user.applications.find_by(id: params[:id])

    return if @application

    render json: { error: "Application not found" }, status: :not_found
  end

  def application_json(application)
    {
      id: application.id,
      cover_note: application.cover_note,
      status: application.status,
      status_changed_at: application.status_changed_at,
      created_at: application.created_at,
      internship: {
        id: application.internship.id,
        title: application.internship.title,
        location: application.internship.location,
        mode: application.internship.mode,
        company: {
          id: application.internship.company.id,
          name: application.internship.company.name
        }
      }
    }
  end
end