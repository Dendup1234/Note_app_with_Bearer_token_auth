class Internship < ApplicationRecord
  belongs_to :company
  enum :mode, {
    remote: 0,
    on_site: 1,
    hybrid: 2
  }

  enum :status, {
    open: 0,
    closed: 1
  }

  validates :title, presence: true
  validates :description, presence: true
  validates :location, presence: true
  validates :mode, presence: true
  validates :duration_weeks, presence: true, numericality: { greater_than: 0 }
  validates :monthly_stipend, presence: true, numericality: { greater_than_or_equal_to: 0 }
  validates :application_deadline, presence: true
  validates :status, presence: true

  def closed_for_applications?
    closed? || application_deadline < Date.current
  end
end
