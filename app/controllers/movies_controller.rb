class MoviesController < ApplicationController


  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    @all_ratings = Movie.all_ratings

    redirect = false

    if params[:ratings]
      session[:ratings] = params[:ratings]
    else
      redirect = true
    end
    session[:ratings] = session[:ratings] || Hash[ @all_ratings.map {|ratings| [ratings, 1]} ]
    @ratings = session[:ratings]

    if params[:category]
      session[:category] = params[:category]
    else
      redirect = true
    end
    session[:category] = session[:category] || ""
    @category = session[:category]

    if redirect
      flash.keep
      redirect_to movies_path({:category => @category, :ratings => @ratings})
    end

    @movies = Movie.where("rating in (?)", @ratings.keys).find(:all, :order => @category)
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
 
  def same_director
    movie = Movie.find(params[:id])
    redirect_to movies_path if movie.director.empty?

    flash[:notice] = "'#{movie.title}' has no director info"
    @movies = movie.same_director
    redirect_to movies_path if @movies.empty?
  end
end