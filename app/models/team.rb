class Team < ApplicationRecord
  has_many :team_heroes
  has_many :heroes, through: :team_heroes

  validates :name, presence: true
end
