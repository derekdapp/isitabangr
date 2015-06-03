class SongsController < ApplicationController
  def index
    redirect_to root_path
  end

  def show
    @song = Song.find(params[:id])
    @upvotes = @song.get_upvotes.size
    @downvotes = @song.get_downvotes.size
    @total = @upvotes + @downvotes
    @spotify_play_url = "https://open.spotify.com/track/" + @song.spotify
  end

  def new
    redirect_to root_path
  end

  def create
    spotify = params[:song][:spotify]
    @song = Song.find_by spotify: spotify
    if @song != nil
      puts "SONG ALREADY EXISTS!!!!!"
      redirect_to @song
    else
      puts "SONG NEEDS TO BE CREATED!!!!!"
      echonest = HTTParty.get("http://developer.echonest.com/api/v4/song/profile?api_key="+ENV['ECHONEST_KEY']+"&bucket=audio_summary&bucket=song_type&track_id=" + params[:song][:spotify_uri])
      bangr = is_bangr?(echonest['response']['songs'][0]['audio_summary'],echonest['response']['songs'][0]['song_type'])
      @bot = User.find_by email: 'bot@isitabangr.com'
      @song = Song.new(song_params)
      if @song.save
        if bangr
          @song.liked_by @bot
        else
          @song.downvote_from @bot
        end
        redirect_to @song
      else
        redirect_to root
      end
    end
  end

  def update
    redirect_to root_path
  end

  def edit
    redirect_to root_path
  end

  def destroy
    redirect_to root_path
  end

  def upvote
    @song = Song.find(params[:id])
    @song.upvote_by current_user
    redirect_to @song
  end

  def downvote
    @song = Song.find(params[:id])
    @song.downvote_by current_user
    redirect_to @song
  end
  private
  def song_params
      params.require(:song).permit(:spotify, :title, :artist, :image, :preview)
  end

  def is_bangr?(song,song_type)
    score = 0
    if song['energy'] > 0.68
      score += 1
    end
    if song['tempo'] > 130
      score += 1
    end
    if song['acousticness'] < 0.1
      score += 1
    end
    # if song['danceability'] < 0.72
    #   score += 1
    #   puts 'has good danceability'
    # end
    if song_type.to_a.include? 'electric'
      score += 1 
    end
    return score >= 3
  end
end
