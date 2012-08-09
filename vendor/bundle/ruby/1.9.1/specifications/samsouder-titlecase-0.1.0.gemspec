# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{samsouder-titlecase}
  s.version = "0.1.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Samuel Souder"]
  s.date = %q{2008-05-23}
  s.description = %q{titlecase is a set of methods on the Ruby String class to add title casing support as seen on Daring Fireball <http://daringfireball.net/2008/05/title_case>.}
  s.email = %q{samsouder@gmail.com}
  s.homepage = %q{http://github.com/samsouder/titlecase}
  s.require_paths = ["lib"]
  s.rubygems_version = %q{1.6.1}
  s.summary = %q{String methods to properly title case a headline.}

  if s.respond_to? :specification_version then
    s.specification_version = 2

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
    else
    end
  else
  end
end
