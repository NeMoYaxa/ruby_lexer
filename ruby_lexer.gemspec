# frozen_string_literal: true

require_relative "lib/ruby_lexer/version"

Gem::Specification.new do |spec|
  spec.name = "ruby_lexer"
  spec.version = RubyLexer::VERSION
  spec.authors = ["Yakov Batuev"]
  spec.email = ["batuev@sfedu.ru"]

  spec.summary = "A lexical analyzer for parsing source code into tokens.."
  spec.description = "A lexical analyzer for parsing source code into tokens."
  spec.homepage = "https://github.com/NeMoYaxa/ruby_lexer"
  spec.license = "MIT"
  spec.required_ruby_version = ">= 3.2.0"
  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "https://github.com/NeMoYaxa/ruby_lexer"
  spec.metadata["changelog_uri"] = "https://github.com/YOUR_USERNAME/NeMoYaxa/blob/main/CHANGELOG.md"
  spec.metadata["rubygems_mfa_required"] = "true"

  gemspec = File.basename(__FILE__)
  spec.files = IO.popen(%w[git ls-files -z], chdir: __dir__, err: IO::NULL) do |ls|
    ls.readlines("\x0", chomp: true).reject do |f|
      (f == gemspec) ||
        f.start_with?(*%w[bin/ Gemfile .gitignore test/ .github/ .rubocop.yml])
    end
  end
  spec.bindir = "exe"
  spec.executables = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]
end
