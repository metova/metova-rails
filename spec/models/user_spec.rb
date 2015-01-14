describe User do

  it 'generates an authentication token' do
    user = User.create email: 'tokens@test.com', password: 'metova123'
    expect(user.authentication_token).to be_present
  end

end