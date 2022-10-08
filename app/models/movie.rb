class Movie < ActiveRecord::Base
  def self.all_ratings
    %w(G PG PG-13 R)
  end

  def self.with_ratings(ratings_list, sort)
    Movie.where(rating: ratings_list.keys).order(sort)
  end
end