class Movie < ActiveRecord::Base
  def self.all_ratings
    #['G','PG','PG-13','R']
    %w(G PG PG-13 R)
    
   
  end 
  def self.filter_movies(selected_ratings)
    Movie.where(:rating => selected_ratings)
    
  end
end
