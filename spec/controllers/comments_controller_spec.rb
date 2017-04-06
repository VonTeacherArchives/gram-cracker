require 'rails_helper'

RSpec.describe CommentsController, type: :controller do
  describe 'comments#create action' do
    it 'should allow users to create comments on grams' do
      gram = FactoryGirl.create(:gram)
      user = FactoryGirl.create(:user)
      sign_in user
      post :create, params: { gram_id: gram.id, comment: { message: 'nice gram!' } }
      expect(response).to redirect_to root_path
      expect(gram.comments.size).to eq 1
      expect(gram.comments.last.message).to eq 'nice gram!'
    end

    it 'should require user login to comment on a gram' do
      gram = FactoryGirl.create(:gram)
      post :create, params: { gram_id: gram.id, comment: { message: 'nice gram!' } }
      expect(response).to redirect_to new_user_session_path
    end

    it 'should respond with not_found if a gram is not found' do
      user = FactoryGirl.create(:user)
      sign_in user
      post :create, params: { gram_id: 'NOPE', comment: { message: 'nice gram!' } }
      expect(response).to have_http_status(:not_found)
    end
  end
end
