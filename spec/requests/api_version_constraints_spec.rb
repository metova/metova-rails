describe 'API version constraints' do
  let(:user) { users(:logan) }

  it 'routes properly without a version because the current version is 1' do
    get '/api/posts', user_id: user.id
    expect(response).to be_successful
  end

  it 'routes properly when version is set to the current version' do
    get '/api/posts', { user_id: user.id }, { 'HTTP_ACCEPT' => 'application/json; version=1' }
    expect(response).to be_successful
  end

  it 'returns a 412 error when improper version is sent' do
    get '/api/posts', { user_id: user.id }, { 'HTTP_ACCEPT' => 'application/json; version=100' }
    expect(response.status).to eq 412
    expect(json['errors']).to be_present
  end

end