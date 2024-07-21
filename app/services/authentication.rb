# app/services/authentication_service.rb
require 'faraday'
require 'json'

class Authentication
  API_URL = 'https://beta.01cxhdz3a8jnmapv.com/api/v1/assignment'
  AUTH_BODY = {
    grant_type: 'password',
    client_id: '6779ef20e75817b79605',
    client_secret: '3e0f85f44b9ffbc87e90acf40d482602',
    username: 'hiring',
    password: 'tmtg'
  }.freeze

  class APIError < StandardError; end
  class ConnectionError < APIError; end

  def initialize
    @token = nil
    @auth_header = nil
  end

  def authenticate
    response = auth_client.post do |req|
      req.body = AUTH_BODY.to_json
    end
    body = JSON.parse(response.body)
    @token = body['access_token'].to_s.strip
    @auth_header = body['token_type'].to_s.strip
  rescue StandardError => e
    raise ConnectionError, "Error al autenticarse: #{e.message}"
  end

  def acces_auth_header
    authenticate unless @token && @auth_header
    "#{@auth_header} #{@token}"
  end

  private

  def auth_client
    auth_url = "#{API_URL}/token"
    Faraday.new(
      url: auth_url,
      ssl: { verify: false },
      headers: {
        'Content-Type' => 'application/json'
      }
    )
  end
end
