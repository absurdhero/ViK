require 'rubygems'
require 'rake'

begin
  require 'jeweler'
  Jeweler::Tasks.new do |gem|
    gem.name = "vik"
    gem.summary = %Q{A text editor}
    gem.description = %Q{It is slower than vim and less featureful than emacs.}
    gem.email = "bbremen@gmail.com"
    gem.homepage = "http://github.com/absurdhero/vik"
    gem.authors = ["Brandon Bremen"]
    gem.add_development_dependency "mocha", '~> 0.9.5'
    gem.executables = ['vik']
    # gem is a Gem::Specification... see http://www.rubygems.org/read/chapter/20 for additional settings
  end
rescue LoadError
  puts "Jeweler (or a dependency) not available. Install it with: sudo gem install jeweler"
end

require 'rake/testtask'
Rake::TestTask.new(:test) do |test|
  test.libs << 'lib'
  test.pattern = 'lib/**/*_test.rb'
  #test.verbose = true
end

begin
  require 'rcov/rcovtask'
  Rcov::RcovTask.new do |test|
    test.libs << 'lib'
    test.pattern = 'lib/**/*_test.rb'
    test.verbose = true
  end
rescue LoadError
  task :rcov do
    abort "RCov is not available. In order to run rcov, you must: sudo gem install rcov"
  end
end

task :default => :test

require 'rdoc/task'
RDoc::Task.new do |rdoc|
  if File.exist?('VERSION')
    version = File.read('VERSION')
  else
    version = ""
  end

  rdoc.rdoc_dir = 'rdoc'
  rdoc.title = "vik #{version}"
  rdoc.rdoc_files.include('README*')
  rdoc.rdoc_files.include('lib/**/*.rb')
end

