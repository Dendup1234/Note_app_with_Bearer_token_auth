class Api::V1::InternshipsController < ApplicationController
  def index
    internships = Internship.includes(:company)
                            .where(status: :open)
                            .where("application_deadline >= ?", Date.current)
                            .order(created_at: :desc)

    internships = internships.where(location: params[:location]) if params[:location].present?
    internships = internships.where(mode: params[:mode]) if params[:mode].present?

    render json: {
      internships: internships.map { |internship| internship_json(internship) }
    }, status: :ok
  end

  def show
    internship = Internship.includes(:company).find_by(id: params[:id])

    unless internship
      render json: { error: "Internship not found" }, status: :not_found
      return
    end

    render json: {
      internship: internship_json(internship)
    }, status: :ok
  end

  private

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
        name: internship.company.name,
        website: internship.company.website,
        description: internship.company.description
      }
    }
  end
end