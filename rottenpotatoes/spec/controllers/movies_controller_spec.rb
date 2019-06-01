require 'rails_helper'

RSpec.describe MoviesController, type: :controller do
  describe 'when the specified movie' do
    before :all do
      @movie = Movie.create!(title: 'Title')
    end
    describe 'has a director' do
      before do
        @fake_results = [double('movie1'), double('movie2')]
      end

      it 'should return collection of movies with that director' do
        expect(Movie).to receive(:similar_to)
          .with(1)
          .and_return(@fake_results)
        get :similar, id: 1
      end

      describe 'and then' do
        before do
          allow(Movie).to receive(:similar_to).and_return(@fake_results)
          get :similar, id: 1
        end

        it 'selects the similar template for rendering' do
          expect(response).to render_template('similar')
        end

        it 'makes the movie results available to that template' do
          expect(assigns(:movies)).to eq(@fake_results)
        end
      end
    end

    describe 'has no director,' do
      before do
        @fake_results = []
      end

      it 'should return empty collection' do
        expect(Movie).to receive(:similar_to)
          .with(1)
          .and_return(@fake_results)
        get :similar, id: 1
      end

      describe 'and then' do
        before :each do
          allow(Movie).to receive(:similar_to).and_return(@fake_results)
          get :similar, id: 1
        end

        it 'redirect to movies home page' do
          expect(response).to redirect_to movies_path
        end
      end
    end
  end
end
