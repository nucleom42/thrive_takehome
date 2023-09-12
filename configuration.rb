# frozen_string_literal: true

# explicitly set the load path out of bundled gems
require 'bundler/setup'
Bundler.require(:default)

class Configuration
  include Singleton

  def init
    # enable json parsing
    require 'json'
    # autoload all rbs
    root_directory = File.dirname(__FILE__)
    Dir[File.join(root_directory, '**', '*.rb')].each do |file|
      next if file.include?("challenge.rb")
      next if file.include?("txt_spec.rb")
      next if file.include?("configuration.rb")

      require_relative file
    end

    Storages::Base.instance.init
  end
end
