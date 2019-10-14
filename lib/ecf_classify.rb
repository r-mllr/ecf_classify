require "ecf_classify/version"
require "ecf_classify/runner"
require "ecf_classify/utils"
require "tempfile"
require 'thor'

module EcfClassify
  class CLI < Thor
    package_name "ecf_classify"
    class_option :help, aliases: "-h", type: :boolean

    desc "groups [FILE]", "Classifies protein sequences into ECF groups"
    method_option :probabilities, type: :string, aliases: "-p", default: nil
    def groups(file)
      handle_help_option(__method__)

      conserved = Tempfile.new("conserved")
      begin
        STDERR.puts EcfClassify::Runner.general(file,conserved.path)
        conserved.rewind
        STDOUT.puts EcfClassify::Runner.specific(conserved.path, __method__, options.probabilities)
      ensure
        conserved.close
        conserved.unlink
      end
    end

    desc "subgroups [FILE]", "Classifies protein sequences into ECF subgroups"
    method_option :probabilities, type: :string, aliases: "-p", default: nil
    def subgroups(file)
      handle_help_option(__method__)

      conserved = Tempfile.new("conserved")
      begin
        STDERR.puts EcfClassify::Runner.general(file,conserved.path)
        conserved.rewind
        STDOUT.puts EcfClassify::Runner.specific(conserved.path, __method__, options.probabilities)
      ensure
        conserved.close
        conserved.unlink
      end
    end

    no_commands do
      def handle_help_option(method_name)
        if options[:help]
          help(method_name)
          exit
        end
      end
    end
  end
end
