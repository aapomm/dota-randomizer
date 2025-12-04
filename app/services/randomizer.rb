class Randomizer
  include Sender

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
      role = ROLES[rand(0..4)]
      send_random_role(role)
    when :hero
      hero = get_random_hero
      send_random_hero(hero)
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
      team_name = randomizer_options.find { |o| o['name'] == 'team' }&.fetch('value')

      heroes = heroes.where(primary_attr: attribute) if Hero.primary_attrs.key?(attribute)
      heroes = heroes.where(complexity: complexity) if ['1', '2', '3'].include?(complexity)

      team = Team.where('lower(name) = ?', team_name.downcase).first
      if team
        heroes = heroes.joins(:team_heroes).where({
          team_heroes: { team: team }
        })
      end
    end

    if heroes.any?
      heroes.sample
    else
      Hero.all.sample
    end
  end
end
