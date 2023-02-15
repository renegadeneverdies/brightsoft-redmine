# frozen_string_literal: true

require 'json'
require 'uri'
require 'net/http'

module Redmine
  class Client
    def initialize(login, password)
      @login = login
      @password = password
      @base_url = 'https://redmine.bright-soft.org'
    end

    def create
      post('issues.json', read_json('../include/example_issue_create.json'))
    end

    def update(id)
      put('issues', id, read_json('../include/example_issue_update.json'))
    end

    private

    def post(path, body)
      url = "#{@base_url}/#{path}"
      perform_request(url, Net::HTTP::Post, body)
    end

    def put(path, id, body)
      url = "#{@base_url}/#{path}/#{id}.json"
      perform_request(url, Net::HTTP::Put, body)
    end

    def perform_request(path, http_method, body)
      uri = URI(path)
      https = Net::HTTP.new(uri.host, uri.port)
      https.use_ssl = true

      authorized_request = http_method.new(uri, { 'Content-Type' => 'application/json' })
      authorized_request.basic_auth @login, @password
      authorized_request.body = body
      https.request(authorized_request)
    end

    def read_json(relative_path)
      File.read(File.join(File.dirname(__FILE__), relative_path))
    end
  end
end
