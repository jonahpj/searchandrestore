Then /^I log\s?in with "([^"]+)" and "([^"]+)"$/ do |email, password|
  fill_in "Email", :with => email
  fill_in "Password", :with => password
  click_button "Login"
end

Given /^I am logged in(?: as an (admin) user)?$/ do |role|
  email = Faker::Internet.email
  password = 'password123'

  role ||= 'user'
  the.user = Factory(role.to_sym,
                     :email => email,
                     :password => password,
                     :password_confirmation => password)

  Then %{I go to the login page}
  Then %{I log in with "#{email}" and "#{password}"}
end

Given /^I am not logged in$/ do
  # no-op
end
