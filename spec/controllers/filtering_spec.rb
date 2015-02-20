describe Api::PostsController do
  let(:user) { users(:logan) }
  before { user.update token_expires_at: Time.current + 1.day }

  describe '?query=something filtering' do
    it 'should filter posts based on the query' do
      get :index, user_id: user, query: 'aa'
      expect(json.size).to be 1
      expect(json.map{ |h| h[:id] }).to match_array [posts(:a).id]

      get :index, user_id: user, query: 'bb'
      expect(json.size).to be 1
      expect(json.map{ |h| h[:id] }).to match_array [posts(:b).id]
    end
  end
end