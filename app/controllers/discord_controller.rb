class DiscordController < ApplicationController
  before_action :verify_signature

  def interactions
    if params[:type] == 1
      render json: { type: 1 }
    elsif params[:type] == 2
      randomizer = Randomizer.new(params[:data])
      output = randomizer.randomize

      response = {
        type: 4,
        data: {
          content: "Hoy <@#{params.dig(:member, :user, :id)}>"
        }.merge(output)
      }

      render json: response
    else
      head :ok
    end
  end

  private

  def verify_signature
    signature  = request.headers['X-Signature-Ed25519']
    timestamp  = request.headers['X-Signature-Timestamp']
    body       = request.raw_post

    verifier = DiscordVerifier.new(
      Rails.application.config_for(:discord)[:public_key]
    )

    unless verifier.valid?(signature, timestamp, body)
      head 401
    end
  end
end
