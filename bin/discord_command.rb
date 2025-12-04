#!/usr/bin/env ruby

require 'faraday'
require 'json'

app_id = ARGV[0]
@token = ARGV[1]
@url = "https://discord.com/api/v10/applications/#{app_id}"

def register_command
  json = {
      "name": "random",
      "type": 1,
      "description": "Get a random hero/role/team",
      "options": [
          {
              "name": "role",
              "description": "Get a random Role (1-5)",
              "type": 1
          },
          {
              "name": "hero",
              "description": "Get a random Hero",
              "type": 1,
              "options": [
                {
                  "name": "attribute",
                  "description": "Get a specific hero with the attribute",
                  "type": 3,
                  choices: [
                    {
                      "name": "Strength",
                      "value": "strength"
                    },
                    {
                      "name": "Agility",
                      "value": "agility"
                    },
                    {
                      "name": "Intelligence",
                      "value": "intelligence"
                    },
                    {
                      "name": "Universal",
                      "value": "universal"
                    }
                  ]
                },
                {
                  "name": "complexity",
                  "description": "Get a specific hero with the complexity",
                  "type": 3,
                  choices: [
                    {
                      "name": "1",
                      "value": "1"
                    },
                    {
                      "name": "2",
                      "value": "2"
                    },
                    {
                      "name": "3",
                      "value": "3"
                    }
                  ]
                }
              ]
          },
          {
              "name": "team",
              "description": "Get a random Team",
              "type": 1,
              "options": [
                {
                  "name": "category",
                  "description": "Get a specific team from the category",
                  "type": 3,
                  "choices": [
                    {
                      "name": "Color",
                      "value": "color"
                    },
                    {
                      "name": "Strategy",
                      "value": "strategy"
                    },
                    {
                      "name": "Ti",
                      "value": "ti"
                    },
                    {
                      "name": "Elemental",
                      "value": "elemental"
                    },
                    {
                      "name": "Lore",
                      "value": "lore"
                    },
                    {
                      "name": "Meme",
                      "value": "meme"
                    },
                    {
                      "name": "Misc",
                      "value": "misc"
                    }
                  ]
                },
              ]
          },
          {
              "name": "all_random",
              "description": "Get 5 All Random Heroes",
              "type": 1
          }
      ]
  }

  conn = Faraday.new(
    @url,
    headers: {
      'Authorization' => "Bot #{@token}"
    }
  )

  response = conn.post('commands', json.to_json, 'Content-Type' => 'application/json')

  puts response.body
end

def list_commands
  conn = Faraday.new(
    @url,
    headers: {
      'Authorization': "Bot #{@token}"
    }
  )

  response = conn.get('commands')
  puts response.body
end

def delete_command
  conn = Faraday.new(
    @url,
    headers: {
      'Authorization': "Bot #{@token}"
    }
  )


  command_id = ARGV[3]
  response = conn.delete("commands/#{command_id}")
end

type = ARGV[2]

case type.chomp
when 'list'
  list_commands
when 'register'
  register_command
when 'delete'
  delete_command
end
