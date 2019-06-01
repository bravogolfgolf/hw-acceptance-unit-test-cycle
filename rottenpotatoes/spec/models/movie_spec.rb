require 'rails_helper'

RSpec.describe Movie, type: :model do
  describe 'Given a movie with a director' do
    before :each do
      @movie1 = Movie.create!( director: 'Director Name')
      @movie2 = Movie.create!( director: 'Director Name')
      @movie3 = Movie.create!( director: 'Different Director Name')
      @movies = Movie.similar_to(@movie1.id)
    end
    it 'should find movies by the same director' do
      expect(@movies).to include(@movie2)
    end
    it 'should NOT find movies by different directors' do
      expect(@movies).to_not include(@movie3)
    end
  end
end
