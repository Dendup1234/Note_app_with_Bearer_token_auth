class Api::V1::CompaniesController < ApplicationController
  before_action :authorize_request
  before_action :require_recruiter
  before_action :set_company, only: %i[show update]

  def show
    if @company
      render json: {
        company: company_json(@company)
      }, status: :ok
    else
      render json: {
        message: "Company profile not created yet"
      }, status: :not_found
    end
  end

  def create
    if current_user.company.present?
      render json: {
        error: "Company profile already exists"
      }, status: :unprocessable_entity
      return
    end

    company = current_user.build_company(company_params)

    if company.save
      render json: {
        message: "Company created successfully",
        company: company_json(company)
      }, status: :created
    else
      render json: {
        errors: company.errors.full_messages
      }, status: :unprocessable_entity
    end
  end

  def update
    unless @company
      render json: {
        error: "Company profile not found"
      }, status: :not_found
      return
    end

    if @company.update(company_params)
      render json: {
        message: "Company updated successfully",
        company: company_json(@company)
      }, status: :ok
    else
      render json: {
        errors: @company.errors.full_messages
      }, status: :unprocessable_entity
    end
  end

  private

  def set_company
    @company = current_user.company
  end

  def company_params
    params.permit(:name, :website, :description)
  end

  def company_json(company)
    {
      id: company.id,
      name: company.name,
      website: company.website,
      description: company.description,
      recruiter_id: company.recruiter_id
    }
  end
end