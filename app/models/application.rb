class Application < ApplicationRecord
  belongs_to :student, class_name: "User"
  belongs_to :internship
  belongs_to :status_changed_by,
             class_name: "User",
             optional: true

  enum :status, {
    submitted: 0,
    shortlisted: 1,
    rejected: 2,
    hired: 3,
    withdrawn: 4
  }

  validates :cover_note, presence: true
  validates :status, presence: true
  validates :student_id, uniqueness: { scope: :internship_id }

  validate :student_must_be_student_role

  private

  def student_must_be_student_role
    return if student&.student?

    errors.add(:student, "must be a student")
  end
end