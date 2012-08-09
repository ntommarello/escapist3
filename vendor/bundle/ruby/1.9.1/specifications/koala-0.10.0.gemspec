# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{koala}
  s.version = "0.10.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 1.2") if s.respond_to? :required_rubygems_version=
  s.authors = ["Alex Koppel, Chris Baclig, Rafi Jacoby, Context Optional"]
  s.date = %q{2010-12-14}
  s.description = %q{Koala is a lightweight, flexible Ruby SDK for Facebook.  It allows read/write access to the social graph via the Graph API and the older REST API, as well as support for realtime updates and OAuth and Facebook Connect authentication.  Koala is fully tested and supports Net::HTTP and Typhoeus connections out of the box and can accept custom modules for other services.}
  s.email = %q{alex@alexkoppel.com}
  s.homepage = %q{http://github.com/arsduo/koala}
  s.require_paths = ["lib"]
  s.rubyforge_project = %q{koala}
  s.rubygems_version = %q{1.6.1}
  s.summary = %q{A lightweight, flexible library for Facebook with support for the Graph API, the old REST API, realtime updates, and OAuth validation.}

  if s.respond_to? :specification_version then
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<json>, [">= 1.0"])
    else
      s.add_dependency(%q<json>, [">= 1.0"])
    end
  else
    s.add_dependency(%q<json>, [">= 1.0"])
  end
end
