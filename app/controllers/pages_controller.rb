class PagesController < ApplicationController
  def home 
  end

  def search_spotify
    @results = RSpotify::Track.search(params[:query], limit: 10)
    respond_to do |format|
	  format.js
	end
  end

  def random
  	@song = Song.offset(rand(Song.count)).first
  	redirect_to song_path(@song)
  end

end
