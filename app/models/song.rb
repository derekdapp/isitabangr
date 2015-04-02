class Song < ActiveRecord::Base
	acts_as_votable

	def score
	  self.get_upvotes.size - self.get_downvotes.size
	end
end
