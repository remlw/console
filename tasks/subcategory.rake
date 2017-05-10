namespace "subcategory" do
  # Usage: rake subcategory:create title="" subcat_of="" (cat_id) [href=""] [id=""]
    # remove []! this is only to say that these fields are optional.
  # By default, the href and id would be made by making the title lowercased.
  # Note that the after performing this task, the json files will be uglified. To prettify, please google 'json prettyfier'

  desc "Create a subcategory under a specified category in #{CONFIG['categories']}"
  task :create do
    #Validation
    if(ENV['title'] == nil)
      abort("rake aborted! Please provide title option.")
    end

    if(ENV['subcat_of'] == nil)
      abort("rake aborted! Please provide subcat_of option.")
    end

    #env vars
    title = ENV['title']
    href = ENV['href'] || title.downcase.strip.gsub(' ', '-').gsub(/[^\w-]/, '')
    id = ENV['id'] || title.downcase.strip.gsub(' ', '-').gsub(/[^\w-]/, '')
    subcat_of = ENV['subcat_of'] #this is the specified cat (must be an id)

=begin
  If the specified cat doesn't have subcat, create subcat JSON array and add to it.
  If the specified cat does have subcat, then add to the existing JSON
=end

    # convert json file into hash and work on it
    cat_file = File.read(CONFIG['cat_file'])
    cat_file_hash = JSON.parse(cat_file)
    cat_file_hash.each do |elem|
      if(elem['id'] == subcat_of)
        if(!elem.key?('subcategories'))
          elem['subcategories'] = [{
            "title" => title,
            "href" => '/' + href,
            "id" => id
            }]
        else
          elem['subcategories'].push({
            "title" => title,
            "href" => '/' + href,
            "id" => id
            })
        end
      end
    end

    # convert hash back to json
    cat_file_json = JSON.generate(cat_file_hash)

    # clears the actual file and write the result to it
    File.open(CONFIG['cat_file'], 'w') do |cat|
      cat.write(cat_file_json)
    end

    create_cat(title, id, subcat_of)
    localize(id)

    puts "Subcategory '#{title}' has been successfully created!"
  end

end