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
      post :create, params: { gram: { caption: 'hello!' } }
      expect(response).to redirect_to new_user_session_path
    end

    it 'should successfully create a gram in the d.b.' do
      user = FactoryGirl.create(:user)
      sign_in user

      post :create, params: {
        gram: {
          caption: 'hello!',
          picture: fixture_file_upload('/picture.jpg', 'image/jpg')
        }
      }

      expect(response).to redirect_to root_path

      gram = Gram.last
      expect(gram.caption).to eq('hello!')
      expect(gram.user).to eq(user)
    end

    it 'should properly deal with validation errors' do
      user = FactoryGirl.create(:user)
      sign_in user

      post :create, params: { gram: { caption: '' } }
      expect(response).to have_http_status(:unprocessable_entity)
      expect(Gram.count).to eq 0
    end
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
      sign_in gram.user
      get :edit, params: { id: gram.id }
      expect(response).to have_http_status(:success)
    end

    it 'should return 404 if there is no gram to edit' do
      user = FactoryGirl.create(:user)
      sign_in user
      get :edit, params: { id: 'NOGRAM' }
      expect(response).to have_http_status(:not_found)
    end

    it 'should not let an unregistered user edit a gram' do
      gram = FactoryGirl.create(:gram)
      get :edit, params: { id: gram.id }
      expect(response).to redirect_to new_user_session_path
    end

    it 'should prevent users who did not create the gram from editing the gram' do
      gram = FactoryGirl.create(:gram)
      user = FactoryGirl.create(:user)
      sign_in user
      get :edit, params: { id: gram.id }
      expect(response).to have_http_status(:forbidden)
    end
  end

  describe 'grams#update action' do
    it 'should allows users to update grams' do
      gram = FactoryGirl.create(:gram, caption: 'initial')
      sign_in gram.user
      # PUT - more thorough update
      # PATCH - not updating entire object (newer)
      patch :update, params: { id: gram.id, gram: { caption: 'changed', picture: fixture_file_upload('/picture-copy.jpg', 'image/jpg') } }
      expect(response).to redirect_to root_path
      gram.reload
      expect(gram.caption).to eq 'changed'
      expect(gram.picture.url).to include('picture-copy.jpg')
    end

    it 'should return 404 if there is no gram to update' do
      user = FactoryGirl.create(:user)
      sign_in user
      patch :update, params: { id: 'GTFO', gram: { caption: 'changed' } }
      expect(response).to have_http_status(:not_found)
    end

    it 'should render the edit form with HTTP status unprocessable_entity' do
      gram = FactoryGirl.create(:gram, caption: 'initial')
      sign_in gram.user
      patch :update, params: { id: gram.id, gram: { caption: '' } }
      expect(response).to have_http_status(:unprocessable_entity)
      gram.reload
      expect(gram.caption).to eq 'initial'
    end

    it 'should not let unauthorized users update a gram' do
      gram = FactoryGirl.create(:gram, caption: 'try and update me')
      patch :update, params: { id: gram.id, gram: { caption: 'updated!' } }
      expect(response).to redirect_to new_user_session_path
    end

    it 'should prevent users who did not create the gram from updating the gram' do
      gram = FactoryGirl.create(:gram)
      user = FactoryGirl.create(:user)
      sign_in user
      patch :update, params: { id: gram.id, gram: { caption: 'someone else\'s junk' } }
      expect(response).to have_http_status(:forbidden)
      expect(gram.caption).to eq('hello!')
    end
  end

  describe 'grams#destroy action' do
    it 'should allow a user to destroy a gram' do
      gram = FactoryGirl.create(:gram)
      sign_in gram.user
      delete :destroy, params: { id: gram.id }
      expect(response).to redirect_to root_path
      gram = Gram.find_by_id(gram.id)
      expect(gram).to eq nil
    end

    it 'responds with not_found if the gram does not exist' do
      user = FactoryGirl.create(:user)
      sign_in user
      delete :destroy, params: { id: 'NO_ID' }
      expect(response).to have_http_status(:not_found)
    end

    it 'should not let unauthorized users destroy a gram' do
      gram = FactoryGirl.create(:gram)
      delete :destroy, params: { id: gram.id }
      expect(response).to redirect_to new_user_session_path
    end

    it 'should prevent users who did not create the gram from deleting the gram' do
      gram = FactoryGirl.create(:gram)
      user = FactoryGirl.create(:user)
      sign_in user
      delete :destroy, params: { id: gram.id }
      expect(response).to have_http_status(:forbidden)
    end
  end
end
