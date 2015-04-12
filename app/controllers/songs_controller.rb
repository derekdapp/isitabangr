class SongsController < ApplicationController
  def index
    @songs = Song.all
  end

  def show
    @song = Song.find(params[:id])
    @upvotes = @song.get_upvotes.size
    @downvotes = @song.get_downvotes.size
    @total = @upvotes + @downvotes
  end

  def new
  end

  def create
    spotify = params[:song][:spotify]
    @song = Song.find_by spotify: spotify
    if @song != nil
      puts "SONG ALREADY EXISTS!!!!!"
      redirect_to @song
    else
      puts "SONG NEEDS TO BE CREATED!!!!!"
      echonest = HTTParty.get("http://developer.echonest.com/api/v4/song/profile?api_key="+ENV['ECHONEST_KEY']+"&bucket=audio_summary&track_id=" + params[:song][:spotify_uri])
      bangr = is_bangr?(echonest['response']['songs'][0]['audio_summary'])
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
  end

  def edit
  end

  def destroy
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

  def is_bangr?(song)
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
    if song['danceability'] < 0.72
      score += 1
    end
    if score >= 3
      return true
    else
      return false
    end
  end
end
