class MoviesController < ApplicationController
  def movie_params
    params.require(:movie).permit(:title, :rating, :description, :release_date, :director)
  end

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    sort = params[:sort] || session[:sort]
    case sort
    when 'title'
      ordering = { title: :asc }
      @title_header = 'hilite'
    when 'release_date'
      ordering = { release_date: :asc }
      @date_header = 'hilite'
    end
    @all_ratings = Movie.all_ratings
    @selected_ratings = params[:ratings] || session[:ratings] || {}

    @selected_ratings = Hash[@all_ratings.map { |rating| [rating, rating] }] if @selected_ratings == {}

    if (params[:sort] != session[:sort]) || (params[:ratings] != session[:ratings])
      session[:sort] = sort
      session[:ratings] = @selected_ratings
      redirect_to(sort: sort, ratings: @selected_ratings) && return
    end
    @movies = Movie.where(rating: @selected_ratings.keys).order(ordering)
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

  def similar
    movie = Movie.find(params[:id])
    @movies = Movie.similar_to movie.id
    if @movies.empty?
      flash[:notice] = "'#{movie.title}' has no director info"
      redirect_to movies_path
    end
  end
end
