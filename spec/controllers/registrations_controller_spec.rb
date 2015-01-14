describe Api::RegistrationsController do

  before do
    @request.env['devise.mapping'] = Devise.mappings[:api_user]
  end

  it 'signs up a user' do
    post :create, user: { email: 'test@testerson.com', password: 'metova134' }
    expect(response.status).to eq 201
  end

  it 'displays errors about the sign up' do
    post :create, user: { email: 'test@testerson.com', password: 'short' }
    expect(response.status).to eq 422
    expect(json[:errors][0]).to match /Password is too short/
  end

end