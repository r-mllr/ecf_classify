require 'tempfile'

module EcfClassify
  module Runner

    def self.general(seqs,file)
      general = Tempfile.new("general")
      sigma3 = Tempfile.new("sigma3")
      pfam = Tempfile.new("pfam")
      begin
        out = HMMER.hmmscan(seqs,general.path,:general) 
        raise out[0] if out[1] != 0
        out = HMMER.hmmscan(seqs,sigma3.path,:sigma3)
        raise out[0] if out[1] != 0
        out = HMMER.hmmscan(seqs,pfam.path,:pfam) 
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
        out = HMMER.hmmscan(seqs,specific.path,type) 
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

  module HMMER
    DBLOCATION = {
      :general => "data/HMM_general/all.hmm",
      :sigma3 => "data/HMM_s3/Sigma70_r3.hmm",
      :pfam => "data/Pfam_domains/sigma2and4.hmm",
      :groups => "data/HMM_groups/all_models.hmm",
      :subgroups => "data/HMM_subgroups/all_models.hmm",
    }
    def self.hmmscan(infile, outfile, db)
      if DBLOCATION.key? db
        hmm = Utils.path(DBLOCATION[db])
        if File.exists? hmm+".gz"
          num = File.read(infile).scan(%r{^>}).count
          subout = IO.popen("mkfifo #{hmm}; for i in {1..num}; do gunzip -c #{hmm}.gz > #{hmm}; done; rm #{hmm}")
        else
          subout = IO.popen("ls")
        end
        cmd = "hmmscan --noali --domtblout #{outfile} #{Utils.path(DBLOCATION[db])} #{infile} 2>&1"
        out = `#{cmd}`
        subout.close
        return [out,$?.exitstatus]
      else
        return ["No such database",2]
      end
    end
  end
end
