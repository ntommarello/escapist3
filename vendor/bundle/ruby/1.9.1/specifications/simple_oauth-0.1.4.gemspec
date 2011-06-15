# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{simple_oauth}
  s.version = "0.1.4"

  s.required_rubygems_version = Gem::Requirement.new(">= 1.3.6") if s.respond_to? :required_rubygems_version=
  s.authors = ["Steve Richert"]
  s.date = %q{2011-02-03}
  s.description = %q{Simply builds and verifies OAuth headers}
  s.email = %q{steve.richert@gmail.com}
  s.homepage = %q{http://github.com/laserlemon/simple_oauth}
  s.require_paths = ["lib"]
  s.rubygems_version = %q{1.6.1}
  s.summary = %q{Simply builds and verifies OAuth headers}

  if s.respond_to? :specification_version then
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_development_dependency(%q<mocha>, [">= 0"])
    else
      s.add_dependency(%q<mocha>, [">= 0"])
    end
  else
    s.add_dependency(%q<mocha>, [">= 0"])
  end
end
