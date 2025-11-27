class Hero < ApplicationRecord
  has_many :team_heroes
  has_many :teams, through: :team_heroes

  validates :name, presence: true
  validates :localized_name, presence: true
  validates :image_link, presence: true
end
