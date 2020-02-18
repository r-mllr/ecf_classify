require 'tempfile'

RSpec.describe EcfClassify::Zenodo do

  context "without downloading of files" do
    describe "status" do
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
