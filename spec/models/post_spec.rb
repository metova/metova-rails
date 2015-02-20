describe Post do
  subject{ posts(:a) }
  it 'can be filtered' do
    expect(Post.respond_to?(:filter)).to be_truthy
    expect(Post.filter('aa')).to match_array [posts(:a)]
    expect(Post.filter('bb')).to eq [posts(:b)]
    expect(Post.filter('cc')).to eq [posts(:c)]
  end
end