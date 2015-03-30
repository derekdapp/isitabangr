module PagesHelper
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
