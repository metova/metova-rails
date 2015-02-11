describe Api::PostsController do
  let(:user) { users(:logan) }
  before { user.update token_expires_at: Time.current + 1.day }

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
end