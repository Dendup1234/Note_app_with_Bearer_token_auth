class Api::V1::StudentResumesController < ApplicationController
  before_action :authorize_request
  before_action :require_student

  def show
    unless current_user.resume.attached?
      render json: {
        message: "No resume uploaded yet"
      }, status: :not_found
      return
    end

    render json: {
      resume: resume_json
    }, status: :ok
  end

  def update
    unless params[:resume].present?
      render json: {
        error: "Please upload a resume file"
      }, status: :unprocessable_entity
      return
    end

    current_user.resume.attach(params[:resume])

    if current_user.valid?
      render json: {
        message: "Resume uploaded successfully",
        resume: resume_json
      }, status: :ok
    else
      current_user.resume.purge
      render json: {
        errors: current_user.errors.full_messages
      }, status: :unprocessable_entity
    end
  end

  def destroy
    unless current_user.resume.attached?
      render json: {
        message: "No resume found"
      }, status: :not_found
      return
    end

    current_user.resume.purge

    render json: {
      message: "Resume deleted successfully"
    }, status: :ok
  end

  private

  def resume_json
    {
      filename: current_user.resume.filename.to_s,
      content_type: current_user.resume.content_type,
      byte_size: current_user.resume.byte_size,
      url: rails_blob_url(current_user.resume, only_path: false)
    }
  end
end