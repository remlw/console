namespace "category" do
  # Usage: rake category:create title="" [href=""]  [id=""]
  # remove []! this is only to say that these fields are optional.
  # By default, the href and id would be made by making the title lowercased.
  # Note that the after performing this task, the json files will be uglified. To prettify, please google 'json prettyfier'
  desc "Create a new category in #{CONFIG['categories']}"
  task :create do
    abort("rake aborted: '#{CONFIG['categories']}' directory not found.") unless FileTest.directory?(CONFIG['categories'])

    if(ENV['title'] == nil)
      abort("rake aborted! Please provide title option.")
    end

    title = ENV['title'] || "rand-cat"
    href = ENV['href'] || title.downcase.strip.gsub(' ', '-').gsub(/[^\w-]/, '')
    id = ENV['id'] || title.downcase.strip.gsub(' ', '-').gsub(/[^\w-]/, '')

    create_cat(title, id)
    localize(id)

    #temporary json (which will be parsed to JSON)
    tempJSON = {
      "title" => title,
      "href" => '/' + href,
      "id" => id
    }

    #adding the category into categories.json file
    File.truncate(CONFIG['cat_file'], File.size(CONFIG['cat_file']) - 1)

    File.open(CONFIG['cat_file'], 'a') do |cat|
     cat.write(',' + tempJSON.to_json + ']')
    end

    puts "Category '#{title}' has been successfully created!"
  end

end