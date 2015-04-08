describe Metova::S3Controller do

  routes { Metova::Engine.routes }

  before do
    require 'refile/backend/s3'
    aws = {
      access_key_id: 'AWS_KEY123',
      secret_access_key: 'AWS_SECRET123',
      bucket: "metova-rails",
    }
    Refile.cache = Refile::Backend::S3.new(prefix: 'cache', **aws)
    Refile.store = Refile::Backend::S3.new(prefix: 'store', **aws)
  end

  it 'returns a presigned URL signature' do
    get :presigned_url, format: :json
    expect(json[:as]).to eq 'file'
    expect(json[:id]).to be_present
    expect(json[:url]).to eq 'https://metova-rails.s3.amazonaws.com/'
    expect(json[:fields][:AWSAccessKeyId]).to eq 'AWS_KEY123'
    expect(json[:fields][:key]).to eq "store/#{json[:id]}"
    expect(json[:fields][:policy]).to be_present
    expect(json[:fields][:signature]).to be_present
  end

end
