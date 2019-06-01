class Movie < ActiveRecord::Base
  def self.all_ratings
    %w(G PG PG-13 NC-17 R)
  end

  def self.similar_to(id)
    movie = find(id)
    if movie.director.blank?
      []
    else
      where(director: movie.director)
    end
  end
end
