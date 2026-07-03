class Company < ApplicationRecord
  belongs_to :recruiter,
  class_name: "User"

  has_many :internships, dependent: :destroy
  
  validates :name, presence: true, uniqueness: true
  validates :website, presence: true
  validates :description, presence: true
end
