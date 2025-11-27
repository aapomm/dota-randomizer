class CreateTeamHeroes < ActiveRecord::Migration[8.0]
  def change
    create_table :team_heroes do |t|
      t.belongs_to :team, null: false, foreign_key: true
      t.belongs_to :hero, null: false, foreign_key: true

      t.timestamps
    end
  end
end
