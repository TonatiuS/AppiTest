# app/services/employee_service.rb
require 'faraday'
require 'json'
require_relative 'authentication_service'

class EmployeeService
  API_URL = 'https://beta.01cxhdz3a8jnmapv.com/api/v1/assignment'

  class APIError < StandardError; end
  class ConnectionError < APIError; end

  def initialize(auth_service: AuthenticationService.new)
    @auth_service = auth_service
  end

  def call(method)
    case method.to_sym
    when :employee_list
      employee_list
    else
      raise ArgumentError, "Método no conocido: #{method}"
    end
  end

  private

  def client
    Faraday.new(
      ssl: { verify: false },
      headers: {
        'Content-Type' => 'application/json',
        'Authorization' => @auth_service.auth_header
      }
    )
  end

  def employee_list
    url = URI("#{API_URL}/employee/list")
    response = client.get(url)
    JSON.parse(response.body)
  rescue JSON::ParserError
    raise APIError, 'Error al analizar la respuesta JSON de la API'
  rescue Faraday::TimeoutError, Faraday::ConnectionFailed
    raise ConnectionError, 'Error al conectarse al servidor de la API'
  rescue StandardError => e
    raise APIError, "Error al obtener la lista de empleados: #{e.message}"
  end
end
