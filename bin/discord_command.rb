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
              "name": "type",
              "description": "Type to randomize",
              "type": 3,
              "required": true,
              "choices": [
                  {
                      "name": "Hero",
                      "value": "hero"
                  },
                  {
                      "name": "Role",
                      "value": "role"
                  },
                  {
                      "name": "Team",
                      "value": "team"
                  },
                  {
                      "name": "All random",
                      "value": "all_random"
                  }
              ]
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
