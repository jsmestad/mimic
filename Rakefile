require 'cucumber'
require 'cucumber/rake/task'

ENV["POSER_TEST_PROXY"] = nil

desc "Run all Cucumber features"
Cucumber::Rake::Task.new(:features) do |t|
  t.cucumber_opts = "features --format pretty"
end

task :all => [:spec, :features]

require "bundler/gem_tasks"
require "rspec/core/rake_task"

RSpec::Core::RakeTask.new(:spec)

task :default => :spec

require 'yard'

YARD::Rake::YardocTask.new do |t|
  t.files   = ['lib/**/*.rb']   # optional
  t.options = ['--any', '--extra', '--opts'] # optional
end
