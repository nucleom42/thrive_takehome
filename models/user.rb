# frozen_string_literal: true

module Models
  class User
    include ::Validy

    validy_on method: :validate,
              setters: [:id, :first_name, :last_name, :email, :company_id, :email_status, :active_status, :tokens]

    attr_accessor :id, :first_name, :last_name, :email, :company_id, :email_status, :active_status, :tokens

    def initialize(attrs = {})
      attrs.transform_keys!(&:to_sym)
      @id = attrs[:id]
      @first_name = attrs[:first_name]
      @last_name = attrs[:last_name]
      @email = attrs[:email]
      @company_id = attrs[:company_id]
      @email_status = attrs[:email_status]
      @active_status = attrs[:active_status]
      @tokens = attrs[:tokens]
    end

    def validate
      required(:id).type(Numeric, { type_error: 'not an integer' })
        .condition(proc { Models::User.find(id).nil? }, error: 'id must be unique')
      required(:first_name).type(String)
      required(:last_name).type(String)
      required(:email).type(String).condition(:valid_email?, "not a valid email")
      required(:company_id).type(Numeric)
        .condition(proc { Models::Company.find(company_id) }, error: 'Company must exists')
      required(:email_status)
        .condition(:email_status_boolean?, error: 'email_status should be boolean')
      required(:tokens).type(Numeric, { tokens: 'not an integer' })
      required(:active_status)
        .condition(:active_status_boolean?, error: 'active_status should be boolean')
    end

    def save
      return false unless valid?

      ::Models::User.repo.add(self)
      true
    end

    private

    def email_status_boolean?
      boolean?(email_status)
    end

    def active_status_boolean?
      boolean?(active_status)
    end

    def valid_email?
      email_regex = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
      !!(email =~ email_regex)
    end

    def boolean?(property)
      property.instance_of?(TrueClass) || property.instance_of?(FalseClass)
    end

    class << self
      def find(id)
        repo.all[id]
      end

      def all
        repo.all
      end

      def find_by(params = {})
        look_up_property = params.keys.first
        look_up_value = params.values.first

        repo.all.find { |_, entity| return entity if entity.send(look_up_property) == look_up_value }
      end

      def where(params = {})
        look_up_property = params.keys.first
        look_up_value = params.values.first

        repo.all.select { |_, entity| entity if entity.send(look_up_property) == look_up_value }.values
      end

      def repo
        ::Storages::Base.instance.get('Storages::Users')
      end
    end
  end
end
