require 'spec_helper'
require 'rails_helper'

RSpec.describe Movie, type: :model do
  describe 'find movies with same director' do
    before(:each) do
      Movie.delete_all
      @movies = [
        {title: 'Star Wars', rating: 'PG', director: 'George Lucas', release_date: '1977-05-25'},
        {title: 'Blade Runner', rating: 'PG', director: 'Ridley Scott', release_date: '1982-06-25'},
        {title: 'Alien', rating: 'R', release_date: '1979-05-25'},
        {title: 'THX-1138', rating: 'R', director: 'George Lucas',   release_date: '1971-03-11'}
      ]
      @movies.each do |movie|
        Movie.create(movie)
      end
    end
    it 'should find movies by the same director' do
      fake_movie = double('Movie', {id: 99, director: 'George Lucas'})
      Movie.stub(:find).with(fake_movie.id).and_return(fake_movie)
      movies = Movie.search_director(fake_movie.id)
      movies.each do |movie|
        expect(movie.director).to eq(fake_movie.director)
      end
    end
    it 'should not find movies by different directors' do
      fake_movie = double('Movie', {id: 100, director: 'Wes Anderson'})
      Movie.stub(:find).with(fake_movie.id).and_return(fake_movie)
      movies = Movie.search_director(fake_movie.id)
      expect(movies.size).to eq(0)
    end
  end
end
