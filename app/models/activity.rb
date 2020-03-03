class Activity < ApplicationRecord
  belongs_to :project
  validates :name, :begin, :end, presence: { message: "não pode estar em branco"}
  scope :due, -> { where(finished: false).order(end: :desc) }
  scope :finished, -> { where(finished: true) }
end
