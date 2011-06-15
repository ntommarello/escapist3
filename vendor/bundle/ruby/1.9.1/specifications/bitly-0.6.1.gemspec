# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{bitly}
  s.version = "0.6.1"

  s.required_rubygems_version = Gem::Requirement.new(">= 1.2") if s.respond_to? :required_rubygems_version=
  s.authors = ["Phil Nash"]
  s.date = %q{2011-01-11}
  s.description = %q{Use the bit.ly API to shorten or expand URLs}
  s.email = %q{philnash@gmail.com}
  s.files = ["test/bitly/test_client.rb", "test/bitly/test_url.rb", "test/bitly/test_utils.rb", "test/test_helper.rb"]
  s.homepage = %q{http://github.com/philnash/bitly}
  s.require_paths = ["lib"]
  s.rubyforge_project = %q{bitly}
  s.rubygems_version = %q{1.6.1}
  s.summary = %q{Use the bit.ly API to shorten or expand URLs}
  s.test_files = ["test/bitly/test_client.rb", "test/bitly/test_url.rb", "test/bitly/test_utils.rb", "test/test_helper.rb"]

  if s.respond_to? :specification_version then
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<crack>, [">= 0.1.4"])
      s.add_runtime_dependency(%q<httparty>, [">= 0.5.2"])
      s.add_runtime_dependency(%q<oauth2>, [">= 0.1.1"])
    else
      s.add_dependency(%q<crack>, [">= 0.1.4"])
      s.add_dependency(%q<httparty>, [">= 0.5.2"])
      s.add_dependency(%q<oauth2>, [">= 0.1.1"])
    end
  else
    s.add_dependency(%q<crack>, [">= 0.1.4"])
    s.add_dependency(%q<httparty>, [">= 0.5.2"])
    s.add_dependency(%q<oauth2>, [">= 0.1.1"])
  end
end
