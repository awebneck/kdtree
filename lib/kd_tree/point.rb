class KDTree
  class Point < Array
    attr_accessor :data

    def distance_from(target, metric)
      i = 0
      case metric
        when :euclidean
          self.inject(0) do |acc, el|
            dist = acc + ((el-target[i])**2.0)
            i += 1
            dist
          end
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
      end
    end
  end
end
