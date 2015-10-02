describe Metova::Oauth::TwitterProvider do
  let(:twitter) { Metova::Oauth::TwitterProvider.new 'test123', 'secret123' }

  describe '#consumer' do
    it 'uses the devise config to get the consumer key/secret' do
      expect(twitter.consumer.key).to eq 'TOKEN'
      expect(twitter.consumer.secret).to eq 'SECRET'
    end

    it 'throws an exception when Devise is not configured for the provider' do
      expect(::Devise).to receive(:omniauth_configs) { Hash.new }
      expect { twitter.consumer }.to raise_error Metova::Oauth::Error::DeviseNotConfigured
    end
  end
end
