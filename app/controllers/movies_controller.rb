class MoviesController < ApplicationController

    def show
      id = params[:id] # retrieve movie ID from URI route
      @movie = Movie.find(id) # look up movie by unique ID
      # will render app/views/movies/show.<extension> by default
    end

    def index
      sort = params[:sort] || session[:sort]
      params[:home] = 1
      if sort == 'title'
        @hilite_tit = "bg-warning"
      end
      if sort == 'release_date'
        @hilite_rel = "bg-warning"
      end

      if params[:ratings].nil?
        if params[:home].nil?
          @ratings_to_show = session[:ratings]
        else
          @ratings_to_show = {"G" => 1, "PG" => 1, "PG-13" => 1, "R" => 1}
        end
        redirect_to movies_path(:ratings => @ratings_to_show, :sort => params[:sort])
      
      else
        @all_ratings = Movie.all_ratings
        @ratings_to_show = params[:ratings] || session[:ratings] || {}
        if session[:ratings].nil?
          @ratings_to_show = session[:ratings]
        end
        if @ratings_to_show == {}
          @ratings_to_show = {"G" => 1, "PG" => 1, "PG-13" => 1, "R" => 1}
          if params[:sort] != session[:sort] or params[:ratings] != session[:ratings]
            session[:ratings] = @ratings_to_show
            session[:sort] = sort
          end

          @movies = Movie.order(sort)
        else

          if params[:sort] != session[:sort] or params[:ratings] != session[:ratings]
            session[:ratings] = @ratings_to_show
            session[:sort] = sort
            params[:home] = 1
          end

          @movies = Movie.with_ratings(@ratings_to_show, sort)
        end
      end
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
  end