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
      token = HTTParty.post(
      "https://accounts.spotify.com/api/token",
      :headers => {
        "Authorization" => "Basic #{ENV['SPOTIFY_KEY']}"
      },
      :body => {
        "grant_type" => "client_credentials"
      })
      response = HTTParty.get(
      "https://api.spotify.com/v1/audio-features/#{params[:song][:spotify]}",
      :headers => {
        "Authorization" => "Bearer #{token['access_token']}",
        "Accept" =>  "application/json"
      })
      bangr = is_bangr?(response)
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
    # TODO make a better algo with the new data from spotify
    # if song['danceability'] < 0.72
    #   score += 1
    #   puts 'has good danceability'
    # end
    # if song_type.to_a.include? 'electric'
    #   score += 1
    # end
    return score >= 3
  end
end
