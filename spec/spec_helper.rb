require "bundler/setup"
require "ecf_classify"

RSpec.configure do |config|
  # Enable flags like --only-failures and --next-failure
  config.example_status_persistence_file_path = ".rspec_status"

  # Disable RSpec exposing methods globally on `Module` and `main`
  config.disable_monkey_patching!

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end

  config.before(:suite) do
    EcfClassify::Zenodo::FILES.each do |key,value|
      file = EcfClassify::Zenodo.path(value)
      if File.exists? file
        File.delete(file)
      end
    end
    file = EcfClassify::Zenodo.path(EcfClassify::Zenodo::STATUS_FILE)
    if File.exists? file
      File.delete(file)
    end
  end
end
