# enable json parsing
require 'json'
# explicitly set the load path out of bundled gems
require 'bundler/setup'
Bundler.require(:default)

# autoload all rbs
root_directory = File.dirname(__FILE__)
Dir.glob("#{root_directory}/**/*.rb").each do |file|
  next if file == "./challenge.rb"

  require file
end

# run config
Configuration.instance.init

class Challenge
  def initialize
    # parsing
    Parsers::Json::Company.new("companies.json").call
    Parsers::Json::User.new("users.json").call
  end

  def out
    # assemble content to write
    content_to_write = "\n"
    Models::Company.all.values.each { |company| content_to_write << Reports::Company::Txt.new(company).assemble }

    # write content to output.txt
    file_path = "output.txt"
    bytes = File.open(file_path, "w") do |file|
      file.write(content_to_write)
    end

    # print out result
    puts
    puts("\e[32m #{bytes} bytes successfully written to #{file_path}\e[0m")

  rescue => e
    puts("\e[31m unexpected error: #{e.message}")
  end
end

# main app run
Challenge.new.out
