Factory.define :user do |f|
  f.sequence(:email) {|n| "bob#{n}@example.com" }
  f.username "Bob"
  f.password "password"
  f.invite_code "dummy_code"
end