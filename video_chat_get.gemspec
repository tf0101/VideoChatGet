
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "video_chat_get/version"

Gem::Specification.new do |spec|
  spec.name          = "video_chat_get"
  spec.version       = VideoChatGet::VERSION
  spec.authors       = ["tf0101"]
  spec.email         = ["tf0101_sh@icloud.com"]

  spec.summary       = %q{videochat scraping package}
  spec.description   = %q{videochat scraping}
  spec.homepage      = "https://github.com/tf0101/VideoChatGet"
  spec.license       = "MIT"



  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.16"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.0"

  spec.add_dependency "httpclient", "~> 2.8.3"
  spec.add_dependency "json", "~> 2.3.0"
  spec.add_dependency "nokogiri", "~> 1.10.9"

end
