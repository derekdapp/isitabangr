class PagesController < ApplicationController
  def home 
  end

  def search_echonest
    @results = RSpotify::Track.search(params[:query], limit: 10)
  end

end
