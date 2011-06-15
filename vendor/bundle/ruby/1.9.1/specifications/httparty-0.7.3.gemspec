# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{httparty}
  s.version = "0.7.3"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["John Nunemaker", "Sandro Turriate"]
  s.date = %q{2011-01-20}
  s.default_executable = %q{httparty}
  s.description = %q{Makes http fun! Also, makes consuming restful web services dead easy.}
  s.email = %q{nunemaker@gmail.com}
  s.executables = ["httparty"]
  s.files = ["examples/aaws.rb", "examples/basic.rb", "examples/custom_parsers.rb", "examples/delicious.rb", "examples/google.rb", "examples/rubyurl.rb", "examples/tripit_sign_in.rb", "examples/twitter.rb", "examples/whoismyrep.rb", "spec/httparty/cookie_hash_spec.rb", "spec/httparty/net_digest_auth_spec.rb", "spec/httparty/parser_spec.rb", "spec/httparty/request_spec.rb", "spec/httparty/response_spec.rb", "spec/httparty/ssl_spec.rb", "spec/httparty_spec.rb", "spec/spec_helper.rb", "spec/support/ssl_test_helper.rb", "spec/support/ssl_test_server.rb", "spec/support/stub_response.rb", "bin/httparty"]
  s.homepage = %q{http://httparty.rubyforge.org}
  s.post_install_message = %q{When you HTTParty, you must party hard!}
  s.require_paths = ["lib"]
  s.rubygems_version = %q{1.6.1}
  s.summary = %q{Makes http fun! Also, makes consuming restful web services dead easy.}
  s.test_files = ["examples/aaws.rb", "examples/basic.rb", "examples/custom_parsers.rb", "examples/delicious.rb", "examples/google.rb", "examples/rubyurl.rb", "examples/tripit_sign_in.rb", "examples/twitter.rb", "examples/whoismyrep.rb", "spec/httparty/cookie_hash_spec.rb", "spec/httparty/net_digest_auth_spec.rb", "spec/httparty/parser_spec.rb", "spec/httparty/request_spec.rb", "spec/httparty/response_spec.rb", "spec/httparty/ssl_spec.rb", "spec/httparty_spec.rb", "spec/spec_helper.rb", "spec/support/ssl_test_helper.rb", "spec/support/ssl_test_server.rb", "spec/support/stub_response.rb"]

  if s.respond_to? :specification_version then
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<crack>, ["= 0.1.8"])
      s.add_development_dependency(%q<activesupport>, ["~> 2.3"])
      s.add_development_dependency(%q<cucumber>, ["~> 0.7"])
      s.add_development_dependency(%q<fakeweb>, ["~> 1.2"])
      s.add_development_dependency(%q<rspec>, ["~> 1.3"])
      s.add_development_dependency(%q<jeweler>, ["~> 1.5"])
      s.add_development_dependency(%q<mongrel>, ["= 1.2.0.pre2"])
    else
      s.add_dependency(%q<crack>, ["= 0.1.8"])
      s.add_dependency(%q<activesupport>, ["~> 2.3"])
      s.add_dependency(%q<cucumber>, ["~> 0.7"])
      s.add_dependency(%q<fakeweb>, ["~> 1.2"])
      s.add_dependency(%q<rspec>, ["~> 1.3"])
      s.add_dependency(%q<jeweler>, ["~> 1.5"])
      s.add_dependency(%q<mongrel>, ["= 1.2.0.pre2"])
    end
  else
    s.add_dependency(%q<crack>, ["= 0.1.8"])
    s.add_dependency(%q<activesupport>, ["~> 2.3"])
    s.add_dependency(%q<cucumber>, ["~> 0.7"])
    s.add_dependency(%q<fakeweb>, ["~> 1.2"])
    s.add_dependency(%q<rspec>, ["~> 1.3"])
    s.add_dependency(%q<jeweler>, ["~> 1.5"])
    s.add_dependency(%q<mongrel>, ["= 1.2.0.pre2"])
  end
end
