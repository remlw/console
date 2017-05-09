=begin

  Rakefile created by Jae Hee Lee @ 2017

  The rake files dependent on this main rakefile can be found in tasks/*.rake

=end

require "rubygems"
require "rake"
require 'securerandom'
require "time"
require "fileutils"
require "json"
require "yaml"

SOURCE = '.'
CONFIG = {
  'version' => "1.0.0",
  'layouts' => File.join(SOURCE, "_layouts"),
  'posts' => File.join(SOURCE, "_posts"),
  'categories' => File.join(SOURCE, "category"),
  'data' => File.join(SOURCE, "_data"),
  'post_ext' => "md",
}

=begin
  Common Functions
=end

# asking user for further options
def ask(message, valid_options)
  if valid_options
    answer = get_stdin("#{message} #{valid_options.to_s.gsub(/"/, '').gsub(/, /,'/')} ") while !valid_options.include?(answer)
  else
    answer = get_stdin(message)
  end
  answer
end

def get_stdin(message)
  print message
  STDIN.gets.chomp
end

def localize(id)
  trans_file = '_data/localization.json'

  #loading _config.yml to fetch languages option.
  config_yml = YAML.load_file('_config.yml')
  available_langs = config_yml['languages']
  translated = Hash.new

  puts "Creating new localization data ..."

  #localization step
  for lang in available_langs
    puts "Please enter " + lang + " translation for the category '" + id + "':"
    ARGV.clear
    response = gets.chomp()
    translated[lang] = response
  end

  tempJSON = Hash.new
  tempJSON[id] = translated
  permJSON = tempJSON.to_json
  permJSON[0] = "" # will have to remove the first { to concatenate to existing string.

  #parsing
  permJSON.insert(permJSON.index('{'), '[')

  indexes = Array.new

  for i in (0..permJSON.length)
    if(permJSON[i] == ',')
      indexes.push(i)
    end
  end

  counter = 0

  for idx in indexes
    permJSON.insert(idx + counter, '}')
    permJSON.insert(idx + counter + 2, '{')
    counter += 2
  end

  permJSON.insert(permJSON.rindex('}'), ']')

  #adding the localization for the category into localization.json file
  File.truncate(trans_file, File.size(trans_file) - 1)
  File.open(trans_file, 'a') do |trans|
    trans.write(',' + permJSON)
  end
end

# Loads all separate rake files
Dir['tasks/*.rake'].sort.each { |f| load f }