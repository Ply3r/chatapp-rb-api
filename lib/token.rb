require 'jwt'

class Token
  @secret = ENV["SECRET_KEY"] 

  class << self
    def encode(payload, exp=24.hours.from_now)
      payload[:exp] = exp.to_i
      token = JWT.encode(payload, @secret)

      token
    end

    def decode(token)
      payload = JWT.decode(token, @secret, true)
      payload
    end

  end
end