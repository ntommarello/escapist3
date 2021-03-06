# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{multi_xml}
  s.version = "0.2.1"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Erik Michaels-Ober"]
  s.date = %q{2011-02-03}
  s.description = %q{A gem to provide swappable XML backends utilizing LibXML, Nokogiri, or REXML.}
  s.email = ["sferik@gmail.com"]
  s.files = ["spec/multi_xml_spec.rb", "spec/spec_helper.rb"]
  s.homepage = %q{http://rubygems.org/gems/multi_xml}
  s.require_paths = ["lib"]
  s.rubyforge_project = %q{multi_xml}
  s.rubygems_version = %q{1.6.1}
  s.summary = %q{A generic swappable back-end for XML parsing}
  s.test_files = ["spec/multi_xml_spec.rb", "spec/spec_helper.rb"]

  if s.respond_to? :specification_version then
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_development_dependency(%q<bundler>, ["~> 1.0"])
      s.add_development_dependency(%q<libxml-ruby>, ["~> 1.1"])
      s.add_development_dependency(%q<maruku>, ["~> 0.6"])
      s.add_development_dependency(%q<nokogiri>, ["~> 1.4"])
      s.add_development_dependency(%q<rake>, ["~> 0.8"])
      s.add_development_dependency(%q<rspec>, ["~> 2.4"])
      s.add_development_dependency(%q<simplecov>, ["~> 0.3"])
      s.add_development_dependency(%q<yard>, ["~> 0.6"])
      s.add_development_dependency(%q<ZenTest>, ["~> 4.4"])
    else
      s.add_dependency(%q<bundler>, ["~> 1.0"])
      s.add_dependency(%q<libxml-ruby>, ["~> 1.1"])
      s.add_dependency(%q<maruku>, ["~> 0.6"])
      s.add_dependency(%q<nokogiri>, ["~> 1.4"])
      s.add_dependency(%q<rake>, ["~> 0.8"])
      s.add_dependency(%q<rspec>, ["~> 2.4"])
      s.add_dependency(%q<simplecov>, ["~> 0.3"])
      s.add_dependency(%q<yard>, ["~> 0.6"])
      s.add_dependency(%q<ZenTest>, ["~> 4.4"])
    end
  else
    s.add_dependency(%q<bundler>, ["~> 1.0"])
    s.add_dependency(%q<libxml-ruby>, ["~> 1.1"])
    s.add_dependency(%q<maruku>, ["~> 0.6"])
    s.add_dependency(%q<nokogiri>, ["~> 1.4"])
    s.add_dependency(%q<rake>, ["~> 0.8"])
    s.add_dependency(%q<rspec>, ["~> 2.4"])
    s.add_dependency(%q<simplecov>, ["~> 0.3"])
    s.add_dependency(%q<yard>, ["~> 0.6"])
    s.add_dependency(%q<ZenTest>, ["~> 4.4"])
  end
end
