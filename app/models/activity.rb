class Activity < ApplicationRecord
  belongs_to :project
  validates :name, :begin, :end, presence: { message: "não pode estar em branco"}
  scope :overdue, -> { where(finished: false).order(end: :desc) }
  scope :finished, -> { where(finished: true) }

  def date_overdue
    (self.end > self.project.end && !self.finished) ? "danger" : "body"
  end

  def finalizada
    self.finished ? ["success", "finalizada"] : ["primary", "em andamento"]
  end
end
