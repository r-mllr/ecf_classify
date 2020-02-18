require 'tempfile'

RSpec.describe EcfClassify::Zenodo do

  context "without downloading of files" do
    describe "status" do
      before(:all) do
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

      it "knows that there is nothing downloaded yet" do
        expect(EcfClassify::Zenodo.status).to be_nil
      end
    end
  end
  context "after downloading" do
    describe "status" do
      it "" do
        expect(EcfClassify::Zenodo.download).to eq(true)
        expect(EcfClassify::Zenodo.status).to include("zenodo")
      end
    end
  end
end
