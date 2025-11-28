class Randomizer
  # Roles image source: https://imgur.com/a/J483B6x
  ROLES = [
    { role_name: 'Carry', img_link: 'https://i.imgur.com/rL1ZwZ4.png' },
    { role_name: 'Mid', img_link: 'https://i.imgur.com/7oAbbDo.png' },
    { role_name: 'Offlane', img_link: 'https://i.imgur.com/ThXJQ0n.png' },
    { role_name: 'Support', img_link: 'https://i.imgur.com/NkAmIjB.png' },
    { role_name: 'Hard Support', img_link: 'https://i.imgur.com/TGv7onk.png' }
  ]

  attr_accessor :data

  def initialize(data)
    @data = data
  end

  # Returns a hash
  def randomize
    case random_type
    when :role
      get_random_role
    when :hero
      get_random_hero
    when :team
      team = Team.all.sample
      get_random_team(heroes: team.heroes, team_name: team.name)
    when :all_random
      get_random_team(
        heroes: Hero.all.sample(5),
        team_name: 'Random Teamangs'
      )
    end
  end

  private

  def get_random_role
    role = ROLES[rand(0..4)]

    {
      "embeds": [
        {
          "title": "Ikaw ay maglalaro ng #{role[:role_name]}",
          "color": 16711680,
          "author": {
            "name": 'Role Randomizer'
          },
          "image": {
            "url": role[:img_link]
          }
        }
      ],
      "attachments": []
    }
  end

  def get_random_hero
    hero = Hero.all.sample

    {
      "embeds": [
        {
          "title": "Ikaw ay maglalaro ng #{hero.localized_name}",
          "color": 2687231,
          "author": {
            "name": 'Hero Randomizer'
          },
          "image": {
            "url": hero.image_link
          }
        }
      ],
      "attachments": []
    }
  end

  def get_random_team(heroes:, team_name:)
    heroes_for_images = heroes.sample(4)

    embed_images =
      heroes_for_images[1..3].map do |hero|
        {
          "url": 'https://dota2.com',
          "image": {
            "url": hero.image_link
          }
        }
      end

    {
      "embeds": [
        {
          "title": "Kayo ay maglalaro ng \"#{team_name}\"",
          "color": 11670158,
          "description": heroes.order(localized_name: :asc).pluck(:localized_name).join("\n"),
          "url": 'https://dota2.com',
          "author": {
            "name": 'Team Randomizer'
          },
          "image": {
            "url": heroes_for_images.first.image_link
          }
        }
      ] + embed_images,
      "attachments": []
    }
  end

  def random_type
    data['options'].first['value'].to_sym
  end
end
