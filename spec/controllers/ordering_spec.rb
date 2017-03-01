describe Api::PostsController do
  let(:user) { users(:logan) }
  before { user.update token_expires_at: Time.current + 1.day }

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
