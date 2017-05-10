namespace "localize" do
  # Usage: rake localize:create id=""
  desc "Create a new localization data in #{CONFIG['data']}"
  task :create do
    abort("rake aborted: '#{CONFIG['data']}' directory not found.") unless FileTest.directory?(CONFIG['data'])
    id = ENV['id']
    localize(id)
    puts "Localization data '#{id}' has been successfully created."
  end

  # Usage rake localize:list
  desc "Show the list of every localized data in #{CONFIG['data']}"
  task :list do
    abort("rake aborted: '#{CONFIG['data']}' directory not found.") unless FileTest.directory?(CONFIG['data'])

    puts "---------------"

    trans_file = File.read(CONFIG['trans_file'])
    trans_file_hash = JSON.parse(trans_file)
    trans_file_hash.each do |elem|
      puts elem[0]
    end

    puts "---------------"
  end

  # Usage rake localize:query id=""
  desc "Returns the localization data for supplied id"
  task :query do
    abort("rake aborted: '#{CONFIG['data']}' directory not found.") unless FileTest.directory?(CONFIG['data'])
    if(ENV['id'] == nil)
      abort("rake aborted! Please provide id option.")
    end
    trans_file = File.read(CONFIG['trans_file'])
    trans_file_hash = JSON.parse(trans_file)
    trans_file_hash.each do |elem|
      if(elem[0] == ENV['id'])
        puts elem[1]
      end
    end
  end

end