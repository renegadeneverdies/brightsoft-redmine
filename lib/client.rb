# frozen_string_literal: true

require 'json'
require 'uri'
require 'net/http'

module Redmine
  class Client
    def initialize(login, password, apikey)
      @login = login
      @password = password
      @apikey = apikey
      @base_url = 'https://redmine.bright-soft.org'
    end

    def create
      example_issue = File.read(File.join(File.dirname(__FILE__), '../include/example_issue_create.json'))
      post('issues.json', example_issue, { 'Content-Type' => 'application/json' })
    end

    def destroy(id)
      delete('issues', id)
    end

    def update(id)
      example_issue = File.read(File.join(File.dirname(__FILE__), '../include/example_issue_update.json'))
      put('issues', id, example_issue, { 'Content-Type' => 'application/json' })
    end

    private

    def post(path, body, headers)
      url = "#{@base_url}/#{path}"
      perform_request(url, Net::HTTP::Post, body, headers)
    end

    def delete(path, id)
      url = "#{@base_url}/#{path}/#{id}.json"
      perform_request(url, Net::HTTP::Delete)
    end

    def put(path, id, body, headers)
      url = "#{@base_url}/#{path}/#{id}.json"
      perform_request(url, Net::HTTP::Put, body, headers)
    end

    def perform_request(path, http_method, body = nil, headers = {})
      uri = URI(path)
      https = Net::HTTP.new(uri.host, uri.port)
      https.use_ssl = true

      authorized_request = http_method.new(uri, headers)
      case http_method.to_s
      when 'Net::HTTP::Delete'
        authorized_request['Authorization'] = "Basic #{@apikey}"
      else
        authorized_request.basic_auth @login, @password
      end
      authorized_request.body = body
      https.request(authorized_request)
    end
  end
end
