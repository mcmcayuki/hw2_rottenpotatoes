class MoviesController < ApplicationController

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    old_session_sort    = session[:sort]
    old_session_ratings = session[:ratings]

    session[:sort]    = (params[:sort] == "title" || params[:sort] == "release_date") ? params[:sort] : session[:sort]
    session[:ratings] = params[:ratings] ? params[:ratings] : session[:ratings]

    if session[:sort] != old_session_sort or session[:ratings] != old_session_ratings
      redirect_to :sort => session[:sort], :ratings => session[:ratings] and return
    end

    # Get the sorting information
    sort_by = session[:sort]
    ordering = {}
    case sort_by
    when 'title'
      ordering = {:order => :title}
      @title_hilite = 'hilite'
    when "release_date"
      ordering = {:order => :release_date}
      @release_date_hilite = 'hilite'
    end

    # Get the desired ratings
    # You will also need code that figures out (i) how to figure out which boxes the user checked and (ii) how to restrict the database query based on that result.
    @desired_ratings = session[:ratings] || {}

    # Get the desired movies and sort them accordingly
    @movies = Movie.find_all_by_rating @desired_ratings.keys, ordering

    # Pass the possible ratings to the view
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
