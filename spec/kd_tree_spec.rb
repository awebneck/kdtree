require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe KDTree do
  it "should exist" do
    Module.constants.should include :KDTree
    KDTree.should be_a Module
  end
end
