describe Api::PostsController do
  let(:user) { users(:logan) }
  before { user.update token_expires_at: Time.current + 1.day }

  describe '?include=user' do
    it 'only returns the posts that have ids present in the ids parameter' do
      get :show, id: posts(:logan)
      # TODO how to test w/o relying on AMS 0.10.0?
    end
  end
end
