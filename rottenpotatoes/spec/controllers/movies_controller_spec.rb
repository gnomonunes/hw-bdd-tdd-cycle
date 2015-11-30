require 'rails_helper'

RSpec.describe MoviesController, type: :controller do
  describe 'find movies with same director' do
    it 'should call the search_director controller method that receive the movie id' do
      controller.should_receive(:search_director)
      get :search_director
    end
    describe 'when the specified movie has a director' do
      before(:each) do
        @fake_movie = double('Movie', director: 'Wes Anderson')
        Movie.stub(:find).and_return(@fake_movie)
      end
      it 'should call the model method that search for movies of the same director' do
        Movie.should_receive(:search_director).with('1')
        get :search_director, {id: '1'}
      end
      it 'should select the Search Results template for rendering' do
        Movie.stub(:search_director)
        get :search_director, {id: '1'}
        response.should render_template('search_director')
      end
      it 'should make the results available to the template' do
        fake_results = [double('Movie'), double('Movie')]
        Movie.stub(:search_director).and_return(fake_results)
        get :search_director, {id: '1'}
        assigns(:movies).should == fake_results
      end
    end
    describe 'when the specified movie has no director' do
      before(:each) do
        @fake_movie = double('Movie', {title: 'Fake movie', director: nil})
        Movie.stub(:find).and_return(@fake_movie)
      end
      it 'should not call the model method that search for movies of the same director' do
        Movie.should_not_receive(:search_director)
        get :search_director, {id: '1'}
      end
      it 'should redirect to the home page' do
        get :search_director, {id: '1'}
        expect(response).to redirect_to root_path
      end
    end
  end
end
