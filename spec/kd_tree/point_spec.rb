require 'spec_helper'

describe KDTree::Point do
  it "should exist" do
    KDTree.constants.should include :Point
    KDTree::Point.should be_a Class
  end

  it "should be enumerble" do
    point = KDTree::Point.new
    point.should be_a Enumerable
  end

  describe "constructor" do
    it "should be valid with 0 args" do
      lambda { KDTree::Point.new }.should_not raise_error
    end

    it "should be valid with multiple numeric args" do
      lambda { KDTree::Point.new(1,2,3,4,5) }.should_not raise_error
    end

    it "should be invalid with multiple args if any are not numeric" do
      lambda { KDTree::Point.new(1,"stuff",3,:happy,5) }.should raise_error
    end

    it "should set the array-type values to the values of the arguments" do
      point = KDTree::Point.new(1,2,3,4,5)
      point[0].should == 1
      point[1].should == 2
      point[2].should == 3
      point[3].should == 4
      point[4].should == 5
    end
  end

  describe "[]" do
    it "should exist" do
      point = KDTree::Point.new
      point.should respond_to(:[])
    end

    it "should access the nth value as set or constructed" do
      point = KDTree::Point.new(1,2,3)
      point[2].should == 3
      point[2] = 5
      point[2].should == 5
    end
  end

  describe "[]=" do
    it "should exist" do
      point = KDTree::Point.new
      point.should respond_to(:[]=)
    end

    it "should raise an error if the value is not numeric" do
      point = KDTree::Point.new(1,2,3)
      lambda { point[2] = "test" }.should raise_error
    end
  end

  describe "distance_from" do
    it "should exist" do
      point = KDTree::Point.new
      point.should respond_to :distance_from
    end

    it "should accept one or two arguments, no more, no less" do
      point = KDTree::Point.new(5,6,7)
      lambda { point.distance_from KDTree::Point.new(1,2,3), :euclidean }.should_not raise_error
      lambda { point.distance_from KDTree::Point.new(1,2,3) }.should_not raise_error
      lambda { point.distance_from }.should raise_error
      lambda { point.distance_from KDTree::Point.new(1,2,3), :euclidean, :toast }.should raise_error
    end

    it "should raise an error if the first argument is not enumerable" do
      lambda { point.distance_from "corndog" }.should raise_error
    end

    it "should raise an error if the first argument is of a different dimension" do
      lambda { point.distance_from "corndog" }.should raise_error
    end

    it "should default to using a squared Euclidean measurement when the second argument is omitted" do
      point = KDTree::Point.new(1, 2)
      point.distance_from([1, 2]).should == 0
      point.distance_from([2, 4]).should == 5
    end

    it "should default to using a squared Euclidean measurement when the second argument is invalid" do
      point = KDTree::Point.new(1, 2)
      point.distance_from([1, 2], :toast).should == 0
      point.distance_from([2, 4], :corn).should == 5
    end

    it "should use a squared Euclidean measurement when the second argument is :euclidean" do
      point = KDTree::Point.new(1, 2)
      point.distance_from([1, 2], :euclidean).should == 0
      point.distance_from([2, 4], :euclidean).should == 5
    end

    it "should use a Manhattan measurement when the second argument is :manhattan" do
      point = KDTree::Point.new(1, 2)
      point.distance_from([1, 2], :manhattan).should == 0
      point.distance_from([2, 4], :manhattan).should == 3
    end

    it "should use a Chebyshev measurement when the second argument is :chebyshev" do
      point = KDTree::Point.new(1, 2)
      point.distance_from([1, 2], :chebyshev).should == 0
      point.distance_from([2, 4], :chebyshev).should == 2
    end
  end

  describe "attributes" do
    describe "range" do
      it "should exist" do
        point = KDTree::Point.new
        point.should respond_to :range
        point.should respond_to :range=
      end

      it "should be nil when initialized" do
        point = KDTree::Point.new
        point.range.should be_nil
      end

      it "should be equal to the set value when set" do
        point = KDTree::Point.new
        point.range = 123
        point.range.should == 123
      end
    end

    describe "length" do
      it "should exist" do
        point = KDTree::Point.new
        point.should respond_to(:length)
      end

      it "should be equal to the number of initial arguments passed" do
        point = KDTree::Point.new(1,2,3)
        point.length.should == 3
      end
    end
  end
end
