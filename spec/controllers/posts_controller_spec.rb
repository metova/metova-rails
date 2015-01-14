describe Api::PostsController do
  let(:user) { users(:logan) }

  describe '#secret' do
    it 'returns an error when token authentication fails' do
      request.env['HTTP_AUTHORIZATION'] = "Token token=dickbutt"
      get :secret
      expect(response.status).to eq 401
      expect(json[:error]).to eq 'Invalid authentication token'
    end

    it 'returns a 204 when the auth token checks out' do
      request.env['HTTP_AUTHORIZATION'] = "Token token=#{user.authentication_token}"
      get :secret
      expect(response.status).to eq 204
    end
  end

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

  describe '?ids=x,y,z filtering' do
    before do
      10.times { user.posts.create title: 'Title', body: 'Body' }
    end

    it 'only returns the posts that have ids present in the ids parameter' do
      posts = user.posts.pluck(:id).sample(5)
      get :index, user_id: user, ids: posts.join(',')
      expect(json.size).to be 5
      expect(json.map { |h| h[:id] }).to match_array posts
    end
  end

  describe 'order and order direction' do
    it 'returns the posts in asc order (default direction)' do
      get :index, user_id: user, sort: 'title'
      expect(json[0]['title']).to eq 'AAA'
      expect(json[1]['title']).to eq 'BBB'
      expect(json[2]['title']).to eq 'CCC'
    end

    it 'returns the posts in desc order (using direction parameter)' do
      get :index, user_id: user, sort: 'title', direction: 'desc'
      expect(json[0]['title']).to eq 'Hey'
      expect(json[1]['title']).to eq 'CCC'
      expect(json[2]['title']).to eq 'BBB'
    end
  end

end