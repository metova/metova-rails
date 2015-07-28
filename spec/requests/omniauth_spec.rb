OmniAuth.config.test_mode = true

describe 'Omniauth integration' do
  context 'User is not logged in' do
    it "logs the user into their existing account if they've logged in with it before" do
      Metova::Identity.create! provider: 'twitter', uid: '12345', user: users(:logan)
      OmniAuth.config.mock_auth[:twitter] = OmniAuth::AuthHash.new({ provider: 'twitter', uid: '12345' })

      visit new_user_session_path
      click_on 'Sign in with Twitter'
      expect(page).to have_content 'You are logged in as logan.serman@metova.com'
    end

    context 'OAuth provides enough information to generate a valid user' do
      before do
        OmniAuth.config.mock_auth[:twitter] = OmniAuth::AuthHash.new({
          provider: 'twitter',
          uid: '12345',
          info: {
            email: 'test@metova.com'
          }
        })
      end

      it "creates a new user with a temporary password if they haven't logged in with it before" do
        visit new_user_session_path
        expect {
          click_on 'Sign in with Twitter'
          expect(page).to have_content 'You are logged in as test@metova.com'
        }.to change(User, :count).by 1
      end
    end

    context 'OAuth does not provide enough information to generate a valid user (Twitter in most cases)' do
      before do
        OmniAuth.config.mock_auth[:twitter] = OmniAuth::AuthHash.new({ provider: 'twitter', uid: '12345', info: {} })
      end

      it 'shows the registration page and asks the user to complete the remaining fields' do
        visit new_user_session_path
        click_on 'Sign in with Twitter'
        expect(page).to have_content 'Sign up'
        fill_in 'user[email]', with: 'test@metova.com'
        click_on 'Sign up'
        expect(page).to have_content 'You are logged in as test@metova.com'
        expect(User.last.identities.size).to eq 1
        Metova::Identity.last.tap do |identity|
          expect(identity.provider).to eq 'twitter'
          expect(identity.uid).to eq '12345'
        end
      end
    end
  end
end
