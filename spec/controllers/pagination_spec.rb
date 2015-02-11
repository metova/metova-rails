describe Api::PostsController do
  let(:user) { users(:logan) }
  before { user.update token_expires_at: Time.current + 1.day }

  describe 'pagination' do
    before do
      20.times { user.posts.create title: 'Title', body: 'Body' }
    end

    it 'does not paginate by default' do
      get :index, user_id: user
      expect(json.size).to be user.posts.size
    end

    it 'paginates when the page parameters are sent' do
      get :index, user_id: user, page: 2, limit: 5
      expect(json.size).to be 5
      ids = json.map { |h| h[:id] }
      expect(ids).to eq user.posts.limit(5).offset(5).pluck(:id)
    end

    it 'returns an error message when the page param is present but the limit param isnt' do
      get :index, user_id: user, page: 1
      expect(response.status).to eq 400
      expect(json[:errors]).to include "The 'page' param was sent without 'limit'"
    end

    it 'returns an error message when the limit param is present but the page param isnt' do
      get :index, user_id: user, limit: 20
      expect(json[:errors]).to include "The 'limit' param was sent without 'page'"
    end

    it 'has a link header for next' do
      get :index, user_id: user, page: 1, limit: 5
      expect(response.headers['Link']).to match %r[api/posts\?limit=5&page=2(.*)?\srel="next"]
    end

    it 'has a link header for last' do
      get :index, user_id: user, page: 1, limit: 5
      expect(response.headers['Link']).to match %r[api/posts\?limit=5&page=5(.*)?\srel="last"]
    end
  end
end