describe Api::RegistrationsController do
  
  before do
  	@request.env['devise.mapping'] = Devise.mappings[:api_user]
  end

  it 'logs errors when requests fail with a code of 422' do
    post :create, user: { email: 'test@testing.com', password: 'foo' }
    expect(response.status).to eq 422
    assert_response :unprocessable_entity
  end

end