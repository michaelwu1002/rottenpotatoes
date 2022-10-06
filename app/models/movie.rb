class Movie < ActiveRecord::Base
  def self.all_ratings
    %w(G PG PG-13 R)
  end

  def self.with_ratings(ratings_list)
    self.find(:all, :select => "rating", :group => "rating").map(&:rating)
  end
end