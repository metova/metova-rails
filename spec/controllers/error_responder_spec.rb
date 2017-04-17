describe Api::RegistrationsController do
  
  before { @request.env['devise.mapping'] = Devise.mappings[:api_user] }

  it 'logs errors when requests cannot be processed' do
  	initialMessageCount = getTestLogWordCount("error(s):")
    post :create, user: { email: 'test@testing.com', password: 'foo' }
    expect(response.status).to eq 422
    assert_response :unprocessable_entity
    finalMessageCount = getTestLogWordCount("error(s):")
    assert_operator initialMessageCount, :<, finalMessageCount
  end

private

  def getTestLogWordCount(word)
    test_log = File.open("./spec/dummy/log/test.log")
    contents = test_log.read
    wordCount = 0
    contents.split(' ').each do |item|
      wordCount +=1 if item == word
    end
    wordCount
  end

end