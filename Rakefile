require 'nanoc3/tasks'

PRIMARY_PROJECT_NAME    = "chef"
PRIMARY_PROJECT_GIT_URL = "git://github.com/opscode/chef.git"
PRIMARY_PROJECT_TAGS    = %w{master 0.9.6 0.8.16}
RDOC_RELATIVE_DIR       = 'chef'

PWD = File.expand_path(Dir.pwd)

desc "clone and/or update the project(s) sources"
task :pull do
  primary_project_dir = "#{PRIMARY_PROJECT_NAME}-src"
  puts `git clone #{PRIMARY_PROJECT_GIT_URL} #{primary_project_dir}` unless File.directory?(primary_project_dir)
  Dir.chdir(primary_project_dir) do
    puts `git pull origin master`
    Dir.chdir(RDOC_RELATIVE_DIR) do
      puts `sdoc -i lib/ -m README.rdoc -t 'Chef Developer Documentation' -T 'direct' -o #{PWD}/content/#{PRIMARY_PROJECT_NAME}`
    end
  end
end
