require 'spec_helper'

describe KDTree::HyperRect do
  it "should exist" do
    KDTree.constants.should include :HyperRect
    KDTree::HyperRect.should be_a Class
  end

  describe "constructor" do
    it "should accept a single argument, no more, no less" do
      lambda { KDTree::HyperRect.new(5) }.should_not raise_error
      lambda { KDTree::HyperRect.new(5, 6) }.should raise_error
      lambda { KDTree::HyperRect.new }.should raise_error
    end

    it "should initialize the minima to an array of k elements equal to negative infinity" do
      rect = KDTree::HyperRect.new(3)
      rect.minima.length.should == 3
      rect.minima.all? { |el| el == -Float::INFINITY }.should be_true
    end

    it "should initialize the maxima to an array of k elements equal to infinity" do
      rect = KDTree::HyperRect.new(3)
      rect.maxima.length.should == 3
      rect.maxima.all? { |el| el == Float::INFINITY }.should be_true
    end
  end

  describe "clone" do
    it "should deep-clone the minima" do
      x = KDTree::HyperRect.new 3
      x.minima[0] = 1
      x.minima[1] = 2
      x.minima[2] = 3
      y = x.clone
      y.minima[0] = 5
      y.minima[1] = 6
      y.minima[2] = 7
      x.minima[0].should == 1
      x.minima[1].should == 2
      x.minima[2].should == 3
    end

    it "should deep-clone the maxima" do
      x = KDTree::HyperRect.new 3
      x.maxima[0] = 1
      x.maxima[1] = 2
      x.maxima[2] = 3
      y = x.clone
      y.maxima[0] = 5
      y.maxima[1] = 6
      y.maxima[2] = 7
      x.maxima[0].should == 1
      x.maxima[1].should == 2
      x.maxima[2].should == 3
    end
  end

  describe "cut" do
    it "should exist" do
      rect = KDTree::HyperRect.new(3)
      rect.should respond_to :cut
    end

    it "should take two arguments, no more, no less" do
      rect = KDTree::HyperRect.new(3)
      lambda { rect.cut 1, 1 }.should_not raise_error
      lambda { rect.cut 1 }.should raise_error
      lambda { rect.cut 1, 1, 1 }.should raise_error
      lambda { rect.cut }.should raise_error
    end

    it "should return an array of two hyperrects" do
      rect = KDTree::HyperRect.new(3)
      result = rect.cut(1,2)
      result.should be_a Array
      result.length.should == 2
      result[0].should be_a KDTree::HyperRect
      result[1].should be_a KDTree::HyperRect
      result[0].should_not == result[1]
    end

    it "should return a first hyperrect with its maxima at coord dim set to the split, and no other coords altered" do
      rect = KDTree::HyperRect.new(3)
      first = rect.cut(1,2)[0]
      first.minima[0].should == -Float::INFINITY
      first.minima[1].should == -Float::INFINITY
      first.minima[2].should == -Float::INFINITY
      first.maxima[0].should == Float::INFINITY
      first.maxima[1].should == 2
      first.maxima[2].should == Float::INFINITY
    end

    it "should return a second hyperrect with its minima at coord dim set to the split, and no other coords altered" do
      rect = KDTree::HyperRect.new(3)
      second = rect.cut(1,2)[1]
      second.minima[0].should == -Float::INFINITY
      second.minima[1].should == 2
      second.minima[2].should == -Float::INFINITY
      second.maxima[0].should == Float::INFINITY
      second.maxima[1].should == Float::INFINITY
      second.maxima[2].should == Float::INFINITY
    end
  end

  describe "instersects?" do
    it "should exist" do
      rect = KDTree::HyperRect.new(3)
      rect.should respond_to :intersects?
    end
  end
end
