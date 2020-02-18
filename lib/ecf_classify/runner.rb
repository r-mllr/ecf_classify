require 'tempfile'

module EcfClassify
  module Runner

    def self.general(seqs,file)
      general = Tempfile.new("general")
      sigma3 = Tempfile.new("sigma3")
      pfam = Tempfile.new("pfam")
      begin
        out = HMMER.hmmsearch(seqs,general.path,:general) 
        raise out[0] if out[1] != 0
        out = HMMER.hmmsearch(seqs,sigma3.path,:sigma3)
        raise out[0] if out[1] != 0
        out = HMMER.hmmsearch(seqs,pfam.path,:sigma2_4) 
        raise out[0] if out[1] != 0
        script = Utils.path("lib/scripts/extract_ECF.py")
        out = `python3 #{script} --general #{general.path} --pfam #{pfam.path} --sigma3 #{sigma3.path} --infile #{seqs} --conserved #{file}`
        raise unless $?.success?
      ensure
        [general,sigma3,pfam].map(&:close)
        [general,sigma3,pfam].map(&:unlink)
      end
      return out
    end

    def self.specific(seqs, type, probabilities = nil)
      ungrouped = nil
      stats = nil
      th = nil
      case type
      when :groups
        th = 0.0016
        stats = Utils.path("data/statistics/groups.txt")
        ungrouped = "Ungrouped"
      when :subgroups
        th = 0.0041
        stats = Utils.path("data/statistics/subgroups.txt")
        ungrouped = "Unsubgrouped"
      else
        raise "type #{type} unknown"
      end
      specific = Tempfile.new("#{type}")
      begin
        out = HMMER.hmmsearch(seqs,specific.path,type) 
        raise out[0] if out[1] != 0
        script = Utils.path("lib/scripts/classify.py")
        cmd = "python3 #{script} --hmm-result #{specific.path} --th #{th} --stats-file #{stats} --ungrouped #{ungrouped}"
        if probabilities
          cmd += " --probabilities #{probabilities}"
        end
        out = `#{cmd}`
        raise unless $?.success?
      ensure
        specific.close
        specific.unlink
      end
      return out
    end
  end
end
