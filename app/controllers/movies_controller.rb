class MoviesController < ApplicationController

  def movie_params
    params.require(:movie).permit(:title, :rating, :description, :release_date)
  end

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    # reset_session
    
    # @all_ratings = Movie.all_ratings
    # @rating_filters = {}
    # if (params.key?(:ratings))
    #   # new filtering settings
    #   @rating_filters = params[:ratings]
    #   session[:ratings] = params[:ratings]
    # else
    #   if (session.key?(:ratings))
    #     # remember filtering settings
    #     @rating_filters = session[:ratings]
    #     # redirect_to movies_path(:ratings => session[:ratings])
    #   else
    #     # new session
    #     @all_ratings.each do |filter|
    #       @rating_filters[filter] = 1
    #     end
    #   end
    # end
    
    # @movies = Movie.with_ratings(@rating_filters.keys)
    
    # @highlight = nil
    # if (params.key?(:t))
    #   # new sorting settings
    #   @movies = @movies.order(params[:t])
    #   @highlight = params[:t]
    #   session[:t] = params[:t]
    # else
    #   if (session.key?(:t))
    #     # remember sorting settings
    #     @movies = @movies.order(session[:t])
    #     @highlight = session[:t]
    #     # redirect_to movies_path(:t => session[:t])
    #   end
    # end
    
    # # above code section can work without URI redirect code
    # # JANK
    # if (!params.key?(:ratings) && !params.key?(:t))
    #   if (session.key?(:ratings) && session.key?(:t))
    #     flash.keep
    #     # remember filtering and sorting settings
    #     redirect_to movies_path(:ratings => session[:ratings], :t => session[:t])
    #   elsif (session.key?(:ratings))
    #     redirect_to movies_path(:ratings => session[:ratings], :t => nil)
    #   elsif (session.key?(:t))
    #     redirect_to movies_path(:ratings => nil, :t => session[:t])
    #   end
    # elsif(!params.key?(:ratings))
    #   if (session.key?(:ratings))
    #     flash.keep
    #     # remember filtering settings
    #     redirect_to movies_path(:ratings => session[:ratings], :t => params[:t])
    #   end
    # elsif (!params.key?(:t))
    #   if (session.key?(:t))
    #     flash.keep
    #     # remember sorting settings
    #     redirect_to movies_path(:ratings => params[:ratings], :t => session[:t])
    #   end
    # end
    
    
    @all_ratings = Movie.all_ratings
    @rating_filters = {}
    if (params.key?(:ratings))
      # new filtering settings
      @rating_filters = params[:ratings]
      session[:ratings] = params[:ratings]
    else
      # new session
      @all_ratings.each do |filter|
        @rating_filters[filter] = 1
      end
    end
    
    @movies = Movie.with_ratings(@rating_filters.keys)
    
    @highlight = nil
    if (params.key?(:t))
      # new sorting settings
      @movies = @movies.order(params[:t])
      @highlight = params[:t]
      session[:t] = params[:t]
    end
    
    # JANK
    if (!params.key?(:ratings) && !params.key?(:t))
      if (session.key?(:ratings) && session.key?(:t))
        flash.keep
        # remember filtering and sorting settings
        redirect_to movies_path(:ratings => session[:ratings], :t => session[:t])
      elsif (session.key?(:ratings))
        redirect_to movies_path(:ratings => session[:ratings], :t => nil)
      elsif (session.key?(:t))
        redirect_to movies_path(:ratings => nil, :t => session[:t])
      end
    elsif(!params.key?(:ratings))
      if (session.key?(:ratings))
        flash.keep
        # remember filtering settings
        redirect_to movies_path(:ratings => session[:ratings], :t => params[:t])
      end
    elsif (!params.key?(:t))
      if (session.key?(:t))
        flash.keep
        # remember sorting settings
        redirect_to movies_path(:ratings => params[:ratings], :t => session[:t])
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

end
