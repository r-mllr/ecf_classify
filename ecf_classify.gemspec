lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "ecf_classify/version"

Gem::Specification.new do |spec|
  spec.name          = EcfClassify::NAME
  spec.version       = EcfClassify::VERSION
  spec.authors       = ["Delia Casas Pastor","Raphael Müller"]
  spec.email         = ["raphael.mueller@computational.bio.uni-giessen.de"]

  spec.summary       = %q{Gem for installing and running the ECF classify tool}
  spec.description   = %q{}
  spec.homepage      = "http://ecfclassify.computational.bio"
  spec.license       = "GPL3"

  # Prevent pushing this gem to RubyGems.org. To allow pushes either set the 'allowed_push_host'
  # to allow pushing to a single host or delete this section to allow pushing to any host.
  if spec.respond_to?(:metadata)
    spec.metadata["allowed_push_host"] = "http://rubygems.org"
  else
    raise "RubyGems 2.0 or newer is required to protect against " \
      "public gem pushes."
  end

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files         = Dir.chdir(File.expand_path('..', __FILE__)) do
    excludes = %w{Dockerfile}
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }.reject {|f| excludes.include? f}
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 2.0"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.0"
  spec.add_development_dependency "aruba", "~> 0.14"

  spec.add_dependency "thor", "~> 0.20"


end
