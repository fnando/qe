# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "qe/version"

Gem::Specification.new do |s|
  s.name        = "qe"
  s.version     = Qe::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Nando Vieira"]
  s.email       = ["fnando.vieira@gmail.com"]
  s.homepage    = "http://rubygems.org/gems/qe"
  s.summary     = "A simple interface over several background job libraries like Resque, Sidekiq and DelayedJob."
  s.description = s.summary

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  s.add_development_dependency "sidekiq"
  s.add_development_dependency "qu"
  s.add_development_dependency "delayed_job_active_record"
  s.add_development_dependency "backburner"
  s.add_development_dependency "resque"
  s.add_development_dependency "resque-scheduler"

  s.add_development_dependency "activerecord"
  s.add_development_dependency "awesome_print"
  s.add_development_dependency "pry"
  s.add_development_dependency "rspec"
  s.add_development_dependency "sqlite3"
end
