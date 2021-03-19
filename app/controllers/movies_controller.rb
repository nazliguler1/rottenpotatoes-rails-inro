class MoviesController < ApplicationController

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    #@movies = Movie.all
    #Examine params and session hash
    update_session_hash
    render_or_redirect
    #determine_highlight
    @all_ratings = Movie.all_ratings
    @selected_ratings_hash = selected_ratings_hash
    @selected_ratings = selected_ratings
    @sort_field = sort_field
    determine_highlight
    @movies = Movie.filter_and_sort_movies(@selected_ratings, @sort_field)
    p @movies
  end

  def new
    # default: render 'new' template
  end

  def create
    @movie = Movie.create!(movie_params)
    flash[:notice] = "#{@movie.title} was successfully created."
    redirect_to movies_path
  end

  def edit
    @movie = Movie.find params[:id]
  end

  def update
    @movie = Movie.find params[:id]
    @movie.update_attributes!(movie_params)
    flash[:notice] = "#{@movie.title} was successfully updated."
    redirect_to movie_path(@movie)
  end

  def destroy
    @movie = Movie.find(params[:id])
    @movie.destroy
    flash[:notice] = "Movie '#{@movie.title}' deleted."
    redirect_to movies_path
  end

  private
  # Making "internal" methods private is not required, but is a common practice.
  # This helps make clear which methods respond to requests, and which ones do not.
  def movie_params
    params.require(:movie).permit(:title, :rating, :description, :release_date)
  end
  def selected_ratings
    @selected_ratings_hash&.keys
  end
  def ratings_all_hash
    Hash[Movie.all_ratings.map{|rating| [rating, "1"]}]
  end 
  def selected_ratings_hash
    session[:ratings] || ratings_all_hash 
  end
  def sort_field
    session[:order] || :id
  end
  def determine_highlight
    @highlight = {:id => "", :title => "", :release_date => "" }
    @highlight [session[:order]] = "bg-warning hilite"
  end
  def update_session_hash
    session[:ratings] = params[:ratings] || session[:ratings] || ratings_all_hash
    session[:order] = params[:order] || session[:order] || :id
  end
  def render_or_redirect
    return unless (session[:ratings] and params[:ratings].nil?) or 
                  (session[:order] and params[:order].nil?)
    flash.keep
    redirect_to movies_path(:ratings => session[:ratings], :order => session[:order]) and return
    
  end
end