class Company < ApplicationRecord
  belongs_to :recruiter,
  class_name: "User"

  validates :name, presence: true, uniqueness: true
  validates :website, presence: true
  validates :description, presence: true
end
