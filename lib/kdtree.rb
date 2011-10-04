require File.dirname(__FILE__)+'/kdtree/point'
require File.dirname(__FILE__)+'/kdtree/hyper_rect'

class KDTree
  attr_accessor :exemplar, :split, :kd_left, :kd_right

  def initialize(exemplar_set)
    return if exemplar_set.empty?
    exemplar_set = extract_pivot exemplar_set
    split! exemplar_set
  end

  def extract_pivot(exemplar_set)
    k = exemplar_set[0].length - 1
    max_spread = -Float::INFINITY
    max_spread_o = 0
    max_spread_d = 0
    k.times do |i|
      min = Float::INFINITY
      max = -Float::INFINITY
      exemplar_set.each do |ex|
        min = ex[k] if ex[k] < min
        max = ex[k] if ex[k] > max
      end
      if max - min > max_spread
        max_spread = max - min
        max_spread_o = min
        max_spread_d = i
      end
    end
    @split = max_spread_d
    mid_coord = max_spread_o + (max_spread/2.0)
    split_d_coords = exemplar_set.map do |ex|
      ex[split]
    end
    mid_closest_coord = Float::INFINITY
    mid_closest_index = 0
    split_d_coords.each_with_index do |coord, i|
      if (coord - mid_coord).abs < mid_closest_coord
        mid_closest_coord = coord
        mid_closest_index = i
      end
    end
    @exemplar = exemplar_set.delete_at mid_closest_index
    exemplar_set
  end

  def split!(exemplar_set)
    left_set = []
    right_set = []
    exemplar_set.each do |ex|
      if ex[@split] <= @exemplar[@split]
        left_set << ex
      else
        right_set << ex
      end
    end
    @kd_left = self.class.new left_set
    @kd_right = self.class.new right_set
  end

  def nearest_neighbor(target, metric=:euclidean)
    nearest_neighbors(target, 1, metric)[0]
  end

  def cut_kspace_by(target, hr)
    hrl, hrr = hr.cut @split, @exemplar[@split]
    if target[@split] <= @exemplar[@split]
      [@kd_left, hrl, @kd_right, hrr]
    else
      [@kd_right, hrr, @kd_left, hrl]
    end
  end

  def nearest_neighbors(target, n, metric=:euclidean, acc=[], hr=HyperRect.new(target.length), max_dist=Float::INFINITY)
    return acc if @exemplar.nil?
    nearer_kd, nearer_hr, further_kd, further_hr = self.cut_kspace_by target, hr
    acc = nearer_kd.nearest_neighbors target, n, metric, acc, nearer_hr, max_dist
    max_dist = acc.last[:dist] if acc.length == n && acc.last[:dist] < max_dist
    acc = backtrack_check target, n, metric, acc, further_hr, max_dist, further_kd
    acc.sort_by { |node| node[:dist] }
  end

  def backtrack_check(target, n, metric, acc, hr, max_dist, kd)
    if hr.intersects? target, max_dist, metric
      dist = @exemplar.distance_from(target, metric)
      if acc.length < n || dist < acc.last[:dist]
        acc = acc.clone
        max_dist = dist if acc.length == n
        acc << {:node => @exemplar, :dist => dist}
        acc = acc.sort_by { |node| node[:dist] }
        acc.delete_at n if acc.length > n
      end
      temp_acc = kd.nearest_neighbors target, n, metric, acc, hr, max_dist
      if ((temp_acc.length > 0) && (acc.length < n || temp_acc.last[:dist] < acc.last[:dist]))
        acc = temp_acc
      end
    end
    acc
  end
end

