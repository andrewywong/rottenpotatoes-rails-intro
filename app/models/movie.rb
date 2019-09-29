class Movie < ActiveRecord::Base
    def self.all_ratings
        return Movie.distinct.order(:rating).pluck(:rating)
    end
    
    def self.with_ratings(ratings)
        return Movie.where(rating: ratings)
    end
end
