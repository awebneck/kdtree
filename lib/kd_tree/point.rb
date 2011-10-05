class KDTree
  class Point
    include Enumerable

    attr_accessor :range

    def initialize(*args)
      raise ArgumentError, "Only numeric values are allowed as point coordinates" if args.any? { |el| !el.is_a?(Numeric) }
      @domain = args
    end

    def [](index)
      @domain[index]
    end

    def []=(index, value)
      raise ArgumentError, "Only numeric values are allowed as point coordinates" unless value.is_a?(Numeric)
      @domain[index] = value
    end

    def length
      @domain.length
    end

    def each(&block)
      @domain.each(&block)
    end

    def distance_from(target, metric = :euclidean)
      raise ArgumentError, "Distance can only be computed on other enumerables" unless target.is_a?(Enumerable)
      raise ArgumentError, "Distance can only be computed on points of same dimension" unless target.length == @domain.length
      i = 0
      case metric
        when :manhattan
          self.inject(0) do |acc, el|
            dist = acc + (el-target[i]).abs
            i += 1
            dist
          end
        when :chebyshev
          self.inject(0) do |acc, el|
            delt = (el-target[i]).abs
            dist = delt > acc ? delt : acc
            i += 1
            dist
          end
        else
          self.inject(0) do |acc, el|
            dist = acc + ((el-target[i])**2.0)
            i += 1
            dist
          end
      end
    end
  end
end
