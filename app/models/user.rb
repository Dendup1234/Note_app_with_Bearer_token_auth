class User < ApplicationRecord
  has_secure_password
  
  enum :role, {
    student: 0,
    recruiter: 1
  }

  validates :name, presence: true
  validates :email, presence: true, uniqueness: true
  validates :password, length: { minimum: 6 }, if: -> { password.present? }
  validates :role, presence: true
end
