require 'open-uri'

module EcfClassify
  module Zenodo

    PATH = ""
    RECORD_URL = 'https://zenodo.org/record/3672544/'
    FILES = {
      :general              => "ecf_general_model.hmm",
      :sigma3               => "Sigma70_r3.hmm",
      :sigma2_4             => "Sigma70_r2_r4.hmm",
      :groups               => "all_ecf_groups.hmm",
      :subgroups            => "all_ecf_subgroups.hmm",
      :groups_statistics    => "groups_statistics.txt",
      :subgroups_statistics => "subgroups_statistics.txt",
    }
    STATUS_FILE = "status.txt"

 ## downloads the current dataset
 ##
 ## returns
 ##   true if everything is ok
    def self.download
      perma_record = URI.open(RECORD_URL)
      FILES.each do |key,file|
        download = open(perma_record.base_uri.to_s + "/files/" + file)
        IO.copy_stream(download, path(key))
        if(file.split(".").last == "hmm")
          EcfClassify::HMMER.hmmpress(path(key))
        end
      end
      open(path(STATUS_FILE),"w"){ |f| f.puts perma_record.base_uri.to_s }
      true
    end

 ## get the status of the download
 ##
 ## returns the current doi if the dataset is complete
 ## returns nil if the data is not there or incomplete
 ## 
    def self.status
      if File.exists? path(STATUS_FILE)
        return File.read(path(STATUS_FILE))
      else
        return nil
      end
    end

    def self.check

    end

    def self.file

    end

    def self.path(name)
      File.expand_path('../../../data/' + (FILES[name] || name.to_s) , __FILE__)
    end
  end
end
