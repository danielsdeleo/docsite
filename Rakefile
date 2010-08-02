require 'nanoc3/tasks'

$:.unshift File.expand_path(File.dirname(__FILE__) + '/lib')

require 'foreground_shellout'
require 'project'

load File.expand_path(File.join(File.dirname(__FILE__), 'projects.rb'))

include ForegroundShellout

PWD                     = File.expand_path(Dir.pwd)
RDOC_OUTPUT_DIR         = File.join(PWD, "rdoc")

directory("sources")

task :clone => "sources" do
  Dir.chdir("sources") do
    Project.each do |project|
      unless File.directory?(project.name.to_s)
        puts "cloning #{project}..."
        shellout("git clone #{project.repo} #{project.name}")
      end
    end
  end
end

desc "clone and/or update the project(s) sources"
task :pull => :clone do
  Project.each do |project|
    Dir.chdir("sources/#{project}") do
      puts "updating source for #{project}"
      shellout("git pull origin master")
      puts "fetching tags"
      shellout("git fetch origin --tags")
    end
  end
end

desc "generate rdoc documentation for all projects"
task :generate_docs => :pull do
  Project.each do |project|
    Dir.chdir("sources/#{project}") do
      project.each_tag do |tag|
        Dir.chdir(project.rdoc_dir) do
          cmd =   %w{sdoc}
          cmd << '-i' << "'lib/**/*'"
          cmd << '-x' << "'spec/*'"
          cmd << "-x" << "'docs/*'"
          cmd << '-m' << 'README.rdoc'
          cmd << '-f' << 'shtml'
          cmd << '-t' << '"Chef Developer Documentation"'
          cmd << '-T' << 'direct'
          cmd << '-o' << "#{RDOC_OUTPUT_DIR}/#{project}-#{tag}"
          shellout(cmd)
        end
      end
    end
  end
end

desc "regenerate the homepage"
task :nanoc_compile => :clean do
  shellout("nanoc compile")
end

desc "Update everything and build the site"
task :build_site => [:generate_docs, :nanoc_compile] do
  ln_sf(RDOC_OUTPUT_DIR, 'output/')
end

desc "show the project list"
task :list do
  Project.each { |p| puts p.to_text; puts }
end

