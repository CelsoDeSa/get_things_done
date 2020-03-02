class Activity < ApplicationRecord
  belongs_to :project
  scope :due, -> { where(finished: false).order(end: :desc) }
  scope :finished, -> { where(finished: true) }
end
