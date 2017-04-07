feature 'Sign Up' do

  scenario 'displays welcome message when signing up' do
    expect { sign_up }.to change(User, :count).by(1)
    expect(page).to have_content('Welcome, banana@gmail.com')
    expect(User.first.email).to eq('banana@gmail.com')
  end


end
