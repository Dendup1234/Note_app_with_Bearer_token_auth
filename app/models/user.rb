class User < ApplicationRecord
  has_secure_password

  has_one_attached :resume

  enum :role, {
    student: 0,
    recruiter: 1
  }
  has_one :company,
        foreign_key: :recruiter_id,
        dependent: :destroy
        
  has_many :applications,
         foreign_key: :student_id,
         dependent: :destroy

  validates :name, presence: true
  validates :email, presence: true, uniqueness: true
  validates :password, length: { minimum: 6 }, if: -> { password.present? }
  validates :role, presence: true

  validate :resume_must_be_pdf
  validate :resume_size_must_be_less_than_5_mb

  private

  def resume_must_be_pdf
    return unless resume.attached?

    return if resume.content_type == "application/pdf"

    errors.add(:resume, "must be a PDF file")
  end

  def resume_size_must_be_less_than_5_mb
    return unless resume.attached?

    return if resume.byte_size <= 5.megabytes

    errors.add(:resume, "must be less than 5 MB")
  end
end
