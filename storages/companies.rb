# frozen_string_literal: true

module Storages
  class Companies
    attr_accessor :companies
    def initialize(companies = {})
      @companies = companies
    end

    def all
      @companies || {}
    end

    def add(company)
      @companies[company.id] = company
    end
  end
end
