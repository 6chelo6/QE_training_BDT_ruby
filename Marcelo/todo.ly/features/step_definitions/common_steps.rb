# Author : Igor Santa Cruz

Given(/^I have the next user to use in the Authentication$/) do |user_values|
  current_user = user_values.raw[1]
  @user_mail = current_user[0]
  @user_password = current_user[1]
end


When /^I send a (PUT|POST) request without Autentication to (.*?) with json$/ do |method, end_point, json_text|
  http_request = Rest_service.get_no_auth(method, end_point)
  http_request.body = json_text
  @http_response = Rest_service.execute_request(@http_connection, http_request)
   @last_json = @http_response.body
end

When /^I send a (PUT|POST) request with last user credentials to (.*?) with json$/ do |method, end_point, json_text|
  http_request = Rest_service.get_request(method, end_point, @user_mail, @user_password)
  http_request.body = json_text
  @http_response = Rest_service.execute_request(@http_connection, http_request)
   @last_json = @http_response.body
end

When /^I send a (GET) request to "(.*?)"$/ do |method, end_point|
  http_request = Rest_service.get_request(method, end_point)
  @http_response = Rest_service.execute_request(@http_connection, http_request)
   @last_json = @http_response.body
end

When /^I send a (GET|DELETE) request with last user credentials to "(.*?)"$/ do |method, end_point|
  http_request = Rest_service.get_request(method, end_point, @user_mail, @user_password)
  @http_response = Rest_service.execute_request(@http_connection, http_request)
   @last_json = @http_response.body
end

Then /^I expect JSON equal to$/ do |json_text|
  expect(@last_json).to be_json_eql json_text
end

Then(/^I expect the next fields and values on response:$/) do |json_text|
  expected_values= JSON.parse(json_text).to_a
  response_values = JSON.parse(@last_json).to_a
  diff = expected_values - response_values
  puts diff
  expect(diff.empty?).to be true
end