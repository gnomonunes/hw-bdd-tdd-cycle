require 'spec_helper'
require 'rails_helper'

RSpec.describe MoviesController, type: :controller do
  describe 'listing movies' do
    context 'sort param value is "title"' do
      it 'should set instance variable title_header to "hilite"' do
        get :index, { sort: 'title' }
        expect(assigns(:title_header)).to eq('hilite')
      end
    end
    context 'sort param value is "release_date"' do
      it 'should set instance variable date_header to "hilite"' do
        get :index, { sort: 'release_date' }
        expect(assigns(:date_header)).to eq('hilite')
      end
    end
  end
  describe 'create new movie' do
    it 'should call the create controller method' do
      controller.should_receive(:create)
      post :create, { :movie => {
          title: 'New movie', 
          director: 'Fernando Nunes', 
          rating: 'R', 
          description: 'Funny movie', 
          release_date: '2015-10-23'
        }
      }
    end
    subject { post :create, :movie => {
        title: 'New movie', 
        director: 'Fernando Nunes', 
        rating: 'R', 
        description: 'Funny movie', 
        release_date: '2015-10-23'
      } 
    }
    it 'should redirect to movies_path' do
      expect(subject).to redirect_to movies_path
    end
  end
  describe 'delete a movies' do 
    it 'should call the destroy controller method' do
      controller.should_receive(:destroy)
      post :destroy, { id: 1 }
    end
    subject { post :destroy, id: 1 }
    it 'should redirect to movies_path' do
      expect(subject).to redirect_to movies_path
    end
  end
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
        expect(response).to redirect_to movies_path
      end
    end
  end
end
