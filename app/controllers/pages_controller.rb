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

  def last
    @song = Song.last
    redirect_to song_path(@song)
  end
  def banger
    @spotify_play_url = "https://open.spotify.com/track/" + params['spotify']
    @title = params['title']
    @artist = params['artist']
    @preview = params['preview']
    @image = params['image']
    @is_bangr = params['is_bangr']
  end
end
