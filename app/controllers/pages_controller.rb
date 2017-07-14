class PagesController < ApplicationController
  def home

  end

  def search_spotify
    token = HTTParty.post(
    "https://accounts.spotify.com/api/token",
    :headers => {
      "Authorization" => "Basic #{ENV['SPOTIFY_KEY']}"
    },
    :body => {
      "grant_type" => "client_credentials"
    })
    response = HTTParty.get(
    "https://api.spotify.com/v1/search?q=#{params[:query].tr(" ", "+").tr(".","+")}&type=track&limit=10",
    :headers => {
      "Authorization" => "Bearer #{token['access_token']}",
      "Accept" =>  "application/json"
    })
    @results = []
    response['tracks']['items'].each do |item|
      track_details = HTTParty.get(
      "https://api.spotify.com/v1/tracks/#{item['id']}",
      :headers => {
        "Authorization" => "Bearer #{token['access_token']}",
        "Accept" =>  "application/json"
      })
      name = track_details['name']
      artist_name = track_details['artists'].first['name']
      preview_url = track_details['preview_url']
      spotify_id = track_details['id']
      spotify_uri = track_details['external_urls']['spotify']
      image = track_details['album']['images'].first['url']
      @results.push({
        name: name,
        artist: artist_name,
        preview_url: preview_url,
        spotify_id: spotify_id, spotify_uri: spotify_uri,
        image: image})
    end
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

end
