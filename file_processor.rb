
class FileProcessor
  def initialize
    # parsing
    Parsers::Json::Company.new("companies.json").call
    Parsers::Json::User.new("users.json").call
  end

  def out(file_path)
    # assemble content to write
    content_to_write = write_content
    # write content
    bytes = write_to_file(content_to_write, file_path)
    # print out result
    puts
    puts("\e[32m #{bytes} bytes successfully written to #{file_path} \e[0m")
    true
  rescue => e
    puts("\e[31m unexpected error: #{e.message}\e[0m")
    false
  end

  private

  def write_to_file(content_to_write, file_path)
    File.open(file_path, "w") do |file|
      file.write(content_to_write)
    end
  end

  def write_content
    content_to_write = "\n"
    Models::Company.all.values.each { |company| content_to_write << Reports::Company::Txt.new(company).assemble }
    content_to_write
  end
end
