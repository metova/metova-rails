describe Api::PostsController do
  let(:user) { users(:logan) }

  describe 'pagination' do
    before do
      20.times { user.posts.create title: 'Title', body: 'Body' }
    end

    it 'does not paginate by default' do
      get :index, user_id: user
      expect(json.size).to be user.posts.size
    end

    it 'paginates when the page parameters are sent' do
      get :index, user_id: user, page: 2, per_page: 5
      expect(json.size).to be 5
      ids = json.map { |h| h[:id] }
      expect(ids).to eq user.posts.limit(5).offset(5).pluck(:id)
    end

    it 'returns an error message when the page param is present but the per_page param isnt' do
      get :index, user_id: user, page: 1
      expect(json[:errors]).to include "'page' param sent without 'per_page'"
    end

    it 'returns an error message when the per_page param is present but the page param isnt' do
      get :index, user_id: user, per_page: 20
      expect(json[:errors]).to include "'per_page' param sent without 'page'"
    end
  end

end