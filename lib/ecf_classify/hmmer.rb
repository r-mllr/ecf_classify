module EcfClassify
  module HMMER
    DBLOCATION = {
      :general   => "data/HMM_general/all.hmm",
      :sigma3    => "data/HMM_s3/Sigma70_r3.hmm",
      :pfam      => "data/Pfam_domains/sigma2and4.hmm",
      :groups    => "data/HMM_groups/all_models.hmm",
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
        return ["No such database", 2]
      end
    end

    def self.hmmsearch(infile, outfile, db)
      if DBLOCATION.key? db
        hmm = Utils.path(DBLOCATION[db])
        cmd = "hmmsearch --noali --domtblout #{outfile} #{Utils.path(DBLOCATION[db])} #{infile} 2>&1"
        out = `#{cmd}`
        return [out, $?.exitstatus]
      else
        return ["No such database", 2]
      end
    end

    def self.hmmpress(file)
      Dir.glob("#{file}.h3{i,f,m,p}").each { |f| File.delete(f) }
      cmd = "hmmpress #{file}"
      out = `#{cmd}`
      return [out, $?.exitstatus ]
    end
  end
end
