namespace :cleanup do
  desc "TODO"
  task cleanup_db: :environment do
  	songs = Song.all
  	songs_to_be_deleted = []
  	songs.each do |song|
  		songs_to_be_deleted << song if song.get_downvotes.count + song.get_upvotes.count == 1
  	end
  	songs_to_be_deleted.each {|song| song.destroy}
  end

end
