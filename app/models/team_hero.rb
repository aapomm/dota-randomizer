class TeamHero < ApplicationRecord
  belongs_to :team
  belongs_to :hero
end
