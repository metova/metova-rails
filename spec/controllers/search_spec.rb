describe Api::PostsController do
  let(:user) { users(:logan) }
  before { user.update token_expires_at: Time.current + 1.day }

  describe 'searching' do
    it 'searches based on any text column' do
      get :index, user_id: user, search: { query: 'AA' }
      expect(json.size).to eq 1
      expect(json[0]['title']).to eq 'AAA'
    end

    it 'searches based on a specific column' do
      get :index, user_id: user, search: { query: { body: 'Aaa' } }
      expect(json.size).to eq 1
      expect(json[0]['title']).to eq 'AAA'
    end

    it 'supports OR operator on separate fields' do
      get :index, user_id: user, search: { query: { body: 'Aaa', title: 'BBB' }, _operator: 'or' }
      expect(json.size).to eq 2
      expect(json[0]['title']).to eq 'AAA'
      expect(json[1]['title']).to eq 'BBB'
    end

    it 'supports fuzzy search' do
      get :index, user_id: user, search: { query: { body: 'Aaa bcd' }, _fuzzy: 1 }
      expect(json.size).to eq 1
      expect(json[0]['title']).to eq 'AAA'
    end
  end

end