class Project < ApplicationRecord
    has_many :activities, -> { order('begin desc') }
    validates :name, :begin, :end, presence: true
    validates :name, uniqueness: true
end
