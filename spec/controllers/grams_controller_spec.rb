require 'rails_helper'

RSpec.describe GramsController, type: :controller do
  describe 'grams#index action' do
    it 'responds successfully to an index page request' do
      get :index
      expect(response).to have_http_status(:success)
    end
  end

  describe 'grams#new action' do
    it 'succeeds in loading a /grams/new form' do
      get :new
      expect(response).to have_http_status(:success)
    end
  end

  describe 'grams#create action' do
    it 'should successfully create a gram in the d.b.' do
      post :create, params: { gram: { caption: 'Hello!' } }
      expect(response).to redirect_to root_path

      gram = Gram.last
      expect(gram.caption).to eq('Hello!')
    end

    it 'should properly deal with validation errors' do
      post :create, params: { gram: { caption: '' } }
      expect(response).to have_http_status(:unprocessable_entity)
      expect(Gram.count).to eq 0
    end
  end
end
