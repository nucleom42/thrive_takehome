
require './configuration'

# run config
Configuration.instance.init

def exit_prog
  puts "\e[37m Good bye!\e[0m"
  exit
end

# console app
loop do
  puts "\e[37mWelcome to the Thrive Takehome console Application!\e[0m"
  print "Please type (g) to start it or anything to quit: "
  choice = gets.chomp.downcase
  exit_prog if choice != "g"

  print "Do you want to load output from 'companies.json', 'users.json' files to {your_name}.txt file (y/n)? "
  choice = gets.chomp.downcase
  exit_prog if choice != "y"

  print "Please type file name: "
  file = gets.chomp.downcase
  unless file[/[a-z\-_]+.txt$/]
    puts("\e[31m wrong file name\e[0m")
    exit_prog
  end
  # service that parses jsons, persist it in repos and write assembled lines in text file
  FileProcessor.new.out(file)

  print "Do you want to quit (y/n)? "
  choice = gets.chomp.downcase
  exit_prog if choice == "y"
end
