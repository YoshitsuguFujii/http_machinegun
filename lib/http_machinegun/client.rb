# coding: utf-8

require 'net/http'
require 'uri'
require 'json'

module HttpMachinegun
  module Client

    def initialize(url, port = 80, send_data = "")
      @url = url
      @port = port
      @send_data = send_data
    end

    def basic_auth(username, password)
      if username && password
        @send_data.basic_auth username, password
      end
    end

    def execute()
      Net::HTTP.start(@url, @port) do |http|
        response = http.request(@send_data)
        if response.code =~ /^[^2]..$/
          case response.code
          when '400'
            raise BadRequestException
          when '401'
            raise UnauthorizedException
          when '404'
            raise NotFoundException
          else
            raise GeneralFailureException
          end
        end

        def response.data
          JSON.parse body
        end
        response
      end
    end
  end
end
