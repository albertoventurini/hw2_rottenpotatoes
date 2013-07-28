class MoviesController < ApplicationController

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    @all_ratings = Movie.all_ratings
    
    redirect = false
    
    
    if params.has_key?(:sort_by)
      session[:sort_by] = sort_by = params[:sort_by]
    else
      redirect = true
      if session.has_key?(:sort_by)
        params[:sort_by] = session[:sort_by]
      else
        params[:sort_by] = "title"
      end
    end
    
    
    if params.has_key?(:ratings)
      session[:ratings] = params[:ratings]
    else
      redirect = true
      if session.has_key?(:ratings)
        params[:ratings] = session[:ratings]
      else
        ratings_array = @all_ratings.product(["1"]).flatten
        params[:ratings] = Hash[*ratings_array]
      end      
    end
    
    


    flash.keep
    if redirect
      redirect_to movies_path(params)
    end
 
 
    @checked_ratings = params[:ratings].keys

    
    
    
    @movies = Movie.find_all_by_rating(@checked_ratings, :order => sort_by)
    
    @table_class = {'title' => 'not_hilite', 'rating' => 'not_hilite', 'release_date' => 'not_hilite'}
    if @table_class.has_key?(sort_by)
      @table_class[sort_by] = 'hilite'
    end
    
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
