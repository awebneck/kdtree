class KDTree
  class HyperRect
    attr_accessor :minima, :maxima

    def initialize(k)
      @minima = Array.new k, -Float::INFINITY
      @maxima = Array.new k, Float::INFINITY
    end

    def clone
      cl = super
      cl.minima = @minima.clone
      cl.maxima = @maxima.clone
      cl
    end

    def cut(dim, pivot)
      left_hr = self.clone
      left_hr.maxima[dim] = pivot
      right_hr = self.clone
      right_hr.minima[dim] = pivot
      [left_hr, right_hr]
    end

    def intersects?(target, radius, metric = :euclidean)
      near_point = KDTree::Point.new
      target.length.times do |i|
        if target[i] <= @minima[i]
          coord = @minima[i]
        elsif @minima[i] < target[i] && target[i] < @maxima[i]
          coord = target[i]
        else
          coord = @maxima[i]
        end
        near_point[i] = coord
      end
      near_point.distance_from(target, metric) <= radius
    end
  end
end
