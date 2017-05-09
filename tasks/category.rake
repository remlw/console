namespace "category" do
  # Usage: rake category title="" [href=""]  [id=""] [subcat_of="id of super category"]
  # remove []! this is only to say that these fields are optional.
  # By default, the href and id would be made by making the title lowercased.
  # Note that the after performing this task, the json files will be uglified. To prettify, please google 'json prettyfier'
  desc "Create a new category in #{CONFIG['categories']}"
  task :create do
    abort("rake aborted: '#{CONFIG['categories']}' directory not found.") unless FileTest.directory?(CONFIG['categories'])

    title = ENV['title'] || "rand-cat"
    href = ENV['href'] || title.downcase.strip.gsub(' ', '-').gsub(/[^\w-]/, '')
    id = ENV['id'] || title.downcase.strip.gsub(' ', '-').gsub(/[^\w-]/, '')
    subcat_of = ENV['subcat_of'] || ""
    cat_file = '_data/categories.json'

    if(subcat_of != "")
      FileUtils::mkdir_p File.join(CONFIG['categories'], "#{subcat_of}/#{id}")
      filename = File.join(CONFIG['categories'], "#{subcat_of}/#{id}/index.#{CONFIG['post_ext']}")
    else
      FileUtils::mkdir_p File.join(CONFIG['categories'], "#{id}")
      filename = File.join(CONFIG['categories'], "#{id}/index.#{CONFIG['post_ext']}")
    end

    if(File.exist?(filename))
      abort("rake aborted") if ask("#{filename} already exists. Overwrite?", ['y', 'n']) == 'n'
    end

    puts "Creating new category: #{filename}."

    open(filename, 'w') do |category|
      category.puts "---"
      category.puts "layout: post"
      category.puts "title: #{title}"
      category.puts "category: #{id}"
      category.puts "---"
      category.puts ""
      category.puts "{% include category.html param = page.layout %}"
    end

    localize(id)

    #temporary json (which will be parsed to JSON)
    tempJSON = {
      "title" => title,
      "href" => '/' + href,
      "id" => id
    }

    #adding the category into categories.json file
    File.truncate(cat_file, File.size(cat_file) - 1)

    File.open(cat_file, 'a') do |cat|
     cat.write(',' + tempJSON.to_json + ']')
    end

    puts "Category '#{title}' has been successfully created!"

  end

end