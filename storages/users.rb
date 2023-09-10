# frozen_string_literal: true

module Storages
  class Users
    attr_accessor :users
    def initialize(users = {})
      @users = users
    end

    def all
      @users || {}
    end

    def add(user)
      @users[user.id] = user
    end
  end
end
