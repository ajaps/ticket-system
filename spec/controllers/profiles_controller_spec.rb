require 'rails_helper'

RSpec.describe ProfilesController, type: :controller do
  let(:user) { create(:user) }
  let(:user2) { create(:user) }
  let(:agent) { create(:user, :agent) }
  let(:admin) { create(:user, :admin) }

  describe '#index' do
    context 'Profile Index page' do
      it 'should redirect to home page when signed in as a non-admin' do
        sign_in agent

        get :index

        expect(flash[:error]).to eq 'You must be an Admin to perform this operation'
        assert_redirected_to root_path
      end

      it 'show load successfully when signed in as an Admin' do
        sign_in admin

        get :index

        expect(flash[:error]).to be_nil
        assert_response :success
      end
    end
  end

  describe '#update' do
    context 'Convert user to Admin or Agent' do
      it 'should fail when signed in as a non-admin' do
        sign_in agent

        put :update, params: { id: user.id, admin: true }

        expect(flash[:error]).to eq 'You must be an Admin to perform this operation'
        assert_redirected_to root_path
      end

      it 'should succeed when signed in as an Admin' do
        sign_in admin

        put :update, params: { id: user.id, agent: true }

        expect(flash[:notice]).to eq 'User was updated successfully'
        assert_redirected_to profiles_path
      end
    end
  end

  describe '#destroy' do
    it 'is successfull when logged in as an Admin' do
      sign_in admin

      delete :destroy, params: { id: user2.id }

      expect(flash[:notice]).to eq 'User account was deleted succesfully'
      assert_redirected_to profiles_path
    end
  end
end
