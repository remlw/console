namespace "localize" do
  # Usage: rake localize:create id=""
  desc "Create a new localization data in #{CONFIG['data']}"
  task :create do
    abort("rake aborted: '#{CONFIG['data']}' directory not found.") unless FileTest.directory?(CONFIG['data'])
    id = ENV['id']
    localize(id)
    puts "Localization data '#{id}' has been successfully created."
  end
end