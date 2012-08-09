# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{slug}
  s.version = "0.5.7"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Ben Koski"]
  s.date = %q{2010-06-25}
  s.description = %q{Simple, straightforward slugs for your ActiveRecord models.}
  s.email = %q{ben.koski@gmail.com}
  s.files = ["test/models.rb", "test/schema.rb", "test/test_helper.rb", "test/test_slug.rb"]
  s.homepage = %q{http://github.com/bkoski/slug}
  s.require_paths = ["lib"]
  s.rubygems_version = %q{1.6.1}
  s.summary = %q{Simple, straightforward slugs for your ActiveRecord models.}
  s.test_files = ["test/models.rb", "test/schema.rb", "test/test_helper.rb", "test/test_slug.rb"]

  if s.respond_to? :specification_version then
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<activerecord>, [">= 0"])
      s.add_runtime_dependency(%q<activesupport>, [">= 0"])
    else
      s.add_dependency(%q<activerecord>, [">= 0"])
      s.add_dependency(%q<activesupport>, [">= 0"])
    end
  else
    s.add_dependency(%q<activerecord>, [">= 0"])
    s.add_dependency(%q<activesupport>, [">= 0"])
  end
end
