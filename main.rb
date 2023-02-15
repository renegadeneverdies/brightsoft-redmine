# frozen_string_literal: true

require_relative 'lib/interface'
require 'optparse'

options = {}

OptionParser.new do |parser|
  parser.on('-c', '--create', 'Создать задачу') do
    options[:create] = true
  end

  parser.on('-u', '--update', 'Изменить атрибутивный состав задачи') do
    options[:update] = true
  end

  parser.on('-l', '--login LOGIN', 'Логин Redmine') do |login|
    options[:login] = login
  end

  parser.on('-p', '--password PASSWORD', 'Пароль Redmine') do |password|
    options[:password] = password
  end
end.parse!

action = options.keys.find { |key| [:create, :update].include?(key) }

Interface.new(options[:login], options[:password]).send(action)
