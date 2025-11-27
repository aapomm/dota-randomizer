# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

file = File.open(Rails.root.join('db', 'heroes.json'))
data = JSON.load(file)['heroes']

data.each do |hero|
  Hero.create(
    name: hero['name'],
    localized_name: hero['localized_name'],
    image_link: "https://cdn.steamstatic.com/apps/dota2/images/dota_react/heroes/#{hero['name']}.png"
  )
end

data = YAML.load_file(Rails.root.join('db', 'teams.yml'))
data.each do |name, members|
  puts "Creating team: #{name}"
  team = Team.create(name: name)

  members.each do |hero_name|
    puts "Adding hero to team: #{hero_name}"
    TeamHero.create(team: team, hero: Hero.find_by_name!(hero_name))
  end
end
