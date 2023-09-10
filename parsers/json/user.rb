# frozen_string_literal: true

module Parsers
  module Json
    class User
      include Validy

      validy_on method: :validate!

      attr_reader :file_path

      def initialize(file_path)
        @file_path = file_path
      end

      def call
        ::JSON.parse(File.read(file_path)).each do |row|
          user = Models::User.new(row)

          if user.save
            puts("\e[32m user##{user.id} been persisted\e[0m")
          else
            puts("\e[31m user##{user.id} rejected: #{user.errors}\e[0m")
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
