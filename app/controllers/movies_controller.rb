class MoviesController < ApplicationController

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
  
    session[:sort_by] = params[:sort_by] if params.has_key?(:sort_by)
    sort_by = session[:sort_by]
    
    if params.has_key?(:ratings)
      @checked_ratings = params[:ratings].keys
      session[:ratings] = @checked_ratings
    elsif session.has_key?(:ratings)
      @checked_ratings = session[:ratings]
    else
      @checked_ratings = []
    end
    
    @movies = Movie.find_all_by_rating(@checked_ratings, :order => sort_by)
    
    @table_class = {'title' => 'not_hilite', 'rating' => 'not_hilite', 'release_date' => 'not_hilite'}
    if @table_class.has_key?(sort_by)
      @table_class[sort_by] = 'hilite'
    end
    
    
    @all_ratings = Movie.all_ratings
    
  end

  def new
    # default: render 'new' template
  end

  def create
    @movie = Movie.create!(params[:movie])
    flash[:notice] = "#{@movie.title} was successfully created."
    redirect_to movies_path
  end

  def edit
    @movie = Movie.find params[:id]
  end

  def update
    @movie = Movie.find params[:id]
    @movie.update_attributes!(params[:movie])
    flash[:notice] = "#{@movie.title} was successfully updated."
    redirect_to movie_path(@movie)
  end

  def destroy
    @movie = Movie.find(params[:id])
    @movie.destroy
    flash[:notice] = "Movie '#{@movie.title}' deleted."
    redirect_to movies_path
  end

end
