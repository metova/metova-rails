describe 'Submitting feedback' do
  let(:user) { users(:logan) }

  context 'No Flux ENV set' do
    it 'tells the user that the project configuration is wrong' do
      visit metova.new_feedback_path
      fill_in 'feedback_body', with: 'Test'
      click_button 'Submit'
      expect(page).to have_content 'The feedback URL is not properly setup!'
      expect(page).to have_content 'The feedback project key is not properly setup!'
      expect(page).to have_content 'The feedback project token is not properly setup!'
    end
  end

  context 'Flux ENV set' do
    before do
      ENV['FLUX_API_URL'] = 'https://fluxhq.io/api'
      ENV['FLUX_PROJECT_KEY'] = 'TEST'
      ENV['FLUX_PROJECT_TOKEN'] = '123456890'
      stub_request(:post, %r[fluxhq.io\/api\/tasks]).to_return status: 201
    end

    context 'Flux call successful' do
      before do
        stub_request(:post, %r[fluxhq.io\/api\/tasks]).to_return status: 201
      end

      it 'submits the feedback to Flux' do
        visit metova.new_feedback_path
        fill_in 'feedback_body', with: 'Test'
        click_button 'Submit'
        expect(WebMock).to have_requested(:post, %r[fluxhq.io\/api\/tasks]).with \
          body: { project_key: 'TEST', task: { actor: '', action: ': Test', benefit: '', task_type: 'admin' } },
          headers: { 'Accept' => '*/*, version=2', 'Authorization' => 'Token token=123456890, project_key=TEST' }
        expect(page).to have_content 'Your feedback was submitted successfully!'
      end
    end

    context 'Flux call failed' do
      before do
        stub_request(:post, %r[fluxhq.io\/api\/tasks]).to_return status: 422
      end

      it 'submits the feedback to Flux' do
        visit metova.new_feedback_path
        fill_in 'feedback_body', with: 'Test'
        click_button 'Submit'
        expect(WebMock).to have_requested(:post, %r[fluxhq.io\/api\/tasks]).with \
          body: { project_key: 'TEST', task: { actor: '', action: ': Test', benefit: '', task_type: 'admin' } },
          headers: { 'Accept' => '*/*, version=2', 'Authorization' => 'Token token=123456890, project_key=TEST' }
        expect(page).to have_content 'There was an error submitting feedback.'
      end
    end
  end

end