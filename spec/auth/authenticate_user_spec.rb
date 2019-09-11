require 'rails_helper'

RSpec.describe AuthenticateUser do
  let(:user) { create(:user) }
  subject(:valid_auth_obj) { described_class.new(user.email, user.password) }
  subject(:invalid_auth_obj) { described_class.new('foo', 'bar') }

  describe '#call' do
    context 'when invalid credentials' do
      it 'raized an authentication error' do
        expect { invalid_auth_obj.call }.to raise_error(ExceptionHandler::AuthenticationError, /Invalid credentials/)
      end
    end
  end
end