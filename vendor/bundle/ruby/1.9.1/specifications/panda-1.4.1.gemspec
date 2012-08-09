# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{panda}
  s.version = "1.4.1"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["New Bamboo"]
  s.date = %q{2011-02-03}
  s.description = %q{Panda Client}
  s.email = ["info@pandastream.com"]
  s.files = ["spec/cloud_spec.rb", "spec/encoding_spec.rb", "spec/heroku_spec.rb", "spec/panda_spec.rb", "spec/profile_spec.rb", "spec/spec_helper.rb", "spec/video_spec.rb"]
  s.homepage = %q{http://github.com/newbamboo/panda_gem}
  s.require_paths = ["lib"]
  s.rubyforge_project = %q{panda}
  s.rubygems_version = %q{1.6.1}
  s.summary = %q{Panda Client}
  s.test_files = ["spec/cloud_spec.rb", "spec/encoding_spec.rb", "spec/heroku_spec.rb", "spec/panda_spec.rb", "spec/profile_spec.rb", "spec/spec_helper.rb", "spec/video_spec.rb"]

  if s.respond_to? :specification_version then
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<ruby-hmac>, [">= 0.3.2"])
      s.add_runtime_dependency(%q<rest-client>, [">= 0"])
      s.add_runtime_dependency(%q<json>, [">= 0"])
      s.add_development_dependency(%q<timecop>, [">= 0"])
      s.add_development_dependency(%q<rspec>, ["= 2.4.0"])
      s.add_development_dependency(%q<webmock>, [">= 0"])
    else
      s.add_dependency(%q<ruby-hmac>, [">= 0.3.2"])
      s.add_dependency(%q<rest-client>, [">= 0"])
      s.add_dependency(%q<json>, [">= 0"])
      s.add_dependency(%q<timecop>, [">= 0"])
      s.add_dependency(%q<rspec>, ["= 2.4.0"])
      s.add_dependency(%q<webmock>, [">= 0"])
    end
  else
    s.add_dependency(%q<ruby-hmac>, [">= 0.3.2"])
    s.add_dependency(%q<rest-client>, [">= 0"])
    s.add_dependency(%q<json>, [">= 0"])
    s.add_dependency(%q<timecop>, [">= 0"])
    s.add_dependency(%q<rspec>, ["= 2.4.0"])
    s.add_dependency(%q<webmock>, [">= 0"])
  end
end
