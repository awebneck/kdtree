require 'spec_helper'

describe KDTree do
  it "should exist" do
    Module.constants.should include :KDTree
    KDTree.should be_a Class
  end

  describe "constructor" do
    it "should accept a single argument, which must be an array" do
      lambda { KDTree.new }.should raise_error
      lambda { KDTree.new(5) }.should raise_error
      lambda { KDTree.new([]) }.should_not raise_error
    end

    it "should accept an array of k-dimensional arrays of numerics" do
      lambda { KDTree.new([[1,2,3],[4,5,6]])}.should_not raise_error
    end

    it "should accept an array of k-dimensional points of numerics" do
      lambda { KDTree.new([KDTree::Point.new([1,2,3]),KDTree::Point.new([4,5,6])])}.should_not raise_error
    end
  end
end
