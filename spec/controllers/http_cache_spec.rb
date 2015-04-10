describe Api::PostsController do
  let(:user) { users(:logan) }
  let(:post) { posts(:logan) }

  before { user.update token_expires_at: Time.current + 1.day }

  describe 'http caching' do
    around do |example|
      ActionController::Base.perform_caching = true
      example.run
      ActionController::Base.perform_caching = false
    end

    it 'should return an e-tag' do
      get :show, id: post
      expect(response.headers['ETag']).to be_present
    end

    it 'returns 304 when given an e-tag' do
      get :show, id: post
      request.headers['If-None-Match'] = response.headers['ETag']
      get :show, id: post
      expect(response.status).to eq 304
      expect(response.body).to be_blank
    end

    it 'returns a 200 again after updating the post' do
      get :show, id: post
      request.headers['If-None-Match'] = response.headers['ETag']
      get :show, id: post
      expect(response.status).to eq 304
      post.update!(title: 'Updated title') and sleep(0.5)
      get :show, id: post
      expect(response.status).to eq 200
    end

    it 'does not cache if cache param is false' do
      get :show, id: post
      request.headers['If-None-Match'] = response.headers['ETag']
      get :show, id: post, cache: false
      expect(response.status).to eq 200
    end
  end
end
