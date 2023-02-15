# frozen_string_literal: true

require 'optparse'
require 'io/console'
require_relative 'client'

module Redmine
  class Interface
    def initialize(login, password)
      @client = Redmine::Client.new(login, password)
    end

    private

    def create
      @client.create
    end

    def destroy
      puts 'Введите идентификатор задачи'
      issue_id = $stdin.gets.chomp
      @client.destroy(issue_id)
    end

    def update
      puts 'Введите идентификатор задачи'
      issue_id = $stdin.gets.chomp
      @client.update(issue_id)
    end
  end
end
