# encoding: UTF-8
require 'rubygems'
require 'rake'

require 'rake/testtask'

Rake::TestTask.new(:test) do |test|
    test.libs << 'lib' << 'test'
    test.pattern = 'test/test_*.rb'
    test.verbose = true
end

task :default => :test

require 'rdoc/task'
RDoc::Task.new do |rdoc|
    if File.exist?('VERSION.yml')
        config = YAML.load(File.read('VERSION.yml'))
        version = "#{config[:major]}.#{config[:minor]}.#{config[:patch]}"
    else
        version = ""
    end

    rdoc.rdoc_dir = 'rdoc'
    rdoc.title = "sendwithus #{version}"
    rdoc.rdoc_files.include('README*')
    rdoc.rdoc_files.include('lib/**/*.rb')
end
