module Sender
  def send_random_role(role)
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

  def send_random_hero(hero)
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
end
