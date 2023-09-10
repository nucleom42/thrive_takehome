# frozen_string_literal: true

module Storages
  class Base
    include ::Singleton

    attr_reader :storage

    def init
      @storage ||= storage_klasses.each_with_object({}) do |storage_klass, hash|
        hash[storage_klass.to_s] = storage_klass.new
      end
    end

    def get(klass_name)
      @storage[klass_name]
    end

    private

    def storage_klasses
      found_classes = []

      Dir.glob(File.join('storages', '**', '*.rb')).each do |file_path|
        class_name = File.basename(file_path, '.rb').split('_').map(&:capitalize).join
        klass = Object.const_get("::Storages::#{class_name}") rescue nil
        next if klass == self.class

        found_classes << klass if klass && klass.is_a?(Class)
      end

      found_classes
    end
  end
end
