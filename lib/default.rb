RDOC_FOLDER = File.expand_path(File.dirname(__FILE__) + '/../rdoc')

def rdoc_projects
  proj = Dir["#{RDOC_FOLDER}/*"].map { |d| File.basename(d) }
  STDERR.puts proj.inspect
  proj
end

def link_to_project(project)
  %Q|<a href="/rdoc/#{project}/">#{project}</a>|
end