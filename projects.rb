project(:chef) do |p|
  p.repo "git://github.com/opscode/chef.git"
  p.tags :master, :release, '0.8.16'
  p.rdoc_dir "chef"
end

project(:bunny) do |p|
  p.repo "git://github.com/celldee/bunny.git"
end

project(:moneta) { |m| m.repo "git://github.com/wycats/moneta.git" }

%w{mixlib-authentication mixlib-cli mixlib-config mixlib-log}.each do |mixlib|
  project(mixlib) { |m| m.repo "git://github.com/opscode/#{mixlib}.git" }
end
