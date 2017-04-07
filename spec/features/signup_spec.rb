feature 'Sign Up' do

  scenario 'displays welcome message when signing up' do
    expect { sign_up }.to change(User, :count).by(1)
    expect(page).to have_content('Welcome, banana@gmail.com')
    expect(User.first.email).to eq('banana@gmail.com')
  end

  scenario "if passwords don't match then don't make a new user" do
    user_count = User.all.length
    visit '/users/new'
    fill_in('email', with: 'banana@gmail.com')
    fill_in('password', with: '123banana')
    fill_in('password_confirmation', with: '123')
    click_button('Sign up')
    expect(User.count).to eq(user_count)
  end


end
