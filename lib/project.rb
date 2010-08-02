require 'grit'
require 'rubygems'

class Project
  include ForegroundShellout
  include Grit

  def self.list
    @project_list ||= []
  end

  def self.each
    list.each { |p| yield p }
  end

  def self.add(name, &block)
    list << new(name, &block)
  end

  attr_reader :name

  def initialize(name, &block)
    @name = name
    @repo = nil
    @tags = [:release]
    @rdoc_dir = '.'
    yield self if block_given?
  end

  def repo(repo=nil)
    @repo = repo unless repo.nil?
    @repo
  end

  def tags(*tags)
    @tags = tags unless tags.empty?
    @tags
  end

  # e.g., the chef source tree has chef/ chef-server/, etc., we want to rdoc from
  # the chef/ subdir
  def rdoc_dir(subdir=nil)
    @rdoc_dir = subdir unless subdir.nil?
    @rdoc_dir
  end

  def each_tag
    resolved_tags.each do |tag|
      puts "checking out #{name} at #{tag}"
      checkout(tag)
      yield tag
    end
  ensure
    checkout("master")
  end

  def resolved_tags
    @resolved_tags ||= begin
      tags.map { |t| resolve_tag(t) }
    end
  end

  def resolve_tag(tag)
    if tag == :release
      repo = Repo.new(".git")
      releases = repo.tags.map(&:name).select { |t| t !~ /[a-z]/i }.map { |v| Gem::Version.new(v) }
      releases.sort.last.to_s
    else
      tag
    end
  end

  def to_s
    name.to_s
  end

  def to_text
    text = ""
    text << "project(#{name.inspect}) do |p|\n"
    text << "  p.repo(#{repo})\n"
    text << "  p.tags(#{tags.inspect})\n"
    text << "  p.rdoc_dir(#{rdoc_dir.inspect})\n"
    text << "end\n"
    text
  end

  def checkout(tag)
    shellout("git checkout #{tag}")
  end

end

def project(name, &block)
  Project.add(name, &block)
end