require 'rails_helper'

RSpec.describe GramsController, type: :controller do
  describe 'grams#index action' do
    it 'responds successfully to an index page request' do
      get :index
      expect(response).to have_http_status(:success)
    end
  end

  describe 'grams#new action' do
    it "should require users to be logged in" do
      get :new
      expect(response).to redirect_to new_user_session_path
    end

    it "should successfully show the new form" do
      user = FactoryGirl.create(:user)
      sign_in user
      get :new
      expect(response).to have_http_status(:success)
    end
  end

  describe 'grams#create action' do

    it 'should require signed in user on form submission' do
      post :create, params: { gram: { caption: 'Hello!' } }
      expect(response).to redirect_to new_user_session_path
    end

    it 'should successfully create a gram in the d.b.' do
      user = FactoryGirl.create(:user)
      sign_in user

      post :create, params: { gram: { caption: 'Hello!' } }
      expect(response).to redirect_to root_path

      gram = Gram.last
      expect(gram.caption).to eq('Hello!')
      expect(gram.user).to eq(user)
    end

    it 'should properly deal with validation errors' do
      user = FactoryGirl.create(:user)
      sign_in user

      post :create, params: { gram: { caption: '' } }
      expect(response).to have_http_status(:unprocessable_entity)
      expect(Gram.count).to eq 0
    end

    # it 'should accept a caption for 6 characters' do
    #   post :create, params: { gram: { caption: 'abcdef' } }
    #   expect(response).to redirect_to root_path
    #   expect(Gram.count).to eq(1)
    # end
    #
    # it 'should deny a caption of less than 6 characters' do
    #   post :create, params: { gram: { caption: '12345' } }
    #   expect(response).to have_http_status(:unprocessable_entity)
    #   expect(Gram.count).to eq(0)
    # end
  end

  describe 'grams#show action' do
    it 'should successfully show page if a gram is found' do
      gram = FactoryGirl.create(:gram)
      get :show, params: { id: gram.id }
      expect(response).to have_http_status(:success)
    end

    it 'should return a 404 error if the gram is not found' do
      get :show, params: { id: 'TACOCAT' }
      expect(response).to have_http_status(:not_found)
    end
  end

  describe 'grams#edit action' do
    it 'should show the edit form if the gram is found' do
      gram = FactoryGirl.create(:gram)
      get :edit, params: { id: gram.id }
      expect(response).to have_http_status(:success)
    end

    it 'should return 404 if there is no gram to edit' do
      get :edit, params: { id: 'NOGRAM' }
      expect(response).to have_http_status(:not_found)
    end
  end

  describe 'grams#update action' do
    it 'should allows users to update grams' do
      gram = FactoryGirl.create(:gram, caption: 'initial')
      patch :update, params: { id: gram.id, gram: { caption: 'changed' } }
      expect(response).to redirect_to root_path
      gram.reload
      expect(gram.caption).to eq 'changed'
    end

    it 'should return 404 if there is no gram to update' do
      patch :update, params: { id: 'GTFO', gram: { caption: 'changed' } }
      expect(response).to have_http_status(:not_found)
    end

    it 'should render the edit form with HTTP status unprocessable_entity' do
      gram = FactoryGirl.create(:gram, caption: 'initial')
      patch :update, params: { id: gram.id, gram: { caption: '' } }
      expect(response).to have_http_status(:unprocessable_entity)
      gram.reload
      expect(gram.caption).to eq 'initial'
    end
  end

  describe 'grams#destroy action' do
    it 'removes the gram from the database' do
      gram = FactoryGirl.create(:gram)
      delete :destroy, gram: { id: gram.id }
      expect(response).to redirect_to root_path
      gram = Gram.find(gram.id)
      expect(response).to have_http_status(:not_found)
    end
    it 'responds with not_found if the gram does not exist' do
      delete :destroy, gram: { id: 'NOID' }
      expect(response).to have_http_status(:not_found)
    end
  end
end
