namespace "category" do
  # Usage: rake category:create title="" [href=""]  [id=""]
  # remove []! this is only to say that these fields are optional.
  # By default, the href and id would be made by making the title lowercased.
  # Note that the after performing this task, the json files will be uglified. To prettify, please google 'json prettyfier'
  desc "Create a new category in #{CONFIG['categories']}"
  task :create do
    directory_check('categories')

    validate('title')

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

  # Usage rake category:list
  desc "Show the list of every category (including subcategory) in #{CONFIG['data']}"
  task :list do
    cat_file = File.read(CONFIG['cat_file'])
    cat_file_hash = JSON.parse(cat_file)
    cat_file_hash.each do |elem|
      puts elem['title']
      if(elem['subcategories'] != nil)
        for subelem in elem['subcategories']
          puts "\t" + subelem['title']
        end
      end
    end
  end

  # Usage rake category:query id=""
  desc "Query specific category about its information"
  task :query do
    directory_check('data')
    validate('id')
    cat_file = File.read(CONFIG['cat_file'])
    cat_file_hash = JSON.parse(cat_file)
    cat_file_hash.each do |elem|
      if(elem['id'] == ENV['id'])
        puts "title: " + elem['title']
        puts "href: " + elem['href']
        puts "id: " + elem['id']
        puts "subcategories: " + (elem['subcategories'] != nil ? "exists" : "not exists")
        if(elem['subcategories'] != nil)
        counter = 0
          for subelem in elem['subcategories']
            counter += 1
            puts "\t" + counter.to_s + '. ' + subelem['title'] + " ( id:" + subelem['id'] + ', href: ' + subelem['href'] + " )"
          end
        end
      end
    end
  end

  # Usage rake category:modify id=""
  desc "Modify category"
  task :modify do
    directory_check('data')
    validate('id')
  end

end