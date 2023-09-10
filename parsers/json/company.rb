# frozen_string_literal: true

module Parsers
  module Json
    class Company
      include Validy

      validy_on method: :validate!

      attr_reader :file_path

      def initialize(file_path)
        @file_path = file_path
      end

      def call
        ::JSON.parse(File.read(file_path)).each do |row|
          company = Models::Company.new(row)

          if company.save
            puts("\e[32m company##{company.id} been persisted\e[0m")
          else
            puts("\e[31m company##{company.id} rejected: #{company.errors}\e[0m")
          end
        end
      end

      private

      def validate!
        required(:file_path).type(String)
          .condition(proc { File.exist?(file_path) }, 'file does not exist')
      end
    end
  end
end
