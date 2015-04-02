class SongsController < ApplicationController
  def index
    @songs = Song.all
  end

  def show
    @song = Song.find(params[:id])
  end

  def new
  end

  def create
    echonest = params[:song][:echonest]
    bangr = params[:song][:bangr]
    if bangr == "true"
      bangr = true
    else
      bangr = false
    end

    @song  = Song.find_by echonest: echonest
    @bot = User.find_by email: 'bot@isitabangr.com'
    if @song != nil
      puts "SONG ALREADY EXISTS!!!!!"
      redirect_to @song
    else
      puts "SONG NEEDS TO BE CREATED!!!!!"
      @song = Song.new(song_params)
      if @song.save
        if bangr
          @song.liked_by @bot
        else
          @song.downvote_from @bot
        end
        redirect_to @song
      else
        render:new
      end
    end
  end

  def update
  end

  def edit
  end

  def destroy
  end

  private
  def song_params
      params.require(:song).permit(:echonest, :title, :artist, :image)
    end
end
