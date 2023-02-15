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
      example_issue = File.read(File.join(File.dirname(__FILE__), '../include/example_issue.json'))
      post('issues.json', JSON.parse(example_issue))
    end

    def destroy(issue_id)
      delete('issues', issue_id)
    end

    def update(issue_id)
      puts 'client edit'
    end

    private

    def post(path, body = {})
      uri = URI("#{@base_url}/#{path}")
      https = use_https(uri)
      authorized_request = authorize(uri, Net::HTTP::Post, { 'Content-Type' => 'application/json' })
      authorized_request.body = body.to_json
      https.request(authorized_request)
    end

    def delete(path, issue_id)
      uri = URI("#{@base_url}/#{path}/#{issue_id}.json")
      https = use_https(uri)
      authorized_request = authorize(uri, Net::HTTP::Delete)
      https.request(authorized_request)
    end

    def use_https(uri)
      https = Net::HTTP.new(uri.host, uri.port)
      https.use_ssl = true
      https
    end

    def authorize(uri, http_method, headers = {})
      request = http_method.new(uri, headers)
      request['Authorization'] = "Basic #{Base64.strict_encode64("#{@login}:#{@password}")}"
      request
    end
  end
end
