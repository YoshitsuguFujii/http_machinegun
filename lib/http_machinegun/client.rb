# coding: utf-8

require 'net/http'
require 'uri'
require 'json'

module HttpMachinegun
  class Client

    BASE_HEADERS = {
      #'content-type'=>'application/json'
      'content-type'=>'text/plain'
    }

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

    def http_method(method)
      case method.to_sym
      when :get
        @request_body = Net::HTTP::Get.new('/')
      when :post
        @request_body = Net::HTTP::Post.new('/', BASE_HEADERS)
      when :put
        @request_body = Net::HTTP::Put.new('/', BASE_HEADERS)
      when :delete
        @request_body = Net::HTTP::Delete.new('/')
      else
        @request_body = Net::HTTP::Get.new('/')
      end
    end

    def set_body
      @request_body.body = @send_data.to_json
    end

    def execute()
      Net::HTTP.start(@url, @port) do |http|
        response = http.request(@request_body)
        if response.code =~ /^[^2]..$/
          case response.code
          when '400'
            "BadRequestException"
          when '401'
            "UnauthorizedException"
          when '404'
            "NotFoundException"
          else
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
