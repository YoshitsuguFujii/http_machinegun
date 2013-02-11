# coding: utf-8

require 'net/http'
require 'uri'
require 'json'

module HttpMachinegun
  class Client
    DEFAULT_PORT = 80

    BASE_HEADERS = {
      #'content-type'=>'application/json'
      'content-type'=>'text/plain'
    }

    def initialize(url, port, send_data = "")
      raise ArgumentError if url.nil?

      @url = URI.parse(url)
      @port = port || @url.port || DEFAULT_PORT
      @send_data = send_data
    end

    def basic_auth(username, password)
      if username && password
        @request_body.basic_auth username, password
      else
        raise ArgumentError
      end

      self
    rescue NoMethodError => ex
      puts "【error】set http medhod type before call"
      #@request_body = Net::HTTP::Get.new('/')
      #retry
      raise ex
    end

    def http_method(method)
      path = @url.path.empty? ?  "/" : @url.path
      case method.to_sym
      when :get
        @request_body = Net::HTTP::Get.new(path)
      when :post
        @request_body = Net::HTTP::Post.new(path, BASE_HEADERS)
      when :put
        @request_body = Net::HTTP::Put.new(path, BASE_HEADERS)
      when :delete
        @request_body = Net::HTTP::Delete.new(path)
      else
        @request_body = Net::HTTP::Get.new(path)
      end

      self
    end

    def set_body
      @request_body.body = @send_data.to_json

      self
    end

    def execute()
      Net::HTTP.start(@url.host, @port) do |http|
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

        response
      end
    end
  end
end
