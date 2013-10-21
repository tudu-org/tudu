require 'spec_helper'

describe Tudusched::Manifest do
  before :each do
    @manifest = Tudusched.load_manifest_file 'manifest/test_dispatch_one.json'
  end

  it "should return a Manifest object" do
    @manifest.should be_an_instance_of Tudusched::Manifest
  end
end
