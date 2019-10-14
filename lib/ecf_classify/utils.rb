#require_relative 'version'

module EcfClassify
  module Utils
    def self.path(path)
      t = ["#{File.dirname(File.expand_path($0))}/../lib/#{EcfClassify::NAME}",
        "#{Gem.dir}/gems/#{EcfClassify::NAME}-#{EcfClassify::VERSION}/lib/#{EcfClassify::NAME}",
        "vendor/gems/#{EcfClassify::NAME}-#{EcfClassify::VERSION}/lib/#{EcfClassify::NAME}"
      ]
      t.each { |i| return File.join(i,"..","..",path) if File.readable?(i)}
      raise "all paths are invalid: #{t}"
    end
  end
end

