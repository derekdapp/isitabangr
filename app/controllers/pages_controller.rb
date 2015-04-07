class PagesController < ApplicationController
  def home
  	
  end

  def search_echonest
  	song = Echonest::Song.new('***REMOVED***')
  	s_params = { results: 5, bucket: ['audio_summary','id:7digital-US','tracks'],  artist: params[:artist], title: params[:song], sort: 'song_hotttnesss-desc'}
    @results = song.search(s_params)

  end

  private
  protected

  def is_bangr?(song)
  	score = 0
  	if song[:audio_summary][:energy] > 0.7
  		score += 1
  	end
  	if song[:audio_summary][:tempo] > 130
  		score += 1
  	end
  	if song[:audio_summary][:acousticness] < 0.083
  		score += 1
  	end
  	if song[:audio_summary][:danceability] < 0.72
  		score += 1
  	end
  	if score >= 3
  		return true
  	else
  		return false
  	end
  end

end
