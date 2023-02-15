# frozen_string_literal: true

require 'json'
require 'uri'
require 'net/http'
require 'base64'

module Redmine
  class Client
    def initialize(login, password)
      @login = login
      @password = password
      @base_url = 'https://redmine.bright-soft.org'
    end

    def create
      example_issue = File.read(File.join(File.dirname(__FILE__), '../include/example_issue_create.json'))
      post('issues.json', example_issue)
    end

    def destroy(id)
      delete('issues', id)
    end

    def update(id)
      example_issue = File.read(File.join(File.dirname(__FILE__), '../include/example_issue_update.json'))
      put('issues.json', id, example_issue)
    end

    private

    def post(path, body = {})
      url = "#{@base_url}/#{path}"
      headers = { 'Content-Type' => 'application/json' }
      perform_request(url, Net::HTTP::Post, body, headers)
    end

    def delete(path, id)
      url = "#{@base_url}/#{path}/#{id}.json"
      perform_request(url, Net::HTTP::Delete)
    end

    def put(path, id, body = {})
      url = "#{@base_url}/#{path}/#{id}.json"
      headers = { 'Content-Type' => 'application/json' }
      puts perform_request(url, Net::HTTP::Put, body, headers)
    end

    def perform_request(path, http_method, body = nil, headers = {})
      uri = URI(path)
      https = Net::HTTP.new(uri.host, uri.port)
      https.use_ssl = true

      authorized_request = http_method.new(uri, headers)
      authorized_request.basic_auth @login, @password
      authorized_request.body = body
      https.request(authorized_request)
    end
  end
end
