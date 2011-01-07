Given /^I am logged in as "([^"]*)"$/ do |arg1|
  Given %{I am on the home page}
  And   %{I follow "Sign up"}
  And   %{I fill in "bob@example.com" for "user_email"}
  And   %{I fill in "Bob" for "user_username"}
  And   %{I fill in "testforbob" for "user_password"}
  And   %{I fill in "testforbob" for "user_password_confirmation"}
  And   %{I fill in "dummy_code" for "user_invite_code"}
  And   %{I press "Sign up"}
  And   %{I follow "Login"}
  And   %{I fill in "bob@example.com" for "user_email"}
  And   %{I fill in "testforbob" for "user_password"}
  And   %{I press "Sign in"}
end

Then /^I should have one item$/ do
  Item.count.should == 1
end