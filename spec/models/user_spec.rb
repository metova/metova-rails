describe User do
  subject{ User.create email: 'tokens@test.com', password: 'metova123' }
  it 'generates an authentication token with expiration' do
    expect(subject.authentication_token).to be_present
    expect(subject.token_expires_at).to be_present
  end

  it 'knows when the token is expired' do
    expect(subject.token_expired?).to be_falsy
    subject.update_columns token_expires_at: nil
    expect(subject.token_expired?).to be_truthy
    subject.update_columns token_expires_at: Date.today - 1.day
    expect(subject.token_expired?).to be_truthy
  end
end