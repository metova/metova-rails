describe Api::PostsController do
  let(:user) { users(:logan) }
  before { user.update token_expires_at: Time.current + 1.day }

  describe 'PUT update' do
    it 'does not show the post JSON by default' do
      put :update, id: posts(:logan), post: { title: 'Updated' }
      expect(response).to have_http_status 204
      expect(response.body).to be_blank
    end

    it 'shows the post JSON when overriding display_on_put_and_delete?' do
      expect(subject).to receive(:display_resource_on_put_and_delete?) { true }
      put :update, id: posts(:logan), post: { title: 'Updated' }
      expect(response).to have_http_status 200
      # expect(response).to have_http_status 204
      # expect(response.body).to be_blank
    end
  end

  describe 'DELETE destroy' do
    it 'does not show the post JSON by default' do
      put :update, id: posts(:logan), post: { title: 'Updated' }
      expect(response).to have_http_status 204
      expect(response.body).to be_blank
    end
  end
end
