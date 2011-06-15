# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{browser}
  s.version = "0.1.2"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Nando Vieira"]
  s.date = %q{2010-10-27}
  s.email = %q{fnando.vieira@gmail.com}
  s.files = ["test/browser_test.rb"]
  s.homepage = %q{http://github.com/fnando/browser}
  s.require_paths = ["lib"]
  s.rubygems_version = %q{1.6.1}
  s.summary = %q{Do some browser detection with Ruby.}
  s.test_files = ["test/browser_test.rb"]

  if s.respond_to? :specification_version then
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
    else
    end
  else
  end
end
