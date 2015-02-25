describe Api::PostsController do
  let(:user) { users(:logan) }
  before { user.update token_expires_at: Time.current + 1.day }

  describe '#secret' do
    describe 'returns an error when token authentication fails' do
      it 'due to an incorrect token' do
        request.env['HTTP_AUTHORIZATION'] = "Token token=dickbutt, id=#{user.id}"
        get :secret
        expect(response.status).to eq 401
        expect(json[:error]).to eq 'Invalid authentication token'
      end

      it 'due to an expired token' do
        user.update_columns token_expires_at: Time.current - 1.day
        request.env['HTTP_AUTHORIZATION'] = "Token token=#{user.authentication_token}, id=#{user.id}"
        get :secret
        expect(response.status).to eq 401
        expect(json[:error]).to eq 'Invalid authentication token'
      end
    end

    it 'requires email to be sent to prevent timing attacks' do
      request.env['HTTP_AUTHORIZATION'] = "Token token=#{user.authentication_token}"
      get :secret
      expect(response.status).to eq 401
    end

    it 'returns a 204 when the auth token checks out' do
      request.env['HTTP_AUTHORIZATION'] = "Token token=#{user.authentication_token}, id=#{user.id}"
      get :secret
      expect(response.status).to eq 204
    end
  end
end