class DiscordVerifier
  def initialize(public_key)
    @verify_key = Ed25519::VerifyKey.new([public_key].pack("H*"))
  end

  def valid?(signature, timestamp, body)
    message = "#{timestamp}#{body}"

    begin
      @verify_key.verify([signature].pack("H*"), message)
      true
    rescue Ed25519::VerifyError
      false
    end
  end
end
