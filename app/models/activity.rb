class Activity < ApplicationRecord
  belongs_to :project
  validates :name, :begin, :end, presence: { message: "não pode estar em branco"}
  validates :name, uniqueness: { message: "tem que ser única"}
  scope :due, -> { where(finished: false).order(end: :desc) }
  scope :finished, -> { where(finished: true) }
end
