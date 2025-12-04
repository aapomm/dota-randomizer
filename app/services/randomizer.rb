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
    case randomizer_type
    when :role
      send_random_role
    when :hero
      send_random_hero
    when :team
      team = get_randomized_team
      send_random_team(heroes: team.heroes.order(localized_name: :asc), team_name: team.name)
    when :all_random
      send_random_team(
        heroes: Hero.all.sample(5).sort_by(&:localized_name),
        team_name: 'Random Teamangs'
      )
    end
  end

  private

  def send_random_role
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

  def send_random_hero
    hero = get_random_hero

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

  def send_random_team(heroes:, team_name:)
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
          "description": heroes.pluck(:localized_name).join("\n"),
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

  def randomizer_type
    data['options'].first['name'].to_sym
  end

  def randomizer_options
    data['options'].first['options']
  end

  def get_randomized_team
    if randomizer_options.any?
      category = randomizer_options.find { |o| o['name'] == 'category' }['value']

      if Team.categories.key?(category)
        return Team.where(category: category).sample
      end
    end

    Team.all.sample
  end

  def get_random_hero
    heroes = Hero.all

    if randomizer_options.any?
      attribute = randomizer_options.find { |o| o['name'] == 'attribute' }&.fetch('value')
      complexity = randomizer_options.find { |o| o['name'] == 'complexity' }&.fetch('value')

      heroes = heroes.where(primary_attr: attribute) if Hero.primary_attrs.key?(attribute)
      heroes = heroes.where(complexity: complexity) if ['1', '2', '3'].include?(complexity)
    end

    if heroes.any?
      heroes.sample
    else
      Hero.all.sample
    end
  end
end
