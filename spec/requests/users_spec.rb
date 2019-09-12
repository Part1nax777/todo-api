require 'rails_helper'

RSpec.describe 'Users API', type: :request do
  let(:user) { create(:user) }
  let(:headers) { valid_headers.except('Authorization') }
  let(:valid_attributes) do
    attributes_for(:user, password_confirmation: user.password)
  end

  describe 'POST /signup' do
    context 'when valid request' do
      before { post '/signup', params: valid_attributes.to_json, headers: headers }

      it 'create new user response 201' do
        expect(response).to have_http_status(201)
      end

      it 'return success message' do
        expect(json['message']).to match(/Account created successfully/)
      end

      it 'return auth token' do
        expect(json['auth_token']).to_not be_nil
      end
    end

    context 'when invalid request' do
      before { post '/signup', params: {}, headers: headers }

      it 'does not create a new user' do
        expect(response).to have_http_status(500)
      end

      it 'return failure message' do
        expect(json['message']).to match(/Validation failed: Name can't be blank, Email can't be blank/)
      end
    end
  end
end