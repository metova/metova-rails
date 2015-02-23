describe Post do
  subject{ posts(:a) }
  it 'can be filtered' do
    expect(Post.respond_to?(:filter)).to be_truthy
    expect(Post.filter('aa')).to match_array [posts(:a)]
    expect(Post.filter('bb')).to eq [posts(:b)]
    expect(Post.filter('cc')).to eq [posts(:c)]
  end

  it 'can be filtered with other attributes' do
    expect(Post.filter('Hey', :title)).to eq [posts(:logan)]
    expect(Post.filter('Hey', :body)).to eq []
  end
end