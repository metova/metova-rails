describe Metova::API::SessionsController do
  before do
    @request.env['devise.mapping'] = Devise.mappings[:user]
  end

  context 'Twitter login' do
    before do
      stub_request(:get, %r[api.twitter.com/1.1/account/verify_credentials]).to_return \
        body: File.read(File.expand_path('../../../../support/stubs/twitter/verify_credentials.json', __FILE__))
    end

    it 'uses the provider, token secret, and access token to get the UID' do
      post :create, access_token: 'token123', token_secret: 'secret123', provider: 'twitter'
      expect(assigns(:identity).provider).to eq 'twitter'
      expect(assigns(:identity).uid).to eq '19999'
    end

    context 'user already exists with the UID' do
      it "returns the user's auth token" do
        Metova::Identity.create user: users(:logan), uid: '19999', provider: 'twitter'
        post :create, access_token: 'token123', token_secret: 'secret123', provider: 'twitter'
        expect(response).to have_http_status 201
        expect(json[:authentication_token]).to eq users(:logan).reload.authentication_token
      end
    end

    context 'user does not exist but identity could not be created' do
      before do
        stub_request(:get, %r[api.twitter.com/1.1/account/verify_credentials]).to_return \
          body: File.read(File.expand_path('../../../../support/stubs/twitter/verify_credentials_failure.401.json', __FILE__))
      end

      it "does not save the user" do
        expect {
          post :create, user: { email: 'test@metova.com' }, access_token: 'token123', token_secret: 'secret123', provider: 'twitter'
        }.to_not change(User, :count)
      end

      it "returns an appropriate error message" do
        post :create, user: { email: 'test@metova.com' }, access_token: 'token123', token_secret: 'secret123', provider: 'twitter'
        expect(response).to have_http_status 401
        expect(json[:errors]).to include 'Twitter authentication failed'
      end
    end

    context 'user does not exist with the UID and cannot be created' do
      it "returns the errors on the user" do
        post :create, access_token: 'token123', token_secret: 'secret123', provider: 'twitter'
        expect(response).to have_http_status 422
      end

      it 'can send the required info with the request to be merged with the OAuth info to create a valid user' do
        expect {
          post :create, user: { email: 'test@metova.com' }, access_token: 'token123', token_secret: 'secret123', provider: 'twitter'
        }.to change(User, :count).by 1

        expect(response).to have_http_status 201
        expect(json[:email]).to eq 'test@metova.com'
        expect(User.last.identities.count).to eq 1
        expect(Metova::Identity.last.provider).to eq 'twitter'
        expect(Metova::Identity.last.uid).to eq '19999'
      end
    end
  end

  context 'Flux login' do
    before do
      stub_request(:get, %r[id.fluxhq.io/api/v1/me]).to_return body: File.read(File.expand_path('../../../../support/stubs/flux/me.json', __FILE__))
    end

    it 'uses the provider, token secret, and access token to get the UID' do
      post :create, access_token: 'token123', provider: 'flux'
      expect(assigns(:identity).provider).to eq 'flux'
      expect(assigns(:identity).uid).to eq '29999'
    end

    context 'user already exists with the UID' do
      it "return the user's auth token" do
        Metova::Identity.create user: users(:logan), uid: '29999', provider: 'flux'
        post :create, access_token: 'token123', provider: 'flux'
        expect(response).to have_http_status 201
        expect(json[:authentication_token]).to eq users(:logan).reload.authentication_token
      end
    end

    context 'user does not exist with the UID' do
      it 'creates a user and returns their auth token' do
        expect {
          post :create, access_token: 'token123', provider: 'flux'
        }.to change(User, :count).by 1

        expect(response).to have_http_status 201
        expect(json[:email]).to eq 'test@metova.com'
      end
    end
  end

  context 'Facebook login' do
    before do
      stub_request(:get, %r[graph.facebook.com/v2.3/me]).to_return body: File.read(File.expand_path('../../../../support/stubs/facebook/me.json', __FILE__))
    end

    it 'uses the provider, token secret, and access token to get the UID' do
      post :create, access_token: 'token123', provider: 'facebook'
      expect(assigns(:identity).provider).to eq 'facebook'
      expect(assigns(:identity).uid).to eq '39999'
    end

    context 'user already exists with the UID' do
      it "return the user's auth token" do
        Metova::Identity.create user: users(:logan), uid: '39999', provider: 'facebook'
        post :create, access_token: 'token123', provider: 'facebook'
        expect(response).to have_http_status 201
        expect(json[:authentication_token]).to eq users(:logan).reload.authentication_token
      end
    end

    context 'user does not exist with the UID' do
      it 'creates a user and returns their auth token' do
        expect {
          post :create, access_token: 'token123', provider: 'facebook'
        }.to change(User, :count).by 1

        expect(response).to have_http_status 201
        expect(json[:email]).to eq 'test@metova.com'
      end
    end
  end

  context 'User is signed in' do
    let(:user) { users(:logan) }

    it 'creates a new identity and links it to the current user' do
      stub_request(:get, %r[graph.facebook.com/v2.3/me]).to_return body: File.read(File.expand_path('../../../../support/stubs/facebook/me.json', __FILE__))
      user.update token_expires_at: Time.current + 1.day
      request.env['HTTP_AUTHORIZATION'] = "Token token=#{user.authentication_token}, id=#{user.id}"

      expect {
        post :create, access_token: 'token123', provider: 'facebook'
      }.to change { user.reload.identities.size }.by 1
    end
  end
end
