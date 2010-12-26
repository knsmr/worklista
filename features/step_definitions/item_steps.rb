Given /^the following items:$/ do |items|
  Item.create!(items.hashes)
end

When /^I delete the (\d+)(?:st|nd|rd|th) item$/ do |pos|
  visit items_path
  within("table tr:nth-child(#{pos.to_i+1})") do
    click_link "Destroy"
  end
end

Then /^I should see the following items:$/ do |expected_items_table|
  expected_items_table.diff!(tableish('table tr', 'td,th'))
end

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