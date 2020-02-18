module EcfClassify
  module Zenodo

    PATH = ""
    DOI = ""
    FILES = []
    STATUS_FILE = ""

 ## downloads the current dataset
 ##
 ## returns the html status code
 ##   200 if everything is ok
    def self.download

    end

 ## get the status of the download
 ##
 ## returns the current doi if the dataset is complete
 ## returns nil if the data is not there or incomplete
 ## 
    def self.status

    end

    def self.check

    end

    private

    def self.rel_path(file)
      File.expand_path('../../../data/' + file , __FILE__)
    end
  end
end
