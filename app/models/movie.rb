class Movie < ActiveRecord::Base
  def self.all_ratings
    #['G','PG','PG-13','R']
    %w(G PG PG-13 R)
    
   
  end 
  def self.filter_and_sort_movies(selected_ratings, sort_field)
    Movie.where(:rating => selected_ratings).order(sort_field)
    
  end
end
