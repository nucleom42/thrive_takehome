# frozen_string_literal: true

module Models
  class Company
    include Validy

    attr_accessor :id, :name, :top_up, :email_status

    validy_on method: :validate, setters: [:id, :name, :top_up, :email_status]

    def initialize(attrs = {})
      attrs.transform_keys!(&:to_sym)
      @id = attrs[:id]
      @name = attrs[:name]
      @top_up = attrs[:top_up]
      @email_status = attrs[:email_status]
    end

    def validate
      required(:id)
        .type(Numeric, { type_error: 'not an integer' })
        .condition(proc { Models::Company.find(id).nil? }, error: 'id must be unique')
      required(:name).type(String).condition(proc { Models::Company.find_by(name: @name).nil? }, "name must be unique")
      required(:top_up).type(Numeric)
      required(:email_status).condition(:email_status_boolean?, error: 'email_status should be boolean')
    end

    def save
      return false unless valid?

      ::Models::Company.repo.add(self)
      true
    end

    def users
      @users ||= ::Models::User.where(company_id: id)
    end

    def active_emailed_users
      users.select { |user| user.active_status && user.email_status == true }
    end

    def active_not_emailed_users
      users.select { |user| user.active_status && user.email_status == false }
    end

    private

    def email_status_boolean?
      boolean?(email_status)
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

        repo.all.find { |_, entity| entity if entity.send(look_up_property) == look_up_value }
      end

      def where(params = {})
        look_up_property = params.keys.first
        look_up_value = params.values.first

        repo.all.select { |_, entity| entity if entity.send(look_up_property) == look_up_value }.values
      end

      def repo
        ::Storages::Base.instance.get('Storages::Companies')
      end
    end
  end
end
