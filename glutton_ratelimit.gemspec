# Generated by jeweler
# DO NOT EDIT THIS FILE DIRECTLY
# Instead, edit Jeweler::Tasks in Rakefile, and run the gemspec command
# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{glutton_ratelimit}
  s.version = "0.1.2"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Wally Glutton"]
  s.date = %q{2010-06-10}
  s.description = %q{A Ruby library for limiting the number of times a method can be invoked within a specified time period.}
  s.email = %q{stungeye@gmail.com}
  s.extra_rdoc_files = [
    "LICENSE",
     "README.rdoc"
  ]
  s.files = [
    ".document",
     ".gitignore",
     "LICENSE",
     "README.rdoc",
     "Rakefile",
     "VERSION",
     "examples/limit_instance_methods.rb",
     "examples/simple_manual.rb",
     "glutton_ratelimit.gemspec",
     "lib/glutton_ratelimit.rb",
     "lib/glutton_ratelimit/averaged_throttle.rb",
     "lib/glutton_ratelimit/bursty_ring_buffer.rb",
     "lib/glutton_ratelimit/bursty_token_bucket.rb",
     "test/helper.rb",
     "test/test_glutton_ratelimit_averaged_throttle.rb",
     "test/test_glutton_ratelimit_bursty_ring_buffer.rb",
     "test/test_glutton_ratelimit_bursty_token_bucket.rb",
     "test/testing_module.rb"
  ]
  s.homepage = %q{http://github.com/stungeye/glutton_ratelimit}
  s.rdoc_options = ["--charset=UTF-8"]
  s.require_paths = ["lib"]
  s.rubygems_version = %q{1.3.6}
  s.summary = %q{Simple Ruby library for self-imposed rater-limiting.}
  s.test_files = [
    "test/test_glutton_ratelimit_averaged_throttle.rb",
     "test/helper.rb",
     "test/test_glutton_ratelimit_bursty_ring_buffer.rb",
     "test/testing_module.rb",
     "test/test_glutton_ratelimit_bursty_token_bucket.rb",
     "examples/limit_instance_methods.rb",
     "examples/simple_manual.rb"
  ]

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 3

    if Gem::Version.new(Gem::RubyGemsVersion) >= Gem::Version.new('1.2.0') then
    else
    end
  else
  end
end

