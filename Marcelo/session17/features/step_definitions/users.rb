Given(/^I have set a connection to application$/) do
	@http_connection = Rest_service.get_connection #variable de instancia
end

When(/^I send a (PUT|POST) request to (.?*) with json$/) do |method, end_point, json_text|
	http_request = Rest_service.get_request(method, end_point)
	http_request.body = json_text
	@http_response = Rest_service.execute_request(@http_connection, http_request)
	@last_json = @http_response.body
end

Then(/^I expect HTTP code (\d+)$/) do |http_code|
	puts "RESPONSE STATUS CODE: #{@http_response.code}"
	puts "RESPONSE BODY: #{@http_response.body}"
	expect(@http_response.code).to eql(http_code)
end

When(/^I send a (GET) request to (\/user\.json)$/) do |method, end_point|
	http_request = Rest_service.get_request(method, end_point)
	@http_response = Rest_service.execute_request(@http_connection, http_request)
	@last_json = @http_response.body
end

Then /^I expect JSON equal to$/ do |json_text|
  expect(@last_json).to be_json_eql json_text
end