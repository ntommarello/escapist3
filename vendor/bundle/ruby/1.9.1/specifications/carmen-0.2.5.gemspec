# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{carmen}
  s.version = "0.2.5"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Jim Benton"]
  s.date = %q{2011-01-28}
  s.description = %q{A collection of geographic country and state names for Ruby. Also includes replacements for Rails' country_select and state_select plugins}
  s.email = %q{jim@autonomousmachine.com}
  s.files = ["test/carmen_test.rb", "test/carmen_view_helper_test.rb", "test/test_helper.rb"]
  s.homepage = %q{http://github.com/jim/carmen}
  s.require_paths = ["lib"]
  s.rubygems_version = %q{1.6.1}
  s.summary = %q{A collection of geographic country and state names for Ruby}
  s.test_files = ["test/carmen_test.rb", "test/carmen_view_helper_test.rb", "test/test_helper.rb"]

  if s.respond_to? :specification_version then
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_development_dependency(%q<mocha>, [">= 0"])
      s.add_development_dependency(%q<rails>, [">= 0"])
      s.add_development_dependency(%q<hanna>, [">= 0"])
    else
      s.add_dependency(%q<mocha>, [">= 0"])
      s.add_dependency(%q<rails>, [">= 0"])
      s.add_dependency(%q<hanna>, [">= 0"])
    end
  else
    s.add_dependency(%q<mocha>, [">= 0"])
    s.add_dependency(%q<rails>, [">= 0"])
    s.add_dependency(%q<hanna>, [">= 0"])
  end
end
